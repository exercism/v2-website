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
      # Default track metadata to empty for git syncer to populate
      introduction: "", # Default to empty,
      about: "",
      code_sample: "", #TODOGIT - Work this out
      git_sync_required: true
    )
    track
  end

end
