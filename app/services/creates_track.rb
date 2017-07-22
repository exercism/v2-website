class CreatesTrack

  def self.create!(language, track_slug, repo_url)
    new(language, track_slug, repo_url).create!
  end

  attr_reader :language, :track_slug, :repo_url

  def initialize(language, track_slug, repo_url)
    @language = language
    @track_slug = track_slug
    @repo_url = repo_url
  end

  def create!
    track = Track.create!(
      title: language,
      slug: track_slug || repo_url.split("/").last,
      repo_url: repo_url,
      introduction: "", #TODOGIT - Work this out
      about: "", #TODOGIT - Work this out
      code_sample: "", #TODOGIT - Work this out
    )

    track

    # exercises = config[:exercises]
    # exercises.each.with_index do |exercise, position|
    #   exercise_slug = exercise[:slug]
    #
    #   # Some tracks have old config without keys and others
    #   # have new config with keys. Using fetch helps us out
    #   # with some sensible defaults where we're on the old config
    #   Exercise.create!(
    #     track: track,
    #     uuid: exercise.fetch(:uuid) { SecureRandom.uuid },
    #     slug: exercise_slug,
    #     title: exercise_slug.titleize,
    #     core: (position <= 10),
    #     active: exercise.fetch(:active, true),
    #     position: position
    #   )
    # end
  end

  # private

  # def read_config
  #   repo = Git::ExercismRepo.new(git_url, auto_fetch: true)
  #   repo.config
  # end

end
