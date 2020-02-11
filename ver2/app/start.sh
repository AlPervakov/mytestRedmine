#!/bin/bash
service nginx start
RAILS_ENV=production rake db:migrate
tail -F /var/log/nginx/error.log
