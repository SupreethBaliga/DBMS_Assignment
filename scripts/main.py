import sys
import numpy as np

# populating sqlite3
print("For Sqlite3")
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
        temp = []
        for x in range(7):
            print(data[data_ptr][:-1])
            sum += float(data[data_ptr][:-1])
            temp.append(float(data[data_ptr][:-1]))
            data_ptr += 1
        arr = np.array(temp)
        avg = np.mean(arr)
        std = np.std(arr)
        quers.append([avg, std])
        print(f'Average = {quers[-1][0]:.6f}')
        print(f'Std. Deviation = {quers[-1][1]:.6f}')
        print(" ")
        data_ptr += 1
    sqlite3.append(quers)
f.close()

# populating MariaDB w/o index
print("For MariaDB without index")
maria = []
with open('./MariaDB/time_stats.txt', 'r') as f:
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
        temp = []
        for x in range(7):
            print(data[data_ptr][:-1])
            sum += float(data[data_ptr][:-1])
            temp.append(float(data[data_ptr][:-1]))
            data_ptr += 1
        arr = np.array(temp)
        avg = np.mean(arr)
        std = np.std(arr)
        quers.append([avg, std])
        print(f'Average = {quers[-1][0]:.6f}')
        print(f'Std. Deviation = {quers[-1][1]:.6f}')
        print(" ")
        data_ptr += 1
    maria.append(quers)
f.close()

# populating MariaDB with index
print("For MariaDB with index")
mariaidx = []
with open('./MariaDbIndex/time_stats.txt', 'r') as f:
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
        temp = []
        for x in range(7):
            print(data[data_ptr][:-1])
            sum += float(data[data_ptr][:-1])
            temp.append(float(data[data_ptr][:-1]))
            data_ptr += 1
        arr = np.array(temp)
        avg = np.mean(arr)
        std = np.std(arr)
        quers.append([avg, std])
        print(f'Average = {quers[-1][0]:.6f}')
        print(f'Std. Deviation = {quers[-1][1]:.6f}')
        print(" ")
        data_ptr += 1
    mariaidx.append(quers)
f.close()

# populating MongoDb
print("For MongoDb")
mongo = []
with open('./MongoDB/time_stats.txt', 'r') as f:
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
        temp = []
        for x in range(7):
            print(data[data_ptr][:-1])
            sum += float(data[data_ptr][:-1])
            temp.append(float(data[data_ptr][:-1]))
            data_ptr += 1
        arr = np.array(temp)
        avg = np.mean(arr)
        std = np.std(arr)
        quers.append([avg, std])
        print(f'Average = {quers[-1][0]:.6f}')
        print(f'Std. Deviation = {quers[-1][1]:.6f}')
        print(" ")
        data_ptr += 1
    mongo.append(quers)
f.close()

# Creating corresponding graph visualisations