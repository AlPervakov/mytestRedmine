#!/bin/bash
service mysql start
tail -F /var/log/mysql/error.log
