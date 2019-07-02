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
- Use double quotes everywhere.

### Haml

- When executing Ruby, do not use spaces between the `=` and the method. e.g. use `=image_tag` not `= image_tag`.
- Use double quotes everywhere.

### SCSS

- Use 4 spaces for SCSS. 
- Don't create top-level identifiers that might clash with other things in the project. e.g. creating a global attribute called `.exercise` would cause chaos everywhere.

### Accessbility
- Use the `image` method, not `image_tag` method and provide a sensible `alt` attribute
- Use the `icon` or `graphical_icon` methods, not `%i.fa` when using font-awesome.

## Creating test repos

Since most of the content in the website is hosted as repositories on Github, we need to replicate it in our test environment. We do this by hosting our own repos in the `test/fixtures` folder.

We currently have test repos for a track (`test/fixtures/track`), website-copy (`test/fixtures/website-copy`), and problem-specifications (`test/problem-specifications`).

### Modifiying a test repo

1. Clone the test repo. (`git clone /path/to/exercism_repo/test/fixtures/website-copy`)
2. Make the necessary changes to the cloned repo.
3. Commit and push to master. This pushes the changes to the test repo in the exercism codebase.
