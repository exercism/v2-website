class Git::SyncsTrack

  def self.sync!(track)
    new(Git::StateDb.instance, track).sync!
  end

  attr_reader :state_db, :track

  def initialize(state_db, track)
    @state_db = state_db
    @track = track
    @unlocked_by_relationships = {}
  end

  def sync!
    if repo_url.start_with?("http://example.com")
      puts "Skipping sync for #{repo_url}"
      state_db.mark_synced(track)
      return
    end

    sync_track_metadata
    current_exercises_uuids = track.exercises.map { |ex| ex.uuid }
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
    @unlocked_by_relationships.each do |exercise_uuid, unlocked_by_uuid|
      a = Exercise.find_by(uuid: exercise_uuid)
      b = Exercise.find_by(uuid: unlocked_by_uuid)
      a.update!( unlocked_by: b )
    end
  end

  def create_or_update_exercise(exercise_slug, exercise_uuid, exercise_data)
    puts "Syncing exercise #{exercise_uuid}"
    if current_exercises_uuids.include?(exercise_uuid)
      ex = Exercise.find_by(uuid: exercise_uuid)
      ex.update!(exercise_data)
    else
      exercise_data.merge!({
        uuid: exercise_uuid
      })
      ex = Exercise.new(exercise_data)
      track.exercises << ex
    end
  end

  def current_exercises_uuids
    track.exercises.map {|ex| ex[:uuid] }
  end

  def setup_exercises
    exercises.each.with_index do |exercise, position|
      exercise_slug = exercise[:slug]
      exercise_uuid = exercise[:uuid]
      puts "UUID: #{exercise_uuid}"

      # HACK!!! TODOGIT this will ultimately be removed
      exercise_uuid = exercise_slug if exercise_uuid.nil?

      if exercise_slug.nil? || exercise_uuid.nil?
        puts "Skipping exercise #{exercise}"
      else
        sync_exercise(exercise_slug, exercise_uuid, exercise, position)
      end
    end
  end

  def sync_exercise(exercise_slug, exercise_uuid, exercise, position)
    unlocked_by = exercise[:unlocked_by]
    @unlocked_by_relationships[exercise_uuid] = unlocked_by unless unlocked_by.nil?

    # Some tracks have old config without keys and others
    # have new config with keys. Using fetch helps us out
    # with some sensible defaults where we're on the old config
    topic_slugs = exercise.fetch(:topics, [])
    topics = topic_slugs.map { |slug| Topic.find_or_create_by(slug: slug) }

    exercise_image_stem = exercise_slug.gsub("_", "-")

    image_exists = File.file?(Rails.root / "app/assets/images/tmp/exercises/#{exercise_image_stem}-dark.png")
    p image_exists
    dark_icon_url = image_exists ? "tmp/exercises/#{exercise_image_stem}-dark.png" : nil
    turquoise_icon_url = image_exists ? "tmp/exercises/#{exercise_image_stem}-turquoise.png" : nil
    white_icon_url = image_exists ? "tmp/exercises/#{exercise_image_stem}-white.png" : nil

    exercise_data = {
      slug: exercise_slug,
      title: exercise_slug.titleize,
      core: (position <= 10),
      active: exercise.fetch(:active, true),
      position: position,
      difficulty: exercise.fetch(:difficulty, 1),
      length: exercise.fetch(:length, 1),
      topics: topics,

      # TODOGIT - Talk to iHiD about this. This is either in metadata.yml in problem-specifications or in the exercise/:slug/.meta/metadata.yml (if it's a custom exercise)
      # https://github.com/exercism/docs/blob/f8d51ca364de4f97d8a2af27a48313ec45499bf0/language-tracks/exercises/README.md
      # blurb: ""

      dark_icon_url: "https://s3-eu-west-1.amazonaws.com/exercism-static/exercises/#{exercise_slug}-dark.png",
      turquoise_icon_url: "https://s3-eu-west-1.amazonaws.com/exercism-static/exercises/#{exercise_slug}-turquoise.png",
      white_icon_url: "https://s3-eu-west-1.amazonaws.com/exercism-static/exercises/#{exercise_slug}-white.png",
    }

    create_or_update_exercise(exercise_slug, exercise_uuid, exercise_data)
  end

  def sync_track_metadata
    track.update!(introduction: track_introduction,
      about: track_about,
      code_sample: code_sample)
  end

  def track_introduction
    config["introduction"] || ""
  end

  def track_about
    repo.about || ""
  end

  def code_sample
    code_sample = repo.snippet_file
    return code_sample unless code_sample.nil?
    first_exercise = exercises.first
    first_exercise_slug = first_exercise[:slug]
    ex = repo.exercise(first_exercise_slug, repo.head)
    ex.solution || ""
  rescue => e
    puts e.message
    puts e.backtrace
    ""
  end

  def sync_maintainers
    puts "Syncing Maintainers"
    Git::SyncsMaintainers.sync!(track, repo.maintainer_config)
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
end
