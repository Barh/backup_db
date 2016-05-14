#!/bin/bash

# directory script
dir_script="$(dirname "$0")"

# settings
source ${dir_script}'/settings.sh'

# get db names
DBNAME=($(mysqlshow -u ${user} -p`< ${password}` | sed -e '1,3d' -e '$d' | awk '{print $2}'))

# each exclude db
for i in "${exclude_db[@]}"; do
    # each db names
    for db_key in "${!DBNAME[@]}"; do
        # need exclude db
        if [ $i = ${DBNAME[$db_key]} ];
        then
            # unset key from db
            unset DBNAME[$db_key]
        fi
    done
done

# each db names
for i in "${DBNAME[@]}"; do

    # current db name
    file_name=${i}.sql

    # create dir (if req) and change dir (cd)
    cd ${path_to};
    mkdir -p ${i}
    cd ${i};

    # create sql dump db (if correct)
    if (mysqldump --skip-dump-date -u ${user} -p`< ${password}` ${i} > ${file_name})
    then
        # check git
        if !(git status &> /dev/null)
        then # no is
            # init git
            git init &> /dev/null
            # add file
            git add ${file_name} &> /dev/null
        fi

        # commit
        git commit -am $commit_name &> /dev/null
    fi
done