#!/bin/bash

if [ -z $1 ]; then
	echo "Usage: $0 [FILENAME]"
	exit
fi

if [ -f $1 ]; then
	filename=$(basename "$1")
	extension="${filename##*.}"
	filename="${filename%.*}"

	if [ $extension = "asm" ]; then
		nasm -g -f elf32 -o "$filename.o" -O3 $1
	elif [ $extension = "s" ]; then
		# todo gas
		as --32 --gstabs+  -march=i386 -mtune=i386 -o "$filename.o" --reduce-memory-overheads $1
	fi
s.
	
	ld -s -m elf_i386 -o $filename "$filename.o"
	
else
	echo "File $1 does not exist!"
	exit
fi


