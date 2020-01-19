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
  "emacs-lisp" => "lisp",
  "lfe" => "lisp",

  "ballerina" => "go",
  "ceylon" => "kotlin",
  "cfml" => "markup",
  "coq" => "verilog", # close enough for now
  "delphi" => "pascal",
  "ecmascript" => "javascript",
  "gnu-apl" => "apl",
  "idris" => "haskell", # close enough for now
  "objective-c" => "objectivec",
  "perl5" => "perl",
  "pharo" => "smalltalk",
  "plsql" => "sql",
  "purescript" => "haskell",
  "pony" => "scala", # close enough for now
  "racket" => "scheme", # close enough for now
  "sml" => "ocaml", # close enough for now
  "vimscript" => "vim",
  "reasonml" => "reason",
}

Exercism::PrismFileMappings = {
  "abap": %w{abap},
  "actionscript": %w{as},
  "ada": %w{adb ada ads},
  "apacheconf": %w{apacheconf vhost},
  "apl": %w{apl tc dyalog},
  "applescript": %w{applescript scpt},
  "asciidoc": %w{asciidoc adoc asc},
  "aspnet": %w{aspx cshtml vbhtml},
  "autoit": %w{au3},
  "autohotkey": %w{ahk ahkl},
  "bash": %w{bash sh},
  "basic": %w{b},
  "batch": %w{bat},
  "bison": %w{bison},
  "brainfuck": %w{bf},
  "bro": %w{bro},
  "c": %w{c cats idc},
  "clojure": %w{clj boot cl2 cljc cljs cljs.hl cljscm cljx hic},
  "csharp": %w{cs csx},
  "css": %w{css},
  "clike": %w{},
  "cpp": %w{h hpp cpp},
  "coffeescript": %w{coffee _coffee cake cjsx iced},
  "crystal": %w{cr},
  "css-extras": %w{},
  "d": %w{d di},
  "dart": %w{dart},
  "django": %w{},
  "diff": %w{diff patch},
  "docker": %w{},
  "eiffel": %w{e},
  "emacs-lisp": %w{el},
  "elixir": %w{ex exs},
  "elm": %w{elm},
  "erlang": %w{erl app.src escript hrl xrl yrl},
  "fsharp": %w{fs fsx},
  "fortran": %w{f90 f f03 f08 f77 f95 for fpp},
  "git": %w{},
  "glsl": %w{glsl fp frag frg fsh fshader geo geom glslv gshader shader tesc tese vert vrx vsh vshader},
  "go": %w{go bal},
  "graphql": %w{graphql gql},
  "groovy": %w{groovy grt gtpl gvy},
  "haml": %w{haml haml.deface},
  "handlebars": %w{handlebars hbs},
  "haskell": %w{hs hsc idr purs},
  "haxe": %w{hx hxsl},
  "http": %w{http},
  "icon": %w{},
  "inform7": %w{},
  "ini": %w{ini cfg prefs properties},
  "j": %w{ijs},
  "jade": %w{jade},
  "java": %w{java},
  "javascript": %w{js _js bones es es6 gs jake jsb jscad jsfl jsm jss mjs njs pac sjs ssjs xsjs xsjslib cfc},
  "jolie": %w{ol iol},
  "json": %w{json avsc geojson gltf JSON-tmLanguage jsonl tfstate tfstate.backup topojson webapp webmanifest},
  "julia": %w{jl},
  "keyman": %w{},
  "kotlin": %w{kt ktm kts},
  "latex": %w{tex},
  "less": %w{less},
  "lisp": %w{lisp factor},
  "livescript": %w{ls _ls},
  "lolcode": %w{lol},
  "lua": %w{lua nse p8 pd_lua rbxs wlua},
  "makefile": %w{mak make mk mkfile},
  "markdown": %w{md markdown mdown mdwn mkd mkdn mkdown ronn workbook},
  "markup": %w{html xml cfm},
  "matlab": %w{matlab},
  "mel": %w{mel},
  "mizar": %w{miz voc},
  "monkey": %w{monkey monkey2},
  "nasm": %w{asm},
  "nginx": %w{nginxconf},
  "nim": %w{nim nimrod},
  "nix": %w{nix},
  "nsis": %w{nsi nsh},
  "objectivec": %w{m},
  "ocaml": %w{fun sig sml ml mli eliom eliomi ml4 mll mly }, # fun sig sml for SML
  "oz": %w{oz},
  "parigp": %w{gp},
  "parser": %w{},
  "pascal": %w{pas dfm dpr lpr pascal},
  "perl": %w{al cgi fcgi perl ph plx pm psgi t},
  "php": %w{php aw ctp inc php3 php4 php5 phps phpt},
  "php-extras": %w{},
  "powershell": %w{ps1 psd1 psm1},
  "processing": %w{pde},
  "prolog": %w{pro prolog yap},
  "properties": %w{},
  "protobuf": %w{proto},
  "puppet": %w{pp},
  "pure": %w{pure},
  "python": %w{py bzl gyp gypi lmi py3 pyde pyi pyp pyt pyw rpy tac wsgi xpy},
  "q": %w{q},
  "qore": %w{},
  "r": %w{r rd rsx},
  "jsx": %w{jsx},
  "reason": %w{re rei},
  "rest": %w{},
  "rip": %w{},
  "roboconf": %w{},
  "ruby": %w{rb builder eye gemspec god jbuilder mspec pluginspec podspec rabl rake rbuild rbw rbx ru ruby spec thor watchr},
  "rust": %w{rs rs.in},
  "sas": %w{sas},
  "sass": %w{sass},
  "scss": %w{scss},
  "scala": %w{pony scala kojo sbt sc},
  "scheme": %w{scm sch sld sls sps ss rkt},
  "smalltalk": %w{st},
  "smarty": %w{tpl},
  "sql": %w{sql cql ddl mysql prc tab udf viw},
  "stylus": %w{styl},
  "swift": %w{swift},
  "tcl": %w{tcl adp tm},
  "textile": %w{textile},
  "twig": %w{twig},
  "typescript": %w{ts tsx},
  "vbnet": %w{vb},
  "verilog": %w{v veo},
  "vhdl": %w{vhdl vhd vhf vhi vho vhs vht vhw},
  "vim": %w{vim},
  "wiki": %w{},
  "xojo": %w{xojo_code xojo_menu xojo_report xojo_script xojo_toolbar xojo_window},
  "yaml": %w{yml mir reek rviz sublime-syntax syntax yaml yaml-tmlanguage yml.mysql},

  "plain": %w{txt},
}.each_with_object({}) {|(lang, exts), h|exts.each { |ext|h[ext] = lang}}
