CREATE DATABASE IF NOT EXISTS test;
USE test;
drop table if exists B;
drop table if exists A;

create table A(
    A1 integer primary key,
    A2 varchar(32000)
);
LOAD DATA LOCAL INFILE '../../data/A-10000.csv'
INTO TABLE A
FIELDS TERMINATED BY ','
IGNORE 1 LINES;
CREATE INDEX IF NOT EXISTS A_idx_1 on A(A2(32000));

create table B(
    B1 integer primary key,
    B2 integer,
    B3 varchar(32000),
    foreign key (B2) references A(A1) ON DELETE CASCADE
);
LOAD DATA LOCAL INFILE '../../data/B-10000-500-1.csv'
INTO TABLE B
FIELDS TERMINATED BY ','
IGNORE 1 LINES;
CREATE INDEX IF NOT EXISTS B_idx_1 on B(B2);
CREATE INDEX IF NOT EXISTS B_idx_2 on B(B3(32000));

-- .import ../../data/A-100.csv A  --change the path according to 
                                -- where data is stored


-- .import ../../data/B-100-3-4.csv B  --change the path according to 
                                    -- where data is stored
