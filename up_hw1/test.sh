#! /usr/bin/bash

echo; echo "*** Basic Case: ***";
echo; echo "*** Test case 1: ***";
./launcher ./sandbox.so config-example.txt cat /etc/passwd
echo; echo "*** Test case 2: ***";
./launcher ./sandbox.so config-example.txt cat /etc/hosts
echo; echo "*** Test case 3: ***";
./launcher ./sandbox.so config-example.txt cat /etc/ssl/certs/Amazon_Root_CA_1.pem
echo; echo "*** Test case 5: ***";
./launcher ./sandbox.so config-example.txt wget http://google.com -t 1
echo; echo "*** Test case 6: ***";
./launcher ./sandbox.so config-example.txt wget https://www.nycu.edu.tw -t 1
echo; echo "*** Test case 7: ***";
./launcher ./sandbox.so config-example.txt wget http://www.google.com -q -t 1
echo; echo "*** Test case 8: ***";
./launcher ./sandbox.so config-example.txt python3 -c 'import os;os.system("wget http://www.google.com -q -t 1")'
echo; echo "*** Hidden Case: ***";
echo; echo "*** Test case 1: ***";
./launcher ./sandbox.so config.txt cat /tmp/testfile ; ./launcher ./sandbox.so config.txt cat /etc/passwd ; ./launcher ./sandbox.so config.txt cat /etc/hosts
echo; echo "*** Test case 2: ***";
./launcher ./sandbox.so config.txt wget http://google.com/ -t 1 -o /dev/null ; ./launcher ./sandbox.so config.txt wget http://linux.cs.nctu.edu.tw ; ./launcher ./sandbox.so config.txt wget https://freebsd.cs.nctu.edu.tw
echo; echo "*** Test case 3: ***";
./launcher ./sandbox.so config.txt ./case3

