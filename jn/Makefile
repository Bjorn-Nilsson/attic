CC = gcc
CFLAGS = -O2

jn: jn.c
	$(CC) $(CFLAGS) $< -o $@
	strip -s $@

clean:
	rm -f jn
