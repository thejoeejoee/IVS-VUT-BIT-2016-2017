#!/bin/bash

authors_prefix='__author__ = '
copyright='__copyright__ = "Copyright 2017, /dej/uran/dom team"'
credits='__credits__ = ["Josef Kolář", "Son Hai Nguyen", "Martin Omacht", "Robert Navrátil"]'
license='__license__ = "GNU GPL Version 3"'

qmldoc="/**************************************************************************
**   Calculator
**   Copyright (C) 2017 /dej/uran/dom team
**   Authors: __author__
**   Credits: Josef Kolář, Son Hai Nguyen, Martin Omacht, Robert Navrátil
**
**   This program is free software: you can redistribute it and/or modify
**   it under the terms of the GNU General Public License as published by
**   the Free Software Foundation, either version 3 of the License, or
**   (at your option) any later version.
**
**   This program is distributed in the hope that it will be useful,
**   but WITHOUT ANY WARRANTY; without even the implied warranty of
**   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
**   GNU General Public License for more details.
**
**   You should have received a copy of the GNU General Public License
**   along with this program.  If not, see <http://www.gnu.org/licenses/>.
**************************************************************************/"

writefiles=false
qml=false

while getopts "wq" flag; do
	case $flag in
		w )
			writefiles=true
			;;
		q )
			qml=true
			;;
		* )
			exit 1
			;;
	esac
done

if ! $writefiles; then
	echo "Test run, rerun with -w argument to write comments to files."
fi

if $qml; then
	files=`find .. -type f -name '*.qml'`
else
	files=`find .. -type f -name '*.py'`
fi

echo "$files" | while read line; do
	authors=`git blame $line | sed -r 's/^[^\(]+ \(//g' | sed -r 's/ [0-9]{4}.*$//g' | sed -r 's/ +$//g' | sort | uniq`
	authors=`printf "$authors" | sed 's/EnkeyMC/Martin Omacht/g' | sed 's/Sony/Son Hai Nguyen/g' | sed 's/Meigurad/Robert Navrátil/g' | sort | uniq`
	authors=`printf "$authors" | tr '\n' ',' | sed 's/,/, /g'`

	if $qml; then
		qmldoc=`echo "$qmldoc" | sed "s/__author__/$authors/g"`
	fi

	linenum=`cat "$line" | nl -b a | grep -E ".* import .*$" | tail -n 1 | awk '{print $1}'`

	if [ -z "$linenum" ]; then
		linenum='1'
	fi

	if $qml; then
		content="`echo "$qmldoc"`
`cat "$line"`"
	else
		content=`sed "$linenum a$license" "$line" | sed "$linenum a$credits" | sed "$linenum a$copyright" | sed "$linenum a$authors_prefix\"$authors\"" | sed "$linenum a\ "`
	fi
	if $writefiles; then
		printf "%s\n" "$content" > "$line"
	fi
	echo "In file '$line' inserted on line: $linenum"

done