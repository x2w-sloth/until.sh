#!/bin/sh


# MIT License
# 
# Copyright (c) 2023 x2w.sloth@gmail.com
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


UNTIL_VERSION_MAJOR=0
UNTIL_VERSION_MINOR=0
UNTIL_VERSION_PATCH=0
UNTIL_VERSION="${UNTIL_VERSION_MAJOR}.${UNTIL_VERSION_MINOR}.${UNTIL_VERSION_PATCH}"


# just in case /usr/bin/which is not available
which() {
	type "$1" > /dev/null 2>&1
}

for cmd in date grep; do
	which ${cmd}
	if [ "$?" -ne 0 ]; then
		echo "dependency command '${cmd}' missing, aborting."
		exit 1
	fi
done

show_brief() {
	echo "usage: $0 <YYYY-MM-DD> <options>"
	echo "list options with: $0 -h"
}

show_help() {
	echo "usage: $0 <YYYY-MM-DD> <options>"
	echo "options:"
	echo "  -h  show options"
	echo "  -v  show version"
	echo "  -f  supply the date to count from"
	echo "  -d  print number of days only"
}

show_version() {
	echo "version ${UNTIL_VERSION}"
}

if [ -z "$1" ]; then
	show_brief
	exit 1
fi

# first argument is always target date
# or a simple option such as -h or -v
echo "$1" | grep -P "[0-9]{4}-[0-9]{2}-[0-9]{2}" > /dev/null 2>&1
if [ "$?" -eq 0 ]; then
	until_date=$1
	shift
fi

while getopts "hvdf:" optchar ; do
	case "${optchar}" in
		h)
			show_help
			exit 0
			;;
		v)
			show_version
			exit 0
			;;
		d)
			only_days_opt=1
			;;
		f)
			from_date=${OPTARG}
			from_date_opt=1
			;;
		*)
			show_brief
			exit 1
			;;
	esac
done


# use POSIX time locale for the remainder of this script and
# adapt the wonderful ISO-8601 date format of YYYY-MM-DD
LC_TIME="POSIX"


today() {
	echo $(date +"%Y-%m-%d")
}

diff_seconds() {
	d1=$(date -d "$1" +%s)
	d2=$(date -d "$2" +%s)
	echo "$(( (${d2}-${d1}) ))"
}

diff_hours() {
	delta=$(diff_seconds "$1" "$2")
	echo "$(( ${delta}/3600 ))"
}

diff_days() {
	delta=$(diff_seconds "$1" "$2")
	echo "$(( ${delta}/86400 ))"
}


if [ -z "${from_date}" ]; then
	from_date=$(today)
fi

if [ -n "${only_days_opt}" ]; then
	echo $(diff_days ${from_date} ${until_date})
elif [ -n "${from_date_opt}" ]; then
	echo "$(diff_days ${from_date} ${until_date}) days from ${from_date} until ${until_date}"
else
	echo "$(diff_days ${from_date} ${until_date}) days until ${until_date}"
fi

