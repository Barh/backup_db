#!/bin/bash

# the storage path of the backup
path_to="/root/backup/db_git/"

# user mysql
user="root"

# password mysql stored in the file
password="/root/scripts/data/mysql_root_password"

# exclude tables
exclude_db=(information_schema performance_schema mysql);

# commit name
commit_name="AutoBackup"