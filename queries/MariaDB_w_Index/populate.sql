CREATE DATABASE IF NOT EXISTS test;
USE test;
drop table if exists B;
drop table if exists A;

create table A(
    A1 integer primary key,
    A2 text
);
LOAD DATA LOCAL INFILE '../../data/A-100.csv'
INTO TABLE A
FIELDS TERMINATED BY ','
IGNORE 1 LINES;
CREATE FULLTEXT INDEX IF NOT EXISTS A_idx_2 on A(A2);

create table B(
    B1 integer primary key,
    B2 integer,
    B3 text,
    foreign key (B2) references A(A1) ON DELETE CASCADE
);
LOAD DATA LOCAL INFILE '../../data/ B-100-10-3.csv'
INTO TABLE B
FIELDS TERMINATED BY ','
IGNORE 1 LINES;
CREATE INDEX IF NOT EXISTS B_idx_1 on B(B2);
CREATE FULLTEXT INDEX IF NOT EXISTS B_idx_2 on B(B3);

-- .import ../../data/A-100.csv A  --change the path according to 
                                -- where data is stored


-- .import ../../data/B-100-3-4.csv B  --change the path according to 
                                    -- where data is stored
