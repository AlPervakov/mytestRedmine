#!/bin/bash
# Install core system packages
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y mysql-server

service mysql start
sleep 2

mysql -u root --execute="CREATE DATABASE redmine character SET utf8;"
mysql -u root --execute="CREATE user 'redmine'@'localhost' IDENTIFIED BY 'redmine';"
mysql -u root --execute="GRANT ALL privileges ON redmine.* TO 'redmine'@'localhost';"
