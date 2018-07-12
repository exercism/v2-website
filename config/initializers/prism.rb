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
  "abap": %w{abap},
  "actionscript": %w{actionscript},
  "ada": %w{ada},
  "apacheconf": %w{apacheconf},
  "apl": %w{apl tc dyalog},
  "applescript": %w{applescript},
  "asciidoc": %w{asciidoc},
  "aspnet": %w{aspnet},
  "autoit": %w{autoit},
  "autohotkey": %w{autohotkey},
  "bash": %w{bash},
  "basic": %w{basic},
  "batch": %w{batch},
  "bison": %w{bison},
  "brainfuck": %w{brainfuck},
  "bro": %w{bro},
  "c": %w{c},
  "clojure": %w{clojure},
  "csharp": %w{cs csx},
  "css": %w{css},
  "clike": %w{clike},
  "cpp": %w{cpp},
  "coffeescript": %w{coffeescript},
  "crystal": %w{crystal},
  "css-extras": %w{css-extras},
  "d": %w{d},
  "dart": %w{dart},
  "django": %w{django},
  "diff": %w{diff},
  "docker": %w{docker},
  "eiffel": %w{eiffel},
  "elixir": %w{ex exs elixir},
  "erlang": %w{erl hrl erlang},
  "fsharp": %w{fs fsx fsharp},
  "fortran": %w{fortran},
  "git": %w{git},
  "glsl": %w{glsl},
  "go": %w{go bal},
  "graphql": %w{graphql},
  "groovy": %w{groovy},
  "haml": %w{haml},
  "handlebars": %w{handlebars},
  "haskell": %w{hs idr haskell},
  "haxe": %w{haxe},
  "http": %w{http},
  "icon": %w{icon},
  "inform7": %w{inform7},
  "ini": %w{ini},
  "j": %w{j},
  "jade": %w{},
  "java": %w{java},
  "javascript": %w{js javascript},
  "jolie": %w{jolie},
  "json": %w{json},
  "julia": %w{jl julia},
  "keyman": %w{keyman},
  "kotlin": %w{kt kts kotlin},
  "latex": %w{latex},
  "less": %w{less},
  "lisp": %w{lisp},
  "livescript": %w{livescript},
  "lolcode": %w{lolcode},
  "lua": %w{lua},
  "makefile": %w{makefile},
  "markdown": %w{md markdown},
  "markup": %w{markup-templating},
  "matlab": %w{matlab},
  "mel": %w{mel},
  "mizar": %w{mizar},
  "monkey": %w{monkey},
  "nasm": %w{nasm},
  "nginx": %w{nginx},
  "nim": %w{nim},
  "nix": %w{nix},
  "nsis": %w{nsis},
  "objectivec": %w{objectivec},
  "ocaml": %w{fun sig sml ml mli ocaml},
  "oz": %w{oz},
  "parigp": %w{parigp},
  "parser": %w{parser},
  "pascal": %w{pas dfm pascal},
  "perl": %w{perl},
  "php": %w{php},
  "php-extras": %w{php-extras},
  "powershell": %w{powershell},
  "processing": %w{processing},
  "prolog": %w{prolog},
  "properties": %w{properties},
  "protobuf": %w{protobuf},
  "puppet": %w{puppet},
  "pure": %w{pure},
  "python": %w{py python},
  "q": %w{q},
  "qore": %w{qore},
  "r": %w{r},
  "jsx": %w{jsx},
  "reason": %w{re rei reason},
  "rest": %w{rest},
  "rip": %w{rip},
  "roboconf": %w{roboconf},
  "ruby": %w{rb ruby},
  "rust": %w{rs rust},
  "sas": %w{sas},
  "sass": %w{sass},
  "scss": %w{scss},
  "scala": %w{pony scala},
  "scheme": %w{scheme},
  "smalltalk": %w{st smalltalk},
  "smarty": %w{smarty},
  "sql": %w{sql},
  "stylus": %w{stylus},
  "swift": %w{swift},
  "tcl": %w{tcl},
  "textile": %w{textile},
  "twig": %w{twig},
  "typescript": %w{ts typescript},
  "vbnet": %w{vbnet},
  "verilog": %w{verilog},
  "vhdl": %w{vhdl},
  "vim": %w{vim},
  "wiki": %w{wiki},
  "xojo": %w{xojo},
  "yaml": %w{yaml yml}, 

  "plain": %w{txt},
}.each_with_object({}) {|(lang, exts), h|exts.each { |ext|h[ext] = lang}}
