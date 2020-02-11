#!/bin/bash
service nginx start
cd /var/data/redmine
RAILS_ENV=production rake db:migrate
RAILS_ENV=production REDMINE_LANG=en rake redmine:load_default_data
tail -F /var/log/nginx/error.log
