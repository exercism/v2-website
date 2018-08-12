class CreatesTrack
  def self.create!(language, track_slug, repo_url, active:)
    new(language, track_slug, repo_url, active: active).create!
  end

  attr_reader :language, :track_slug, :repo_url, :active

  def initialize(language, track_slug, repo_url, active:)
    @language = language
    @repo_url = repo_url
    @track_slug = track_slug || repo_url.split("/").last
    @active = active
  end

  def create!
    prism_language = track_slug
    unless Exercism::PrismLanguages.include?(prism_language)
      if mapping = Exercism::PrismLanguageMappings[prism_language]
        prism_language = mapping
      else
        p "Warning: #{track_slug} is not a Prism Language"
      end
    end

    track = Track.create!(
      title: language,
      slug: track_slug,
      syntax_highligher_language: prism_language,
      repo_url: repo_url,
      active: active,

      # Default track metadata to empty for git syncer to populate
      introduction: "",
      code_sample: "",
      bordered_green_icon_url: track_image_url("#{track_slug}-bordered-green.png"),
      bordered_turquoise_icon_url: track_image_url("#{track_slug}-bordered-turquoise.png"),
      hex_green_icon_url: track_image_url("#{track_slug}-hex-green.png"),
      hex_turquoise_icon_url: track_image_url("#{track_slug}-hex-turquoise.png"),
      hex_white_icon_url: track_image_url("#{track_slug}-hex-white.png")
    )
    track
  end

  private

  def track_image_url(file_name)
    "https://assets.exercism.io/tracks/#{file_name}"
  end
end
