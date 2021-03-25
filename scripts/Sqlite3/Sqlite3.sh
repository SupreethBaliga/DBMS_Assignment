#!/bin/sh
# Run this script as follows "bash Sqlite3.sh > time_stats.txt 2> dump.txt"
# There is no query caching in sqlite3
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

for i in {0..8}
do
    apath="$path${aarr[i]}"
    bpath="$path${barr[i]}"
    echo $((i+1)) ":" $apath, $bpath
    #import the data
    sqlite3 test.db "drop table if exists B;"
    sqlite3 test.db "drop table if exists A;"
    sqlite3 test.db "create table A(A1 integer primary key, A2 text);"
    sqlite3 test.db "create table B(B1 integer primary key, B2 integer, B3 text, foreign key (B2) references A(A1));"
    sqlite3 test.db ".mode csv" ".headers on" ".timer on" ".import $apath A" ".import $bpath B"
    # Query 1
    echo "For Query 1-"
    for j in {0..6}
    do
        sqlite3 test.db -cmd ".timer on" <<< "SELECT * FROM A WHERE A1 <= 50;" >  query_output.txt
        time_info=$( tail -n 1  query_output.txt )
        time_info1=$(echo $time_info| awk '{print $6}')
        time_info2=$(echo $time_info| awk '{print $8}')
        total=$(bc -l <<<"${time_info1}+${time_info2}")
        echo $total
    done
    echo " "
    # Query 2
    echo "For Query 2-"
    for j in {0..6}
    do
        sqlite3 test.db -cmd ".timer on" <<< "SELECT * FROM B ORDER BY B3 ASC;" >  query_output.txt
        time_info=$( tail -n 1  query_output.txt )
        time_info1=$(echo $time_info| awk '{print $6}')
        time_info2=$(echo $time_info| awk '{print $8}')
        total=$(bc -l <<<"${time_info1}+${time_info2}")
        echo $total
    done
    echo " "
    # Query 3
    echo "For Query 3-"
    for j in {0..6}
    do
        sqlite3 test.db -cmd ".timer on" <<< "SELECT AVG(vals) FROM (SELECT B2, COUNT(B1) AS vals FROM B GROUP BY B2);" >  query_output.txt
        time_info=$( tail -n 1  query_output.txt )
        time_info1=$(echo $time_info| awk '{print $6}')
        time_info2=$(echo $time_info| awk '{print $8}')
        total=$(bc -l <<<"${time_info1}+${time_info2}")
        echo $total
    done
    echo " "
    # Query 4
    echo "For Query 4-"
    for j in {0..6}
    do
        sqlite3 test.db -cmd ".timer on" <<< "SELECT B1, B2, B3, A2 FROM (B INNER JOIN A ON B.B2 = A.A1);" >  query_output.txt
        time_info=$( tail -n 1  query_output.txt )
        time_info1=$(echo $time_info| awk '{print $6}')
        time_info2=$(echo $time_info| awk '{print $8}')
        total=$(bc -l <<<"${time_info1}+${time_info2}")
        echo $total
    done
    echo " "
done
