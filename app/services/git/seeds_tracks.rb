class Git::SeedsTracks

  TRACKS = %w{
    https://github.com/exercism/ruby
    https://github.com/exercism/go
    https://github.com/exercism/prolog
    https://github.com/exercism/bash
  }

  def self.seed!
    new(TRACKS).seed!
  end

  attr_reader :repository_urls

  def initialize(repository_urls)
    @repository_urls = repository_urls
  end

  def seed!
    repository_urls.each do |repo_url|
      Git::SeedsTrack.seed!(repo_url)
    end
  end

end
