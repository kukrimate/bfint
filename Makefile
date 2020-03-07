NASM := nasm
LD   := ld

bfint: string.o errno.o bfint.o
	$(LD) -o $@ $^

%.o: %.asm
	$(NASM) -f elf64 -o $@ $^

clean:
	rm -f *.o bfint
