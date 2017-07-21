class Git::SyncsTrack

  def self.sync!(track)
    new(track).sync!
  end

  attr_reader :track

  def initialize(track)
    @track = track
  end

  def sync!
    puts "Syncing #{repo_url}"

    exercises = config[:exercises]

    current_exercises_uuids = track.exercises.map { |ex| ex.uuid }

    puts "Current #{current_exercises_uuids}"

    exercises.each.with_index do |exercise, position|
      exercise_slug = exercise[:slug]

      # Some tracks have old config without keys and others
      # have new config with keys. Using fetch helps us out
      # with some sensible defaults where we're on the old config


      exercise_uuid = exercise.fetch(:uuid) { SecureRandom.uuid }
      puts "Syncing exercise #{exercise_uuid}"
      if current_exercises_uuids.include?(exercise_uuid)
        ex = Exercise.find_by(uuid: exercise_uuid)
        ex.update!(slug: exercise_slug,
          title: exercise_slug.titleize,
          core: (position <= 10),
          active: exercise.fetch(:active, true),
          position: position
        )
      else
        ex = Exercise.new(
          uuid: exercise.fetch(:uuid) { SecureRandom.uuid },
          slug: exercise_slug,
          title: exercise_slug.titleize,
          core: (position <= 10),
          active: exercise.fetch(:active, true),
          position: position
        )
        track.exercises << ex
      end
    end

  end

  private

  def exercise_exists?
  end

  def current_exercises_uuids
    track.exercises
  end

  def setup_track
    if Track.exists?(slug: track_slug)
      puts "Track #{track_slug} already exists"
      puts "Update stuff"
      @track = Track.find_by(slug: track_slug)
    else
      @track = CreatesTrack.create!(language, track_slug)
      puts "New track (id: #{track.id}) created"
    end
  end

  def setup_exercises
    exercises.each.with_index do |exercise, position|
      sync_exercise(exercise, position)
    end
  end

  def sync_exercise(exercise, position)
    puts exercise
    puts position
  end

  def track_slug
    config[:slug]
  end

  def language
    config[:language]
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
    @repo ||= Git::ExercismRepo.new(repo_url)
  end

end
