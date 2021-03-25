import sys
from statistics import dev

# populating sqlite3
sqlite3 = []
with open('./Sqlite3/time_stats.txt', 'r') as f:
    data = f.readlines()
data_ptr = 0
for i in range(9):
    print(data[data_ptr][:-1])
    data_ptr += 1
    quers = []

    for k in range(4):
        print(data[data_ptr][:-1])
        data_ptr += 1
        sum = 0
        for x in range(7):
            print(data[data_ptr][:-1])
            sum += float(data[data_ptr][:-1])
            data_ptr += 1
        quers.append(sum/7.0)
        print(f'Average = {sum/7.0:.6f}')
        print(" ")
        data_ptr += 1
    sqlite3.append(quers)