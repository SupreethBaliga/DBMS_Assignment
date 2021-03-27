import sys
import numpy as np
import matplotlib.pyplot as plt

files =["A-100.csv, B-100-3-4.csv",
        "A-100.csv, B-100-5-0.csv",
        "A-100.csv, B-100-10-3.csv",
        "A-1000.csv, B-1000-5-0.csv",
        "A-1000.csv, B-1000-10-0.csv",
        "A-1000.csv, B-1000-50-0.csv",
        "A-10000.csv, B-10000-5-3.csv",
        "A-10000.csv, B-10000-50-0.csv",
        "A-10000.csv, B-10000-500-1.csv"
    ]
# populating sqlite3
print("######################## For Sqlite3 ################################")
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
        temp = []
        for x in range(7):
            print(data[data_ptr][:-1])
            temp.append(float(data[data_ptr][:-1]))
            data_ptr += 1
        temp.sort()
        arr = np.array(temp[1:-1])
        avg = np.mean(arr)
        std = np.std(arr)
        quers.append([avg, std])
        print(f'After removing the max and min (Outliers):')
        print(f'Average = {quers[-1][0]:.6f}')
        print(f'Std. Deviation = {quers[-1][1]:.6f}')
        print(" ")
        data_ptr += 1
    sqlite3.append(quers)
f.close()

# populating MariaDB w/o index
print("###################### For MariaDB without index ###################")
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
        temp = []
        for x in range(7):
            print(data[data_ptr][:-1])
            temp.append(float(data[data_ptr][:-1]))
            data_ptr += 1
        temp.sort()
        arr = np.array(temp[1:-1])
        avg = np.mean(arr)
        std = np.std(arr)
        quers.append([avg, std])
        print(f'After removing the max and min (Outliers):')
        print(f'Average = {quers[-1][0]:.6f}')
        print(f'Std. Deviation = {quers[-1][1]:.6f}')
        print(" ")
        data_ptr += 1
    maria.append(quers)
f.close()

# populating MariaDB with index
print("####################### For MariaDB with index######################")
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
        temp = []
        for x in range(7):
            print(data[data_ptr][:-1])
            temp.append(float(data[data_ptr][:-1]))
            data_ptr += 1
        temp.sort()
        arr = np.array(temp[1:-1])
        avg = np.mean(arr)
        std = np.std(arr)
        quers.append([avg, std])
        print(f'After removing the max and min (Outliers):')
        print(f'Average = {quers[-1][0]:.6f}')
        print(f'Std. Deviation = {quers[-1][1]:.6f}')
        print(" ")
        data_ptr += 1
    mariaidx.append(quers)
f.close()

# populating MongoDb
print("################################For MongoDb################################")
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
        temp = []
        for x in range(7):
            print(float(data[data_ptr][:-1])/1000)
            temp.append(float(data[data_ptr][:-1])/1000)
            data_ptr += 1
        temp.sort()
        arr = np.array(temp[1:-1])
        avg = np.mean(arr)
        std = np.std(arr)
        quers.append([avg, std])
        print(f'After removing the max and min (Outliers):')
        print(f'Average = {quers[-1][0]:.6f}')
        print(f'Std. Deviation = {quers[-1][1]:.6f}')
        print(" ")
        data_ptr += 1
    mongo.append(quers)
f.close()

# Creating corresponding graph visualisations
# All times are in seconds
# The times are stored in sqlite3,maria,mariaidx,mongo

# For each database plotting the trend in time for 4 queries for 9 files
# for sqlite3  
sq1_1 = []
sq1_2 = []
sq2_1 = []
sq2_2 = []
sq3_1 = []
sq3_2 = []
sq4_1 = []
sq4_2 = []
for k in sqlite3:
    for i in range(4):
        if i == 0:
            sq1_1.append(k[i][0])
            sq1_2.append(k[i][1])
        elif i == 1:
            sq2_1.append(k[i][0])
            sq2_2.append(k[i][1])
        elif i == 2:
            sq3_1.append(k[i][0])
            sq3_2.append(k[i][1])
        elif i == 3:
            sq4_1.append(k[i][0])
            sq4_2.append(k[i][1])

xval = [i+1 for i in range(9)]
        
plt.title('Sqlite3')
plt.xlabel('Dataset Number')
plt.ylabel('Time in Seconds')
plt.plot(xval, sq1_1, label='Query 1', color='red')
plt.legend()
plt.savefig('Images/Part1/SqQuery1')
plt.clf()

plt.title('Sqlite3')
plt.xlabel('Dataset Number')
plt.ylabel('Time in Seconds')
plt.plot(xval, sq2_1, label='Query 2', color='red')
plt.legend()
plt.savefig('Images/Part1/SqQuery2')
plt.clf()

