#!/bin/bash

service php5-fpm start
service mysql start
/usr/sbin/apache2ctl -D FOREGROUND
