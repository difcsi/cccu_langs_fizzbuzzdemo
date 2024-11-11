.PHONY: all clean run_c run_cpp run_rust run_python run_js run_ts run_asm run_scala run_kotlin

all: run_c run_cpp run_rust run_python run_js run_ts run_asm run_scala run_kotlin

run_c: fizzbuzz.c
	gcc fizzbuzz.c -o fizzbuzz_c
	./fizzbuzz_c

run_cpp: fizzbuzz.cpp
	g++ fizzbuzz.cpp -o fizzbuzz_cpp
	./fizzbuzz_cpp

run_rust: fizzbuzz.rs
	rustc fizzbuzz.rs -o fizzbuzz_rust
	./fizzbuzz_rust

run_python: fizzbuzz.py
	python3 fizzbuzz.py

run_js: fizzbuzz.js
	node fizzbuzz.js

run_ts: fizzbuzz.ts
	tsc fizzbuzz.ts
	node fizzbuzz.js

run_asm: fizzbuzz.s
	nasm -f elf32 fizzbuzz.s -o fizzbuzz.o
	ld -m elf_i386 fizzbuzz.o -o fizzbuzz_asm
	./fizzbuzz_asm

run_scala: fizzbuzz.scala
	scalac fizzbuzz.scala
	scala FizzBuzz

run_kotlin: fizzbuzz.kts
	kotlinc -script fizzbuzz.kts

clean:
	rm -f fizzbuzz_c fizzbuzz_cpp fizzbuzz_rust fizzbuzz_asm fizzbuzz.o fizzbuzz.jar  *.class