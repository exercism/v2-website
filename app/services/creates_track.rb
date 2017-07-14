class CreatesTrack

  TRACKS = %w{https://github.com/exercism/ruby
    https://github.com/exercism/go
    https://github.com/exercism/prolog}

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

    track_slug = config["slug"]
    language = config["language"]

    track = Track.create!(title: language, slug: track_slug)

    exercises = config["exercises"]
    position = 0
    exercises.each do |exercise|
      position += 1
      exercise_slug = exercise["slug"]
      Exercise.create!(track: track,
                      core: (position <= 10),
                      position: position,
                      slug: exercise_slug,
                      title: exercise_slug.titleize,
                      uuid: SecureRandom.uuid)
    end
  end

  private

  def read_config
    repo = Git::ExercismRepo.new(git_url, auto_fetch: true)
    repo.config
  end

end
