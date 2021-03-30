.mode csv
.headers on
.timer on

drop table if exists A;
create table A(
    A1 integer primary key,
    A2 text
);
.import ../../data/A-100.csv A

drop table if exists B;
create table B(
    B1 integer primary key,
    B2 integer,
    B3 text,
    foreign key (B2) references A(A1)
);
.import ../../data/B-100-3-4.csv B 
