CC=gcc
LIB=capstone
CFLAGS=-Wall -g -o

all:
	$(CC) sdb.c $(CFLAGS) sdb -l$(LIB)

test:
	./sdb ./loop1

dump: 
	objdump -D ./guess -M intel > ./guess.s
	objdump -D ./hello -M intel > ./hello.s
	objdump -D ./hello64 -M intel > ./hello64.s
	objdump -D ./loop1 -M intel > ./loop1.s
	objdump -D ./deep -M intel > ./deep.s

zip:
	zip 0816138_hw2.zip sdb.c Makefile 

clean:
	rm ./sdb
