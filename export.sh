#!/bin/bash

if  [[ $# -ne 2 ]] && [[ $# -ne 4 ]]; then
	echo "error: illegar number of args (data_dir, num_mappers) [sql_file] [sql_username]"
	exit -1
fi

DATA_DIR=$1
NUM_MAPPERS=$2
CONFIG_FILE=./etc/app.config
RUN_QUERY=./etc/run_query.sh

if [[ ! -d $DATA_DIR ]]; then
	echo "error: $DATA_DIR is not a dir or doens't exists"
	exit -1
fi

regex='^[0-9]+$'
if ! [[ $NUM_MAPPERS =~ $regex ]]; then
	echo  "error: num_mappers is not a number"
	exit -1
fi

if [[ ! -e $CONFIG_FILE ]]; then
	echo "error: $CONFIG_FILE is not a file or doesn't exists"
	exit -1
fi

echo -e "please select: \
		\n1 - create new database and tables to export data in (run sql query)\
		\n2 - use existing database and tables which are specified in $CONFIG_FILE (without running sql query)"
		
read CHOICE

if [[ $CHOICE == 1 ]]; then
	if [[ $# != 4 ]]; then
		echo "error: [sql_file] [sql_username] are not specified, please run app with this args"
		exit -1
	fi	
	bash $RUN_QUERY $3 $4
	if [[ $? -ne 0 ]]; then
		exit -1
	fi
elif [[ $CHOICE != 2 ]]; then
	echo "error: no such choice, exiting!"
	exit -1
fi	
	
echo "trying to export raw data to mysql table using sqoop..."

#put data to hdfs
echo "phase 1: putting $DATA_DIR to HDFS temp directory to proccess the data..."
EXPORT_DIR=/tmp/sqoop_tmp
hdfs dfs -mkdir $EXPORT_DIR
hdfs dfs -put ${DATA_DIR}/* $EXPORT_DIR

#run sqoop
echo -e "phase 1: done! \nphase2: starting sqoop to export data from HDFS to RDBMS table..."
sqoop export 	--options-file $CONFIG_FILE \
		--export-dir $EXPORT_DIR \
		--num-mappers $NUM_MAPPERS \
		--clear-staging-table	
		#--direct doesn't support --staging-table 

#remove temp dir from HDFS
echo -e "phase 2: done! \nphase3: removing temp dir from HDFS..."
hdfs dfs -rm -r -f $EXPORT_DIR

echo "phase 3: done! All data exported successfully. Please, check MySQL table for exported data"
