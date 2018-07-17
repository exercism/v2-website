# Exercism Website

## Development Setup

This is a Ruby on Rails (5.2) application backed by MySQL.

### Database

You need MySQL installed. Something like this will then get a working database setup:

```
mysql -e "CREATE USER 'exercism_reboot'@'localhost' IDENTIFIED BY 'exercism_reboot'" -u root -p
mysql -e "create database exercism_reboot_development" -u root -p
mysql -e "create database exercism_reboot_test" -u root -p
mysql -e "ALTER DATABASE exercism_reboot_development CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" -u root -p
mysql -e "ALTER DATABASE exercism_reboot_test CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" -u root -p
mysql -e "GRANT ALL PRIVILEGES ON exercism_reboot_development.* TO 'exercism_reboot'@'localhost'" -u root -p
mysql -e "GRANT ALL PRIVILEGES ON exercism_reboot_test.* TO 'exercism_reboot'@'localhost'" -u root -p
```

### Running the application

To setup a local development environment you'll have either to prepare your
local system with a ruby environment (ruby, rubygems, bundler) and JavaScript
runtime nodejs include package manager yarn or use [docker-compose]. Later
requires some basic knowledge about [Docker] and a Docker installation.

[Docker]: https://www.docker.com/what-docker "What is Docker?"
[docker-compose]: https://docs.docker.com/compose/ "Docker Compose"

#### For the First Time

Set a server identity:

```bash
$ echo "host" > server_identity
```

You need Ruby and the `bundler` gem installed (`gem install bundler`). Then the
following *should* get you a working rails server.

```
bundle install
bundle exec rake bin/setup
bundle exec rails r "Git::UpdatesRepos.update"
bundle exec rails s # shorthand for bundle exec rails server
```

Something like this will get a working webserver on http://lvh.me:3000
Note: Teams will be avaliable on http://teams.lvh.me:3000

#### On Future Runs

You can just run: `bundle exec rails s[erver]`

#### Docker Compose Development Setup

```
$ echo "host" > server_identity # Set server identity file
$ docker-compose -p exercism up # Start the local development environment
$ docker-compose -p exercism exec rails bin/rails exercism:setup # Setup database and git repos

$ docker-compose -p exercism down # Remove local environment
$ docker rmi exercism_rails # Cleanup build docker image
```

### Notes

We recommend using `lvh.me` which is a DNS redirect to localhost, but which we
honour cookies on.


### Deleting an Account

To delete a user, run `user.destroy`.

The user record is deleted, as well as associated objects except the ff:

- Discussion posts where they are a mentor.
- Maintainer records where their user record is associated.
