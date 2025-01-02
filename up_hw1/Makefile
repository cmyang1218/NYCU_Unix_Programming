CC=gcc
CFLAGS=-shared -fPIC -Wall
TARGET=sandbox.so
SOURCE=sandbox.c

all: $(TARGET)

$(TARGET): $(SOURCE)
	$(CC) -o $(TARGET) $(CFLAGS) $^ -ldl

test:
	./test.sh
	
clean:
	rm  *.log
	rm  index.html.*
	rm  $(TARGET)