plt.title('Sqlite3')
plt.xlabel('Dataset Number')
plt.ylabel('Time in Seconds')
plt.plot(xval, sq3_1, label='Query 3', color='red')
plt.legend()
plt.savefig('Images/Part1/SqQuery3')
plt.clf()

plt.title('Sqlite3')
plt.xlabel('Dataset Number')
plt.ylabel('Time in Seconds')
plt.plot(xval, sq4_1, label='Query 4', color='red')
plt.legend()
plt.savefig('Images/Part1/SqQuery4')
plt.clf()

plt.title('Sqlite3')
plt.xlabel('Dataset Number')
plt.ylabel('Time in Seconds')
plt.plot(xval, sq1_1, label='Query 1')
plt.plot(xval, sq2_1, label='Query 2')
plt.plot(xval, sq3_1, label='Query 3')
plt.plot(xval, sq4_1, label='Query 4')
plt.legend()
plt.savefig('Images/Part1/SqAllQueries')
plt.clf()


# for MariaDb without index  
sq1_1 = []
sq1_2 = []
sq2_1 = []
sq2_2 = []
sq3_1 = []
sq3_2 = []
sq4_1 = []
sq4_2 = []
for k in maria:
    for i in range(4):
        if i == 0:
            sq1_1.append(k[i][0])
            sq1_2.append(k[i][1])
        elif i == 1:
            sq2_1.append(k[i][0])
            sq2_2.append(k[i][1])
        elif i == 2:
            sq3_1.append(k[i][0])
            sq3_2.append(k[i][1])
        elif i == 3:
            sq4_1.append(k[i][0])
            sq4_2.append(k[i][1])

xval = [i+1 for i in range(9)]
        
plt.title('MariaDB (Without Index)')
plt.xlabel('Dataset Number')
plt.ylabel('Time in Seconds')
plt.plot(xval, sq1_1, label='Query 1', color='red')
plt.legend()
plt.savefig('Images/Part1/MarQuery1')
plt.clf()

plt.title('MariaDB (Without Index)')
plt.xlabel('Dataset Number')
plt.ylabel('Time in Seconds')
plt.plot(xval, sq2_1, label='Query 2', color='red')
plt.legend()
plt.savefig('Images/Part1/MarQuery2')
plt.clf()

plt.title('MariaDB (Without Index)')
plt.xlabel('Dataset Number')
plt.ylabel('Time in Seconds')
plt.plot(xval, sq3_1, label='Query 3', color='red')
plt.legend()
plt.savefig('Images/Part1/MarQuery3')
plt.clf()

plt.title('MariaDB (Without Index)')
plt.xlabel('Dataset Number')
plt.ylabel('Time in Seconds')
plt.plot(xval, sq4_1, label='Query 4', color='red')
plt.legend()
plt.savefig('Images/Part1/MarQuery4')
plt.clf()

plt.title('MariaDB (Without Index)')
plt.xlabel('Dataset Number')
plt.ylabel('Time in Seconds')
plt.plot(xval, sq1_1, label='Query 1')
plt.plot(xval, sq2_1, label='Query 2')
plt.plot(xval, sq3_1, label='Query 3')
plt.plot(xval, sq4_1, label='Query 4')
plt.legend()
plt.savefig('Images/Part1/MarAllQueries')
plt.clf()

# for MariaDb with index  
sq1_1 = []
sq1_2 = []
sq2_1 = []
sq2_2 = []
sq3_1 = []
sq3_2 = []
sq4_1 = []
sq4_2 = []
for k in mariaidx:
    for i in range(4):
        if i == 0:
            sq1_1.append(k[i][0])
            sq1_2.append(k[i][1])
        elif i == 1:
            sq2_1.append(k[i][0])
            sq2_2.append(k[i][1])
        elif i == 2:
            sq3_1.append(k[i][0])
            sq3_2.append(k[i][1])
        elif i == 3:
            sq4_1.append(k[i][0])
            sq4_2.append(k[i][1])

xval = [i+1 for i in range(9)]
        
plt.title('MariaDB (With Index)')
plt.xlabel('Dataset Number')
plt.ylabel('Time in Seconds')
plt.plot(xval, sq1_1, label='Query 1', color='red')
plt.legend()
plt.savefig('Images/Part1/MarIdxQuery1')
plt.clf()

plt.title('MariaDB (With Index)')
plt.xlabel('Dataset Number')
plt.ylabel('Time in Seconds')
plt.plot(xval, sq2_1, label='Query 2', color='red')
plt.legend()
plt.savefig('Images/Part1/MarIdxQuery2')
plt.clf()

