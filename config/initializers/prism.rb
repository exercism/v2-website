Exercism::PrismLanguages = %w{
  abap
  actionscript
  ada
  apacheconf
  apl
  applescript
  asciidoc
  aspnet
  autoit
  autohotkey
  bash
  basic
  batch
  bison
  brainfuck
  bro
  c
  clojure
  csharp
  css
  clike
  cpp
  coffeescript
  crystal
  css-extras
  d
  dart
  django
  diff
  docker
  eiffel
  elixir
  erlang
  fsharp
  fortran
  gherkin
  git
  glsl
  go
  graphql
  groovy
  haml
  handlebars
  haskell
  haxe
  http
  icon
  inform7
  ini
  j
  jade
  java
  javascript
  jolie
  json
  julia
  keyman
  kotlin
  latex
  less
  livescript
  lolcode
  lua
  makefile
  markdown
  markup
  matlab
  mel
  mizar
  monkey
  nasm
  nginx
  nim
  nix
  nsis
  objectivec
  ocaml
  oz
  parigp
  parser
  pascal
  perl
  php
  php-extras
  powershell
  processing
  prolog
  properties
  protobuf
  puppet
  pure
  python
  q
  qore
  r
  jsx
  reason
  rest
  rip
  roboconf
  ruby
  rust
  sas
  sass
  scss
  scala
  scheme
  smalltalk
  smarty
  sql
  stylus
  swift
  tcl
  textile
  twig
  typescript
  vbnet
  verilog
  vhdl
  vim
  wiki
  xojo
  yaml
}

Exercism::PrismLanguageMappings = {
  "delphi" => "pascal",
  "objective-c" => "c",
  "perl5" => "perl",
  "perl6" => "perl",
  "plsql" => "sql"
}

Exercism::PrismFileMappings = {
  "abap": %w{},
  "actionscript": %w{},
  "ada": %w{},
  "apacheconf": %w{},
  "apl": %w{apl tc dyalog},
  "applescript": %w{},
  "asciidoc": %w{},
  "aspnet": %w{},
  "autoit": %w{},
  "autohotkey": %w{},
  "bash": %w{},
  "basic": %w{},
  "batch": %w{},
  "bison": %w{},
  "brainfuck": %w{},
  "bro": %w{},
  "c": %w{c},
  "clojure": %w{},
  "csharp": %w{cs csx},
  "css": %w{},
  "clike": %w{},
  "cpp": %w{},
  "coffeescript": %w{},
  "crystal": %w{},
  "css-extras": %w{},
  "d": %w{},
  "dart": %w{dart},
  "django": %w{},
  "diff": %w{},
  "docker": %w{},
  "eiffel": %w{},
  "elixir": %w{ex exs},
  "erlang": %w{erl hrl },
  "fsharp": %w{fs fsx},
  "fortran": %w{},
  "gherkin": %w{},
  "git": %w{},
  "glsl": %w{},
  "go": %w{go},
  "graphql": %w{},
  "groovy": %w{groovy},
  "haml": %w{},
  "handlebars": %w{},
  "haskell": %w{hs idr},
  "haxe": %w{},
  "http": %w{},
  "icon": %w{},
  "inform7": %w{},
  "ini": %w{},
  "j": %w{},
  "jade": %w{},
  "java": %w{java},
  "javascript": %w{js},
  "jolie": %w{},
  "json": %w{},
  "julia": %w{jl},
  "keyman": %w{},
  "kotlin": %w{kt kts},
  "latex": %w{},
  "less": %w{},
  "livescript": %w{},
  "lolcode": %w{},
  "lua": %w{lua},
  "makefile": %w{},
  "markdown": %w{md},
  "markup": %w{},
  "matlab": %w{},
  "mel": %w{},
  "mizar": %w{},
  "monkey": %w{},
  "nasm": %w{},
  "nginx": %w{},
  "nim": %w{},
  "nix": %w{},
  "nsis": %w{},
  "objectivec": %w{},
  "ocaml": %w{fun sig sml ml mli},
  "oz": %w{},
  "parigp": %w{},
  "parser": %w{},
  "pascal": %w{pas dfm},
  "perl": %w{},
  "php": %w{},
  "php-extras": %w{},
  "powershell": %w{},
  "processing": %w{},
  "prolog": %w{},
  "properties": %w{},
  "protobuf": %w{},
  "puppet": %w{},
  "pure": %w{},
  "python": %w{py},
  "q": %w{},
  "qore": %w{},
  "r": %w{r},
  "jsx": %w{},
  "reason": %w{},
  "rest": %w{},
  "rip": %w{},
  "roboconf": %w{},
  "ruby": %w{rb},
  "rust": %w{rs},
  "sas": %w{},
  "sass": %w{},
  "scss": %w{},
  "scala": %w{pony scala},
  "scheme": %w{},
  "smalltalk": %w{},
  "smarty": %w{},
  "sql": %w{},
  "stylus": %w{},
  "swift": %w{swift},
  "tcl": %w{},
  "textile": %w{},
  "twig": %w{},
  "typescript": %w{ts},
  "vbnet": %w{},
  "verilog": %w{},
  "vhdl": %w{},
  "vim": %w{},
  "wiki": %w{},
  "xojo": %w{},
  "yaml": %w{yaml yml},

  "plain": %w{txt},
}.each_with_object({}) {|(lang, exts), h|exts.each { |ext|h[ext] = lang}}
