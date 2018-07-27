# Exercism Website Contributing Guide

## Introduction

**Thank you** for wanting to contribute to Exercism's website!

Please be aware that we only normally accept Pull Requests that have been pre-agreed or that have been marked with the `community-pr-welcome` label on [our issue tracker](https://github.com/exercism/exercism.io/issues?q=is%3Aissue+is%3Aopen+label%3Acommunity-pr-welcome).

Please remember our [Code of Conduct](https://exercism.io/code-of-conduct) when contributing.

## Style guidelines.

These are our style guidelines which are constantly evolving.

### Ruby Code
- Use brackets in Ruby. e.g. `some_method(arg1, arg2)` rather than `some_method arg1, arg2`

### Ruby Tests
- The Ruby Code guidelines apply, other than for calling factories, where we prefer the style `create :user, name: "Jeremy Walker", handle: "iHiD"`

### Haml

- When executing Ruby, do not use spaces between the `=` and the method. e.g. use `=image_tag` not `= image_tag`.

### SCSS

- Use 4 spaces for SCSS. 
- Don't create top-level identifiers that might clash with other things in the project. e.g. creating a global attribute called `.exercise` would cause chaos everywhere.

### Accessbility
- Use the `image` method, not `image_tag` method and provide a sensible `alt` attribute
- Use the `icon` or `graphical_icon` methods, not `%i.fa` when using font-awesome.