plt.title('MariaDB (With Index)')
plt.xlabel('Dataset Number')
plt.ylabel('Time in Seconds')
plt.plot(xval, sq3_1, label='Query 3', color='red')
plt.legend()
plt.savefig('Images/Part1/MarIdxQuery3')
plt.clf()

plt.title('MariaDB (With Index)')
plt.xlabel('Dataset Number')
plt.ylabel('Time in Seconds')
plt.plot(xval, sq4_1, label='Query 4', color='red')
plt.legend()
plt.savefig('Images/Part1/MarIdxQuery4')
plt.clf()

plt.title('MariaDB (With Index)')
plt.xlabel('Dataset Number')
plt.ylabel('Time in Seconds')
plt.plot(xval, sq1_1, label='Query 1')
plt.plot(xval, sq2_1, label='Query 2')
plt.plot(xval, sq3_1, label='Query 3')
plt.plot(xval, sq4_1, label='Query 4')
plt.legend()
plt.savefig('Images/Part1/MarIdxAllQueries')
plt.clf()

# for MongoDB  
sq1_1 = []
sq1_2 = []
sq2_1 = []
sq2_2 = []
sq3_1 = []
sq3_2 = []
sq4_1 = []
sq4_2 = []
for k in mongo:
    for i in range(4):
        if i == 0:
            sq1_1.append(k[i][0])
            sq1_2.append(k[i][1])
        elif i == 1:
            sq2_1.append(k[i][0])
            sq2_2.append(k[i][1])
        elif i == 2:
            sq3_1.append(k[i][0])
            sq3_2.append(k[i][1])
        elif i == 3:
            sq4_1.append(k[i][0])
            sq4_2.append(k[i][1])

xval = [i+1 for i in range(9)]
        
plt.title('Mongo')
plt.xlabel('Dataset Number')
plt.ylabel('Time in Seconds')
plt.plot(xval, sq1_1, label='Query 1', color='red')
plt.legend()
plt.savefig('Images/Part1/MongoQuery1')
plt.clf()

plt.title('Mongo')
plt.xlabel('Dataset Number')
plt.ylabel('Time in Seconds')
plt.plot(xval, sq2_1, label='Query 2', color='red')
plt.legend()
plt.savefig('Images/Part1/MongoQuery2')
plt.clf()

plt.title('Mongo')
plt.xlabel('Dataset Number')
plt.ylabel('Time in Seconds')
plt.plot(xval, sq3_1, label='Query 3', color='red')
plt.legend()
plt.savefig('Images/Part1/MongoQuery3')
plt.clf()

plt.title('Mongo')
plt.xlabel('Dataset Number')
plt.ylabel('Time in Seconds')
plt.plot(xval, sq4_1, label='Query 4', color='red')
plt.legend()
plt.savefig('Images/Part1/MongoQuery4')
plt.clf()

plt.title('Mongo')
plt.xlabel('Dataset Number')
plt.ylabel('Time in Seconds')
plt.plot(xval, sq1_1, label='Query 1')
plt.plot(xval, sq2_1, label='Query 2')
plt.plot(xval, sq3_1, label='Query 3')
plt.plot(xval, sq4_1, label='Query 4')
plt.legend()
plt.savefig('Images/Part1/MongoAllQueries')
plt.clf()


# Plotting execution times per database per csv file
xval = [i+1 for i in range(4)]
# For 1:
for k in range(9):
    sq1 = []
    sq2 = []
    sq3 = []
    sq4 = []
    for i in range(4):
        sq1.append(sqlite3[k][i][0])
        sq2.append(maria[k][i][0])
        sq3.append(mariaidx[k][i][0])
        sq4.append(mongo[k][i][0])
    plt.title(files[k])
    plt.xlabel("Query")
    plt.ylabel("Time in Seconds")
    plt.plot(xval, sq1, label='Sqlite3', marker='o')
    plt.plot(xval, sq2, label='MariaDB (Without Index)',marker='o')
    plt.plot(xval, sq3, label='MariaDB (With Index)',marker='o')
    plt.plot(xval, sq4, label='MongoDB',marker='o')
    for i in range(4):
        plt.annotate("Query "+ str(i+1), (xval[i],sq1[i]), color='blue')
    for i in range(4):
        plt.annotate("Query "+ str(i+1), (xval[i],sq2[i]), color='orange')
    for i in range(4):
        plt.annotate("Query "+ str(i+1), (xval[i],sq3[i]), color='green')
    for i in range(4):
        plt.annotate("Query "+ str(i+1), (xval[i],sq4[i]), color='red')
    plt.legend()
    # plt.show()
    plt.savefig('./Images/Part2/'+str(k+1))
    plt.clf()
