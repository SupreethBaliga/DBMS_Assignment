CREATE DATABASE IF NOT EXISTS test;
USE test;
drop table if exists B;
drop table if exists A;

create table A(
    A1 integer primary key,
    A2 text
);
LOAD DATA LOCAL INFILE '../../data/A-10000.csv'
INTO TABLE A
FIELDS TERMINATED BY ','
IGNORE 1 LINES;

create table B(
    B1 integer primary key,
    B2 integer,
    B3 text,
    foreign key (B2) references A(A1)
);
LOAD DATA LOCAL INFILE '../../data/B-10000-500-1.csv'
INTO TABLE B
FIELDS TERMINATED BY ','
IGNORE 1 LINES;

-- .import ../../data/A-100.csv A  --change the path according to 
                                -- where data is stored


-- .import ../../data/B-100-3-4.csv B  --change the path according to 
                                    -- where data is stored
