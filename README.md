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


#### For the first time
Set a server identity:

```bash
$ echo "host" > server_identity
```

You need Ruby and the `bundler` gem installed (`gem install bundler`). Then the following *should* get you a working rails server
```
bundle install
bundle exec rake bin/setup
bundle exec rails r "Git::UpdatesRepos.update"
bundle exec rails s
```

Something like this will get a working webserver on http://http://lvh.me:3000
Note: Teams will be avaliable on http://teams.lvh.me:3000

#### On future runs

You can just run:

```
bundle exec rails s
```

### Notes

We recommend using `lvh.me` which is a DNS redirect to localhost, but which we honour cookies on.


### Deleting an account

 To delete a user, run `user.destroy.`

The user record is deleted, as well as associated objects except the ff:

- Discussion posts where they are a mentor.
- Maintainer records where their user record is associated.
