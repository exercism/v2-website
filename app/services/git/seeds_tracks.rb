class Git::SeedsTracks

  # NB generate this with Trackler.tracks.select(&:active?).map {|t| "https://github.com/exercism/#{t.id}" }

  TRACKS = %w{
    https://github.com/exercism/csharp
    https://github.com/exercism/cpp
    https://github.com/exercism/clojure
    https://github.com/exercism/coffeescript
    https://github.com/exercism/common-lisp
    https://github.com/exercism/crystal
    https://github.com/exercism/d
    https://github.com/exercism/delphi
    https://github.com/exercism/ecmascript
    https://github.com/exercism/elixir
    https://github.com/exercism/elm
    https://github.com/exercism/elisp
    https://github.com/exercism/erlang
    https://github.com/exercism/fsharp
    https://github.com/exercism/go
    https://github.com/exercism/haskell
    https://github.com/exercism/java
    https://github.com/exercism/javascript
    https://github.com/exercism/kotlin
    https://github.com/exercism/lfe
    https://github.com/exercism/lua
    https://github.com/exercism/mips
    https://github.com/exercism/ocaml
    https://github.com/exercism/objective-c
    https://github.com/exercism/php
    https://github.com/exercism/plsql
    https://github.com/exercism/perl5
    https://github.com/exercism/perl6
    https://github.com/exercism/python
    https://github.com/exercism/r
    https://github.com/exercism/racket
    https://github.com/exercism/ruby
    https://github.com/exercism/rust
    https://github.com/exercism/scala
    https://github.com/exercism/scheme
    https://github.com/exercism/swift
    https://github.com/exercism/typescript
    https://github.com/exercism/vimscript
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
      puts "===== Fetching #{track.slug} ====="
      begin
        Git::FetchTrack.sync!(track)
      rescue => e
        puts e.message
      end

      puts "===== Syncing #{track.slug} ====="
      begin
        Git::SyncsTrack.sync!(track)
      rescue => e
        puts e.message
      end
    end
    ::Exercise.where(slug: "hello-world").update_all(auto_approve: true)
  end
end
