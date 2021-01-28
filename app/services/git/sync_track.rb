class Git::SyncTrack
  include Mandate

  attr_reader :state_db, :track

  def initialize(track)
    @state_db = Git::StateDb.instance
    @track = track
    @unlocked_by_relationships = {}
  end

  def call
    return

    if repo_url.start_with?("http://example.com")
      puts "Skipping sync for #{repo_url}"
      state_db.mark_synced(track)
      return
    end
    sync_track_metadata
    setup_exercises
    sync_maintainers
    populate_unlocked_by_relationships
    state_db.mark_synced(track)
  rescue => e
    state_db.mark_failed(track)
    raise
  end

  private

  def populate_unlocked_by_relationships
    @unlocked_by_relationships.each do |exercise_uuid, unlocked_by_slug|
      exercise = track.exercises.find_by(uuid: exercise_uuid)
      unlocked_by = track.exercises.find_by(slug: unlocked_by_slug)
      exercise.update!(unlocked_by: unlocked_by)
    end
  end

  def create_or_update_exercise(exercise_slug, exercise_uuid, exercise_data)
    if current_exercises_uuids.include?(exercise_uuid)
      ex = track.exercises.find_by(uuid: exercise_uuid)
      ex.update!(exercise_data)
    else
      exercise_data.merge!({
        uuid: exercise_uuid
      })
      ex = Exercise.new(exercise_data)
      track.exercises << ex
    end
  end

  memoize
  def current_exercises_uuids
    track.exercises.map {|ex| ex[:uuid] }
  end

  def setup_exercises
    exercises.each.with_index do |exercise, position|
      exercise_slug = exercise[:slug]
      exercise_uuid = exercise[:uuid]
      deprecated = !!exercise[:deprecated]
      if exercise_slug.blank? || exercise_uuid.blank?
        puts "Skipping exercise #{exercise}"
      elsif deprecated
        sync_exercise(exercise_slug, exercise_uuid, exercise, position)
        deprecate_exercise(exercise_uuid)
      else
        sync_exercise(exercise_slug, exercise_uuid, exercise, position)
      end
    end
  end

  def deprecate_exercise(exercise_uuid)
    ex = track.exercises.find_by(uuid: exercise_uuid)
    ex.update!(active: false) unless ex.nil?
  end

  def sync_exercise(exercise_slug, exercise_uuid, exercise, position)
    unlocked_by = exercise[:unlocked_by]
    @unlocked_by_relationships[exercise_uuid] = unlocked_by

    # Some tracks have old config without keys and others
    # have new config with keys. Even when the keys are present,
    # they're sometimes set to null.
    topic_slugs = exercise[:topics] || []
    topics = topic_slugs.map { |slug| Topic.find_or_create_by(slug: slug) }

    exercise_image_stem = exercise_slug.gsub("_", "-")

    ex = repo.exercise(exercise_slug, repo.head)
    blurb = ex.blurb || standard_blurb_for(exercise_slug)
    description = ex.description || standard_description_for(exercise_slug)
    title = standard_title_for(exercise_slug) || exercise_slug.titleize

    exercise_data = {
      slug: exercise_slug,
      title: title,
      core: respect_core?? exercise.fetch(:core, false) : (position <= 10),
      active: exercise.fetch(:active, true),
      position: position,
      difficulty: exercise.fetch(:difficulty, 1),
      length: exercise.fetch(:length, 1),
      topics: topics,
      blurb: blurb,
      description: description,
      dark_icon_url: "https://assets.exercism.io/exercises/#{exercise_slug}-dark.png",
      turquoise_icon_url: "https://assets.exercism.io/exercises/#{exercise_slug}-turquoise.png",
      white_icon_url: "https://assets.exercism.io/exercises/#{exercise_slug}-white.png",
    }

    create_or_update_exercise(exercise_slug, exercise_uuid, exercise_data)
  end

  def sync_track_metadata
    track.update!(
      introduction: track_introduction,
      code_sample: code_sample,
      active: active
    )
  end

  def track_introduction
    config[:blurb] || ""
  end

  def active
    config[:active]
  end

  def code_sample
    repo.snippet_file || ""
  rescue => e
    Bugsnag.notify(e)
    ""
  end

  def sync_maintainers
    puts "Syncing Maintainers" unless Rails.env.test?
    Git::SyncMaintainers.(track, repo.maintainer_config)
  end

  def exercises
    config[:exercises] || []
  end

  def config
    @config ||= repo.config
  end

  def repo_url
    track.repo_url
  end

  def repo
    @repo ||= Git::ExercismRepo.new(repo_url, auto_fetch: true)
  end

  def standard_description_for(exercise_slug)
    ex = standard_spec_for(exercise_slug)
    return nil if ex.nil?
    ex.description
  end

  def standard_blurb_for(exercise_slug)
    ex = standard_spec_for(exercise_slug)
    return nil if ex.nil?
    ex.blurb
  end

  def standard_spec_for(exercise_slug)
    problem_specifications.exercises[exercise_slug]
  end

  def standard_title_for(exercise_slug)
    ex = standard_spec_for(exercise_slug)
    return nil if ex.nil?
    ex.title
  end

  def problem_specifications
    @problem_specifications ||= begin
      ps = Git::ProblemSpecifications.head
      ps.fetch!
      ps
    end
  end

  def respect_core?
    return @respect_core unless @respect_core === nil
    @respect_core = exercises.any? { |e| e[:core] }
  end
end
