#!/bin/bash
service nginx start
tail -F /var/log/nginx/error.log
