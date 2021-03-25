#!/bin/sh
# Run this script as follows "bash MariaDb.sh > time_stats.txt 2> dump.txt"
# Caching is cleared after every query
declare -a aarr=("A-100.csv" 
                "A-100.csv" 
                "A-100.csv"
                "A-1000.csv"
                "A-1000.csv"
                "A-1000.csv"
                "A-10000.csv"
                "A-10000.csv"
                "A-10000.csv"
                )

declare -a barr=("B-100-3-4.csv" 
                "B-100-5-0.csv" 
                "B-100-10-3.csv"
                "B-1000-5-0.csv"
                "B-1000-10-0.csv"
                "B-1000-50-0.csv"
                "B-10000-5-3.csv"
                "B-10000-50-0.csv"
                "B-10000-500-1.csv"
                )

path="../../data/" # set the path of the directory in which data is stored
MARIA_USER="root"
MARIA_PWD="maria"
for i in {0..8}
do
    apath="$path${aarr[i]}"
    bpath="$path${barr[i]}"
    echo $((i+1)) ":" $apath, $bpath
    mysql -u$MARIA_USER -p$MARIA_PWD -e "CREATE DATABASE IF NOT EXISTS test;USE test; drop table if exists B; drop table if exists A;"
    mysql -u$MARIA_USER -p$MARIA_PWD -e "USE test; create table A(A1 integer, A2 text);"
    mysql -u$MARIA_USER -p$MARIA_PWD -e "USE test; create table B( B1 integer, B2 integer, B3 text);"
    mysql -u$MARIA_USER -p$MARIA_PWD -e "USE test; LOAD DATA LOCAL INFILE '$apath' INTO TABLE A FIELDS TERMINATED BY ',' IGNORE 1 LINES;"
    mysql -u$MARIA_USER -p$MARIA_PWD -e "USE test; LOAD DATA LOCAL INFILE '$bpath' INTO TABLE B FIELDS TERMINATED BY ',' IGNORE 1 LINES;"

    #For query1:
    echo "Query 1-"
    for j in {0..6}
    do
        mysql -u$MARIA_USER -p$MARIA_PWD -e "USE test; set profiling=1; set profiling_history_size=1; SELECT * FROM A WHERE A1 <= 50; show profiles;" > query_output.txt
        time_info=$( tail -n 1  query_output.txt )
        time_info=$(echo $time_info| awk '{print $2}')
        echo $time_info
        mysql -u$MARIA_USER -p$MARIA_PWD -e "reset query cache;"
    done
    echo " "
    #For query2:
    echo "Query 2-"
    for j in {0..6}
    do
        mysql -u$MARIA_USER -p$MARIA_PWD -e "USE test; set profiling=1; set profiling_history_size=1; SELECT * FROM B ORDER BY BINARY B3 ASC; show profiles;" > query_output.txt
        time_info=$( tail -n 1  query_output.txt )
        time_info=$(echo $time_info| awk '{print $2}')
        echo $time_info
        mysql -u$MARIA_USER -p$MARIA_PWD -e "reset query cache;"
    done
    echo " "
    #For query3:
    echo "Query 3-"
    for j in {0..6}
    do
        mysql -u$MARIA_USER -p$MARIA_PWD -e "USE test; set profiling=1; set profiling_history_size=1; SELECT AVG(vals) FROM (SELECT B2, COUNT(B1) AS vals FROM B GROUP BY B2) AS K; show profiles;" > query_output.txt
        time_info=$( tail -n 1  query_output.txt )
        time_info=$(echo $time_info| awk '{print $2}')
        echo $time_info
        mysql -u$MARIA_USER -p$MARIA_PWD -e "reset query cache;"
    done
    echo " "
    #For query4:
    echo "Query 4-"
    for j in {0..6}
    do
        mysql -u$MARIA_USER -p$MARIA_PWD -e "USE test; set profiling=1; set profiling_history_size=1; SELECT B1, B2, B3, A2 FROM (B INNER JOIN A ON B.B2 = A.A1); show profiles;" > query_output.txt
        time_info=$( tail -n 1  query_output.txt )
        time_info=$(echo $time_info| awk '{print $2}')
        echo $time_info
        mysql -u$MARIA_USER -p$MARIA_PWD -e "reset query cache;"
    done
    echo " "
done