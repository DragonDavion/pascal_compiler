SRCS:=$(sort $(wildcard src/*.c) src/lex.yy.c src/parse.tab.c)
OBJS:=$(patsubst src/%.c,tmp/%.o,$(SRCS))
DEPS:=$(patsubst src/%.c,tmp/%.d,$(SRCS))

target: bin/main.exe

test: test/test.exe

run: test/test.exe
	@echo Running target program...
	@test/test.exe

clean:
	@echo Cleaning...
	@rm -f -r tmp
	@rm -f -r bin
	@rm -f src/lex.yy.c
	@rm -f src/parse.tab.*
	@rm -f src/.*.swp
	@rm -f test/test.s
	@rm -f test/test.exe

showconf:
	@echo SRCS : $(SRCS)
	@echo OBJS : $(OBJS)
	@echo DEPS : $(DEPS)

.PHONY: target test run clean showconf

bin/main.exe: src/parse.tab.c src/parse.tab.h src/lex.yy.c $(OBJS)
	@echo Generating $@...
	@mkdir bin -p
	@gcc -o bin/main.exe $(OBJS)

test/test.exe: test/test.pas bin/main.exe
	@echo Running compiler...
	@bin/main.exe < test/test.pas
	@#bin/main.exe test/test.pas test/test.s
	@#gcc -o test/test.exe test/test.s

src/parse.tab.c src/parse.tab.h: pre/parse.y
	@echo Generating $@...
	@bison -Wnone --defines=src/parse.tab.h -o src/parse.tab.c $<

src/lex.yy.c: pre/lex.l
	@echo Generating $@...
	@flex -o $@ $<

tmp/%.o: src/%.c
	@echo Generating $@...
	@mkdir tmp -p
	@gcc -I src -c -MMD -MF tmp/$*.d -MT tmp/$*.d -MT $@ -o $@ $<

-include $(DEPS)
