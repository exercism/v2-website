# Exercism Website

## Development Setup

This is a Ruby on Rails (5.1) application backed by MySQL.

### Database

Something like this will get a working database setup:

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

Something like this will get a working webserver on http://localhost:3000.
Note: Teams will be avaliable on http://teams.localhost:3000.

```
bundle install
bundle exec rake db:schema:load
bundle exec rake db:seed
bundle exec rails r "Git::UpdatesRepos.update"
bundle exec rails s
```

## Misc commands
### Server identity

```bash
$ echo "host" > server_identity
```
