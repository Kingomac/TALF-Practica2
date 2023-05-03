moronico:	moronico.tab.c moronico.lex.c
	gcc -o moronico moronico.tab.c lex.yy.c -lm
moronico.tab.c:	moronico.y
	bison -dv moronico.y
moronico.lex.c:	moronico.l
	flex moronico.l
.PHONY: run
run:
	make moronico.lex.c moronico.tab.c moronico && ./moronico p2.mor
.PHONY: clean
clean:
	rm  moronico.tab.c moronico.tab.h moronico.output lex.yy.c moronico
.PHONY: mio
mio:
	flex moronico0.l && bison -dv moronico.y && gcc -o moronico lex.yy.c moronico.tab.c -lfl && ./moronico p2.mor