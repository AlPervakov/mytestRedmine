#!/bin/bash
# Install core system packages
export DEBIAN_FRONTEND=noninteractive
apt update
apt install -y mysql-server curl libmysqlclient-dev git-core subversion imagemagick libmagickwand-dev libcurl4-openssl-dev ruby-full dirmngr gnupg

# Installing Passenger + Nginx
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
apt-get install -y apt-transport-https ca-certificates
sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger xenial main > /etc/apt/sources.list.d/passenger.list'
apt-get update
apt-get install -y nginx-extras passenger

# Install Redmine
mkdir /var/data
cd /var/data/
svn co https://svn.redmine.org/redmine/branches/4.0-stable redmine

# Download configuration files
cd /tmp/
curl -O https://raw.githubusercontent.com/AlPervakov/mytestRedmine/master/nginx.conf
curl -O https://raw.githubusercontent.com/AlPervakov/mytestRedmine/master/database.yml
curl -O https://raw.githubusercontent.com/AlPervakov/mytestRedmine/master/passenger.conf
curl -O https://raw.githubusercontent.com/AlPervakov/mytestRedmine/master/redmine

# Set up Redmine
cp /tmp/database.yml /var/data/redmine/config/database.yml
cd /var/data/redmine
gem install bundler --no-ri --no-rdoc
bundle install

# Set up Passenger
cp /tmp/passenger.conf /etc/nginx/passenger.conf

# Set up Nginx
cp /tmp/nginx.conf /etc/nginx/nginx.conf
cp /tmp/redmine /etc/nginx/sites-available/redmine
ln -s /etc/nginx/sites-available/redmine /etc/nginx/sites-enabled/redmine
rm /etc/nginx/sites-enabled/default

# Set up database
service mysql start
sleep 2

mysql -u root --execute="CREATE DATABASE redmine character SET utf8;"
mysql -u root --execute="CREATE user 'redmine'@'localhost' IDENTIFIED BY 'redmine';"
mysql -u root --execute="GRANT ALL privileges ON redmine.* TO 'redmine'@'localhost';"

cd /var/data/redmine
rake generate_secret_token
RAILS_ENV=production rake db:migrate
RAILS_ENV=production REDMINE_LANG=en rake redmine:load_default_data
