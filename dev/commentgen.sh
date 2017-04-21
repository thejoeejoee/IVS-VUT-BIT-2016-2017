#!/bin/bash

authors_prefix='__author__ = '
copyright='__copyright__ = "Copyright 2017, /dej/uran/dom team"'
credits='__credits__ = ["Josef Kolář", "Son Hai Nguyen", "Martin Omacht", "Robert Navrátil"]'
license='__license__ = "GNU GPL Version 3"'

writefiles=false

if [ "$1" = "-w" ]; then
	writefiles=true
else
	echo "Test run, rerun with -w argument to write comments to files."
fi

files=`find .. -type f -name '*.py'`

echo "$files" | while read line; do
	authors=`git blame $line | sed -r 's/^[^\(]+ \(//g' | sed -r 's/ [0-9]{4}.*$//g' | sed -r 's/ +$//g' | sort | uniq`
	authors=`printf "$authors" | sed 's/EnkeyMC/Martin Omacht/g' | sed 's/Sony/Son Hai Nguyen/g' | sed 's/Meigurad/Robert Navrátil/g' | sort | uniq`
	authors=`printf "$authors" | tr '\n' ',' | sed 's/,/, /g'`

	linenum=`cat "$line" | nl -b a | grep -E ".*import.*$" | tail -n 1 | awk '{print $1}'`

	if [ -z "$linenum" ]; then
		linenum='1'
	fi
	
	content=`sed "$linenum a$license" "$line" | sed "$linenum a$credits" | sed "$linenum a$copyright" | sed "$linenum a$authors_prefix\"$authors\"" | sed "$linenum a\ "`
	if $writefiles; then
		printf "%s" "$content" > "$line"
	fi
	echo "In file '$line' inserted on line: $linenum"

done