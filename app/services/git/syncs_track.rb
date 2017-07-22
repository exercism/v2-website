class Git::SyncsTrack

  def self.sync!(track)
    new(track).sync!
  end

  attr_reader :track

  def initialize(track)
    @track = track
    @unlocked_by_relationships = {}
  end

  def sync!
    current_exercises_uuids = track.exercises.map { |ex| ex.uuid }
    setup_exercises
    sync_maintainers
    populate_unlocked_by_relationships
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

    exercise_data = {
      slug: exercise_slug,
      title: exercise_slug.titleize,
      core: (position <= 10),
      active: exercise.fetch(:active, true),
      position: position,
      difficulty: exercise.fetch(:difficulty, 1),
      length: exercise.fetch(:length, 1),
      topics: topics
    }

    create_or_update_exercise(exercise_slug, exercise_uuid, exercise_data)
  end

  def exercises
    config[:exercises]
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

  def sync_maintainers
    puts "Syncing Maintainers"
    maintainer_descriptions = config.fetch(:maintainers, [])
    maintainer_descriptions.each do |m|
      gh_user = m[:github_username]
      name = m[:name]
      next if gh_user.nil? || name.nil?

      maintainer_data = {
        active: m.fetch(:active, true),
        visible: m.fetch(:show_on_website, true),
        name: m.fetch(:name, '..'),
        bio: m.fetch(:bio),
        link_text: m.fetch(:link_text, '..'),
        link_url: m.fetch(:link_url, '..'),
        avatar_url: (m[:avatar_url] || 'https://example.com')
      }
      puts maintainer_data
      maintainer = Maintainer.find_or_create_by!(track: track, github_username: gh_user) do |mm|
        mm.assign_attributes(maintainer_data)
      end
      maintainer.update!(maintainer_data)
    end
  end
end
