# Exercism Website


## Development Setup

The discussed data model is [here](https://www.lucidchart.com/documents/edit/e07385eb-0214-4359-9755-14b6c4d5ecb4).

### Database

```
mysql -e "CREATE USER 'exercism_reboot'@'localhost' IDENTIFIED BY 'exercism_reboot'" -u root -p
mysql -e "create database exercism_reboot_development" -u root -p
mysql -e "create database exercism_reboot_test" -u root -p
mysql -e "GRANT ALL PRIVILEGES ON exercism_reboot_development.* TO 'exercism_reboot'@'localhost'" -u root -p
mysql -e "GRANT ALL PRIVILEGES ON exercism_reboot_test.* TO 'exercism_reboot'@'localhost'" -u root -p
```

