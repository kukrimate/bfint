NASM	= nasm
LD		= ld

bfint: src/lib.o src/bfint.o
	$(LD) -o $@ $^

%.o: %.asm
	$(NASM) -g -F dwarf -I src -f elf64 -o $@ $^

clean:
	rm -f *.o bfint
