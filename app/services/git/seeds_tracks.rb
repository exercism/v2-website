class Git::SeedsTracks

  TRACKS = %w{
    https://github.com/exercism/ruby
    https://github.com/exercism/go
    https://github.com/exercism/prolog
    https://github.com/exercism/bash
    https://github.com/exercism/javascript
    https://github.com/ccare/delphi
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
    Track.find_each do |track|
      Git::SyncsTrack.sync!(track)
    end
  end

end
