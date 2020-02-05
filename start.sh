#!/bin/bash
service mysql start
service nginx start
tail -F /var/log/nginx/error.log
