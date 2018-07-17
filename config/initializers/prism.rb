Exercism::PrismLanguages = %w{
markup
css
clike
javascript

abap
actionscript
ada
apacheconf
apl
applescript
arduino
arff
asciidoc
asm6502
aspnet
autohotkey
autoit
bash
basic
batch
bison
brainfuck
bro
c
csharp
cpp
coffeescript
clojure
crystal
csp
css-extras
d
dart
diff
django
docker
eiffel
elixir
elm
erb
erlang
fsharp
flow
fortran
gedcom
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
hpkp
hsts
ichigojam
icon
inform7
ini
io
j
java
jolie
json
julia
keyman
kotlin
latex
less
liquid
lisp
livescript
lolcode
lua
makefile
markdown
markup-templating
matlab
mel
mizar
monkey
n4js
nasm
nginx
nim
nix
nsis
objectivec
ocaml
opencl
oz
parigp
parser
pascal
perl
php
php-extras
plsql
powershell
processing
prolog
properties
protobuf
pug
puppet
pure
python
q
qore
r
jsx
tsx
renpy
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
soy
stylus
swift
tap
tcl
textile
tt2
twig
typescript
vbnet
velocity
verilog
vhdl
vim
visual-basic
wasm
wiki
xeora
xojo
xquery
yaml
}

Exercism::PrismLanguageMappings = {
  "common-lisp" => "lisp",
  "elisp" => "lisp",
  "lfe" => "lisp",

  "perl5" => "perl",
  "perl6" => "perl",

  "ballerina" => "go",
  "ceylon" => "kotlin",
  "cfml" => "markup",
  "delphi" => "pascal",
  "ecmascript" => "javascript",
  "gnu-apl" => "apl",
  "idris" => "haskell", # close enough for now
  "objective-c" => "objectivec",
  "pharo" => "smalltalk",
  "plsql" => "sql",
  "purescript" => "haskell",
  "pony" => "scala", # close enough for now
  "sml" => "ocaml", # close enough for now
  "vimscript" => "vim",
  "reasonml" => "reason",
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
  "cpp": %w{h hpp cpp},
  "coffeescript": %w{},  
  "crystal": %w{},
  "css-extras": %w{},
  "d": %w{},
  "dart": %w{dart},
  "django": %w{},
  "diff": %w{},
  "docker": %w{},
  "eiffel": %w{},
  "elisp": %w{lisp},
  "elixir": %w{ex exs},
  "erlang": %w{erl hrl },
  "fsharp": %w{fs fsx},
  "fortran": %w{},
  "git": %w{},
  "glsl": %w{},
  "go": %w{go bal},
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
  "lisp": %w{lisp},
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
  "php": %w{php},
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
  "reason": %w{re rei},
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
  "smalltalk": %w{st},
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
