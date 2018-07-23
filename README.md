# Exercism Website

## Development Setup

This is a Ruby on Rails (5.2) application backed by MySQL. There are two ways to run it locally:
1) Setup a local development environment with the steps below 
2) Use a pre-made Docker setup. We don't maintain an official Docker repo, but you can try [this version](https://github.com/unused/exercism-docker) kindly maintained by [@unused](https://github.com/unused).

### Database

You need MySQL installed. Something like this will then get a working database setup:

```bash
mysql -e "CREATE USER 'exercism_reboot'@'localhost' IDENTIFIED BY 'exercism_reboot'" -u root -p
mysql -e "create database exercism_reboot_development" -u root -p
mysql -e "create database exercism_reboot_test" -u root -p
mysql -e "ALTER DATABASE exercism_reboot_development CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" -u root -p
mysql -e "ALTER DATABASE exercism_reboot_test CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" -u root -p
mysql -e "GRANT ALL PRIVILEGES ON exercism_reboot_development.* TO 'exercism_reboot'@'localhost'" -u root -p
mysql -e "GRANT ALL PRIVILEGES ON exercism_reboot_test.* TO 'exercism_reboot'@'localhost'" -u root -p
```

### Ruby

You need Ruby installed. We use version 2.4. 

### Bundler

Bundle is used to handle the project's Ruby dependancies. You can install it via
```bash
gem install bundler
```

### Application setup

We've put a rake task together that should get you set up. You can run it like this.

```bash
bundle install
bundle exec rake exercism:setup
```

### Running a webserver

To run a webserver, simple run:
```bash
bundle exec rails s
```

Something like this will get a working webserver on http://http://lvh.me:3000
Note: Teams will be avaliable on http://teams.lvh.me:3000

### Notes

We recommend using `lvh.me` which is a DNS redirect to localhost, but which we honour cookies on.

## Extra scripts and useful notes

### Deleting an account

 To delete a user, run `user.destroy.`

The user record is deleted, as well as associated objects except the ff:

- Discussion posts where they are a mentor.
- Maintainer records where their user record is associated.
