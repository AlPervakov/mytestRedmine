#!/bin/bash
# Install core system packages
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y mysql-server ruby-full

service mysql start
sleep 2

mysql -u root --execute="CREATE DATABASE redmine character SET utf8;"
mysql -u root --execute="CREATE user 'redmine'@'localhost' IDENTIFIED BY 'redmine';"
mysql -u root --execute="GRANT ALL privileges ON redmine.* TO 'redmine'@'localhost';"

rake generate_secret_token
RAILS_ENV=production rake db:migrate
RAILS_ENV=production REDMINE_LANG=ru rake redmine:load_default_data
