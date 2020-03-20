#!/bin/bash

# 1. backup DB menjadi file SQL
# silahkan disesuaikan parameternya

MYSQL_ARGS="--defaults-extra-file=/etc/mysql/my.cnf"
MYSQL="/usr/bin/mysql $MYSQL_ARGS"
MYSQLDUMP="/usr/bin/mysqldump $MYSQL_ARGS"
DATE=`date '+%Y%m%d-%H%M'`
BACKUP="/var/www/backup"
 
$MYSQL -BNe "show databases" | egrep -v '(mysql|.*_schema|sys)' | xargs -n1 -I {} $MYSQLDUMP {} -r $BACKUP/{}.sql > /dev/null 2>&1 && chmod 640 $BACKUP/*.sql && chgrp root $BACKUP/*.sql
 
# 2. backup compress file app jadi tar.gz
# silahkan disesuaikan lokasi dan folder nya
tar cfz /var/www/backup/app.tar.gz -C /usr/share/nginx/html/app

# 3. upload file tersebut ke google drive
gdrive upload /var/www/backup/db.sql
gdrive upload /var/www/backup/app.tar.gz 
# simpan file ini dengan nama backup_gdrive.sh