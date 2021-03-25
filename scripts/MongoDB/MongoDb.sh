#!/bin/sh
# Run this script as follows "bash MongoDb.sh > time_stats.txt 2> dump.txt"
# Caching is cleared after each query
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
    #import
    mongo test --eval "
        db.A.drop();
        db.B.drop();
    " > dump.txt
    mongoimport --type csv -d test -c A --headerline $apath
    mongoimport --type csv -d test -c B --headerline $bpath


    #for query1:
    echo "Query 1 -"
    for j in {0..6}
    do
        mongo test --eval '
            db.setProfilingLevel(2)
            pointer = db.A.find({A1 : {$lte : 50}}, {A1: true, A2: true, _id: false})
            while(pointer.hasNext()){printjson(pointer.next());}
            db.system.profile.find({}, {millis: 1}).limit(1).sort({ts: -1})
        ' > query_output.txt
        time_info=$( tail -n 1  query_output.txt )
        time_info=$(echo $time_info| awk '{print $4}')
        echo $time_info
        mongo test --eval '
            db.A.getPlanCache().clear()
            db.B.getPlanCache().clear()
        ' > dump.txt
    done
    echo " "

    #for query2:
    echo "Query 2 -"
    for j in {0..6}
    do
        mongo test --eval '
            db.setProfilingLevel(2, {filter:{op:"query"}})
            pointer = db.B.aggregate([{$sort: {B3 : 1} },{$project: {_id: false, B1: true, B2: true, B3: true}}],{ "allowDiskUse" : true })
            while(pointer.hasNext()) {printjson(pointer.next());}
            db.system.profile.find({}, {millis: 1}).limit(1).sort({ts: -1})
        ' > query_output.txt
        time_info=$( tail -n 1  query_output.txt )
        time_info=$(echo $time_info| awk '{print $4}')
        echo $time_info
        mongo test --eval '
            db.A.getPlanCache().clear()
            db.B.getPlanCache().clear()
        ' > dump.txt
    done
    echo " "

    #for query3:
    echo "Query 3 -"
    for j in {0..6}
    do
        mongo test --eval '
            db.setProfilingLevel(2, {filter:{op:"query"}})
            pointer = db.B.aggregate([{$group: {_id: "$B2", total: {$sum: 1}}},{$group: {_id: null, answer: {$avg: "$total"}}},{$project: {_id: false,answer: true}}]);
            while(pointer.hasNext()) {printjson(pointer.next());}
            db.system.profile.find({}, {millis: 1}).limit(1).sort({ts: -1})
        ' > query_output.txt
        time_info=$( tail -n 1  query_output.txt )
        time_info=$(echo $time_info| awk '{print $4}')
        echo $time_info
        mongo test --eval '
            db.A.getPlanCache().clear()
            db.B.getPlanCache().clear()
        ' > dump.txt
    done
    echo " "

    #for query4:
    echo "Query 4 -"
    for j in {0..6}
    do
        mongo test --eval '
            db.setProfilingLevel(2, {filter:{op:"query"}})
            pointer = db.B.aggregate([{$lookup: {from: "A",localField: "B2",foreignField: "A1",as: "temp"}},{$match: {"temp": {$ne: []}}},{$project:{_id: false,B1: true,B2: true,B3: true,A2: {$arrayElemAt: ["$temp.A2", 0]},}}]);
            while(pointer.hasNext()) {printjson(pointer.next());}
            db.system.profile.find({}, {millis: 1}).limit(1).sort({ts: -1})
        ' > query_output.txt
        time_info=$( tail -n 1  query_output.txt )
        time_info=$(echo $time_info| awk '{print $4}')
        echo $time_info
        mongo test --eval '
            db.A.getPlanCache().clear()
            db.B.getPlanCache().clear()
        ' > dump.txt
    done
    echo " "
done