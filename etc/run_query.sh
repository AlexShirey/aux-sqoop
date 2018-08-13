#!/bin/bash

if [[ $# -ne 2 ]]; then
	echo "error: illegar number of args (sql_file, sql_username)"
	exit -1
fi

SQL_FILE=$1
SQL_USER=$2

if [[ ! -e $SQL_FILE ]]; then
	echo "error: $SQL_FILE is not a file or doesn't exists"
	exit -1
fi

echo "starting mysql shell to execute the query from $SQL_FILE, please enter password for $SQL_USER"

cat $SQL_FILE | mysql -u $SQL_USER -p

echo "query from $SQL_FILE executed!"
