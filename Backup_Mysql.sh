#!/bin/bash
#################################################################
# Memo:MySQL databases and tables
#       -e "D" use MysqlDump
#       -d database
#Version:1.0
#################################################################
while getopts ":e:d:" optval "$@"
  do
    case $optval in
      "e")
        backup_type="$OPTARG"
      ;;
      "d")
        database="$OPTARG"
      ;;
      *)
        echo "Usage: $0 -e D -d database"
        exit
        ;;
    esac
  done

if [ "$backup_type" = "" ] || [ "$database" = "" ]; then

    echo "Usage: $0 -e D database"
    exit
fi

###############Basic parameters##########################
TIME=`date +%Y%m%d-%H`
DAY=`date +%Y%m%d`
Host=`hostname`


###############Environment Parameters####################
Environment="M"
USER="backup"
PASSWD="xxxxxxxxx"
DATADIR="/home/db_backup/${DAY}/"
mkdir -p ${DATADIR} 
##########################################################

Dump(){
 MYSQLDUMP="/home/mysql/bin/mysqldump"
 ${MYSQLDUMP} --single-transaction --routines --triggers --master-data=2 -u${USER} -p${PASSWD} ${database} | gzip > ${DATADIR}/${Host}-${Environment}-${TIME}-${database}.sql.gz
}


# Running Backup
if [ "$backup_type" = "D" ]; then
   Dump
elif [ "$backup_type" = "C" ]; then
   cp /etc/my.cnf ${DATADIR}/${Host}-${Environment}-${TIME}.cnf
fi
