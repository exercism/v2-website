class CreatesTrack

  TRACKS = %w{
    https://github.com/exercism/ruby
    https://github.com/exercism/go
    https://github.com/exercism/prolog
    https://github.com/exercism/bash
  }

  def self.create_all!
    TRACKS.map do |t|
      self.create!(t)
    end
  end

  def self.create!(git_url)
    new(git_url).create!
  end

  attr_reader :git_url

  def initialize(git_url)
    @git_url = git_url
  end

  def create!
    config = read_config

    track_slug = config[:slug]
    language = config[:language]

    track = Track.create!(title: language, slug: track_slug)

    exercises = config[:exercises]
    exercises.each.with_index do |exercise, position|
      exercise_slug = exercise[:slug]

      # Some tracks have old config without keys and others
      # have new config with keys. Using fetch helps us out
      # with some sensible defaults where we're on the old config
      Exercise.create!(
        track: track,
        uuid: exercise.fetch(:uuid) { SecureRandom.uuid },
        slug: exercise_slug,
        title: exercise_slug.titleize,
        core: (position <= 10),
        active: exercise.fetch(:active, true),
        position: position
      )
    end
  end

  private

  def read_config
    repo = Git::ExercismRepo.new(git_url, auto_fetch: true)
    repo.config
  end

end
