#!/bin/bash

if [ -z $1 ]; then
	echo "Usage: $0 [FILENAME]"
	exit
fi

if [ -f $1 ]; then
	filename=$(basename "$1")
	extension="${filename##*.}"
	filename="${filename%.*}"

	nasm -f elf32 $1
	ld -s -m elf_i386 -o $filename "$filename.o"
	
else
	echo "File $1 does not exist!"
	exit
fi


