class Git::SeedTracks
  include Mandate

  # NB generate this with Trackler.tracks.map(&:repository).sort

  def self.tracks
    TRACKS
  end

  TRACKS = %w{
    https://github.com/exercism/ballerina
    https://github.com/exercism/bash
    https://github.com/exercism/c
    https://github.com/exercism/ceylon
    https://github.com/exercism/cfml
    https://github.com/exercism/clojure
    https://github.com/exercism/coffeescript
    https://github.com/exercism/common-lisp
    https://github.com/exercism/coq
    https://github.com/exercism/cpp
    https://github.com/exercism/crystal
    https://github.com/exercism/csharp
    https://github.com/exercism/d
    https://github.com/exercism/dart
    https://github.com/exercism/delphi
    https://github.com/exercism/emacs-lisp
    https://github.com/exercism/elixir
    https://github.com/exercism/elm
    https://github.com/exercism/erlang
    https://github.com/exercism/factor
    https://github.com/exercism/fortran
    https://github.com/exercism/fsharp
    https://github.com/exercism/gnu-apl
    https://github.com/exercism/go
    https://github.com/exercism/groovy
    https://github.com/exercism/haskell
    https://github.com/exercism/haxe
    https://github.com/exercism/idris
    https://github.com/exercism/java
    https://github.com/exercism/javascript
    https://github.com/exercism/julia
    https://github.com/exercism/kotlin
    https://github.com/exercism/lfe
    https://github.com/exercism/lua
    https://github.com/exercism/mips
    https://github.com/exercism/nim
    https://github.com/exercism/objective-c
    https://github.com/exercism/ocaml
    https://github.com/exercism/perl5
    https://github.com/exercism/perl6
    https://github.com/exercism/pharo
    https://github.com/exercism/php
    https://github.com/exercism/plsql
    https://github.com/exercism/pony
    https://github.com/exercism/powershell
    https://github.com/exercism/prolog
    https://github.com/exercism/purescript
    https://github.com/exercism/python
    https://github.com/exercism/r
    https://github.com/exercism/racket
    https://github.com/exercism/reasonml
    https://github.com/exercism/ruby
    https://github.com/exercism/rust
    https://github.com/exercism/scala
    https://github.com/exercism/scheme
    https://github.com/exercism/sml
    https://github.com/exercism/swift
    https://github.com/exercism/typescript
    https://github.com/exercism/vbnet
    https://github.com/exercism/vimscript
    https://github.com/exercism/x86-64-assembly
  }

  attr_reader :repository_urls

  def initialize(stdout: STDOUT, stderr: STDERR)
    @repository_urls = self.class.tracks
    @stdout = stdout
    @stderr = stderr
  end

  def call
    repository_urls.each do |repo_url|
      Git::SeedTrack.(repo_url)
    end
    Track.find_each do |track|
      stdout.puts "===== Fetching #{track.slug} ====="
      begin
        Git::FetchRepo.(track.repo)
      rescue => e
        stderr.puts e.message
      end

      stdout.puts "===== Syncing #{track.slug} ====="
      begin
        Git::SyncTrack.(track)
      rescue => e
        stderr.puts e.message
      end
    end
    ::Exercise.where(slug: "hello-world").update_all(auto_approve: true)
  end

  private

  attr_reader :stdout, :stderr
end
