# Exercism website

[![Build Status](https://travis-ci.com/exercism/website.svg?branch=master)](https://travis-ci.com/exercism/website)
[![Maintainability](https://api.codeclimate.com/v1/badges/a287df685c8499df632e/maintainability)](https://codeclimate.com/github/exercism/website/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/a287df685c8499df632e/test_coverage)](https://codeclimate.com/github/exercism/website/test_coverage)

## Development setup

This is a Ruby on Rails (5.2) application backed by MySQL. There are two ways to run it locally:
1) Setup a local development environment with the steps below.
2) Use a pre-made Docker setup. We don't maintain an official Docker repo, but you can try [this version](https://github.com/unused/exercism-docker) kindly maintained by [@unused](https://github.com/unused).

### Things to install

- **Ruby**: We recommend Ruby >=2.4 (and this will soon become a requirement). We recommend using [RVM](http://rvm.io/)
- **MySQL**: MySQL >=5.7 required. Install via your system's package manager or follow the official [Installation instructions](https://dev.mysql.com/downloads/mysql/)
- **Yarn**: Yarn handles front-end dependencies. See Yarn's [installation instructions](https://yarnpkg.com/lang/en/docs/install).

### Configure the database

Something like this will then get a working database setup:

```bash
mysql -e "CREATE USER 'exercism_reboot'@'localhost' IDENTIFIED BY 'exercism_reboot'" -u root -p
mysql -e "create database exercism_reboot_development" -u root -p
mysql -e "create database exercism_reboot_test" -u root -p
mysql -e "ALTER DATABASE exercism_reboot_development CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" -u root -p
mysql -e "ALTER DATABASE exercism_reboot_test CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" -u root -p
mysql -e "GRANT ALL PRIVILEGES ON exercism_reboot_development.* TO 'exercism_reboot'@'localhost'" -u root -p
mysql -e "GRANT ALL PRIVILEGES ON exercism_reboot_test.* TO 'exercism_reboot'@'localhost'" -u root -p
```

### Install Bundler

Bundle is used to handle the project's Ruby dependancies. You can install it via
```bash
gem install bundler
```

### Initial setup

Firstly, you need to set a server identity, which you can do like this:

```bash
echo "host" > server_identity
```

Then we've put a rake task together that should set everything else up. You can run it like this:

```bash
bundle install
bundle exec rake exercism:setup
```

### Running a webserver

To run a webserver, simple run:
```bash
bundle exec rails s
```

Something like this will get a working webserver on http://lvh.me:3000
Note: Teams will be avaliable on http://teams.lvh.me:3000

### Notes

We recommend using `lvh.me` which is a DNS redirect to localhost, but which we honour cookies on.

## Extra scripts and useful notes

### Deleting an account

 To delete a user, run `user.destroy.`

The user record is deleted, as well as associated objects except the ff:

- Discussion posts where they are a mentor.
- Maintainer records where their user record is associated.

### Unlock first exercise for each user track

For when @iHiD breaks things.

```
user_track_ids.each do |id|
  ut = UserTrack.find(id)
  CreateSolution.(ut.user, ut.track.exercises.core.first) if ut.solutions.size == 0
end
```

## Troubleshooting
### MySQL < 5.7
The following error is seen using MySQL prior to version 5.7 a discussed at gogs/gogs#4894.
```
$ bundle exec rake exercism:setup
Mysql2::Error: Specified key was too long; max key length is 767 bytes:
```
If your system doesn't have a pre-built 5.7 package, [this install log](https://github.com/exercism/pharo/issues/103#issuecomment-420769061) may be helpful.

### Windows Subsystem For Linux
Installation on Windows Subsystem For Linux requires Windows Version 1809 (release due October 2018). 
Tracked at exercism/exercism#4346.
