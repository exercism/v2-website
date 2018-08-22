class Git::SeedsTrack
  def self.seed!(repo_url)
    new(repo_url).seed!
  end

  attr_reader :repo_url

  def initialize(repo_url)
    @repo_url = repo_url
  end

  def seed!
    puts "Seeding #{repo_url}"
    unless Track.exists?(repo_url: repo_url)
      CreateTrack.(language, track_slug, repo_url, active: config[:active])
    end
  end

  private

  def track_slug
    config[:slug]
  end

  def language
    config[:language]
  end

  def config
    @config ||= read_config
  end

  def read_config
    repo = Git::ExercismRepo.new(repo_url, auto_fetch: true)
    repo.config
  end
end
