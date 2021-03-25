#!/bin/sh
# Run this script as follows "bash Maria_Db_Index.sh > time_stats.txt 2> dump.txt"
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
    mysql -u$MARIA_USER -p$MARIA_PWD -e "USE test; create table A( A1 integer primary key, A2 varchar(32000));"
    mysql -u$MARIA_USER -p$MARIA_PWD -e "USE test; create table B( B1 integer primary key, B2 integer, B3 varchar(32000), foreign key (B2) references A(A1) ON DELETE CASCADE);"
    mysql -u$MARIA_USER -p$MARIA_PWD -e "USE test; LOAD DATA LOCAL INFILE '$apath' INTO TABLE A FIELDS TERMINATED BY ',' IGNORE 1 LINES;"
    mysql -u$MARIA_USER -p$MARIA_PWD -e "USE test; LOAD DATA LOCAL INFILE '$bpath' INTO TABLE B FIELDS TERMINATED BY ',' IGNORE 1 LINES;"
    mysql -u$MARIA_USER -p$MARIA_PWD -e "USE test;CREATE INDEX IF NOT EXISTS A_idx_1 on A(A2(32000));"
    mysql -u$MARIA_USER -p$MARIA_PWD -e "USE test;CREATE INDEX IF NOT EXISTS B_idx_1 on B(B2); CREATE INDEX IF NOT EXISTS B_idx_2 on B(B3(32000));"
    
    # No need for indexes on A1 and B1 since primary keys so implicit indexing

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
        mysql -u$MARIA_USER -p$MARIA_PWD -e "USE test; set profiling=1; set profiling_history_size=1; SELECT * FROM B USE INDEX(B_idx_2) ORDER BY BINARY B3 ASC; show profiles;" > query_output.txt
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
        mysql -u$MARIA_USER -p$MARIA_PWD -e "USE test; set profiling=1; set profiling_history_size=1; SELECT AVG(vals) FROM (SELECT B2, COUNT(B1) AS vals FROM B USE INDEX(B_idx_1) GROUP BY B2) AS K; show profiles;" > query_output.txt
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
        mysql -u$MARIA_USER -p$MARIA_PWD -e "USE test; set profiling=1; set profiling_history_size=1; SELECT B1, B2, B3, A2 FROM (B USE INDEX(B_idx_1,B_idx_2) INNER JOIN A USE INDEX(A_idx_1) ON B.B2 = A.A1); show profiles;" > query_output.txt
        time_info=$( tail -n 1  query_output.txt )
        time_info=$(echo $time_info| awk '{print $2}')
        echo $time_info
        mysql -u$MARIA_USER -p$MARIA_PWD -e "reset query cache;"
    done
    echo " "
done