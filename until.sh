#!/bin/sh

UNTIL_VERSION_MAJOR=0
UNTIL_VERSION_MINOR=0
UNTIL_VERSION_PATCH=0
UNTIL_VERSION="${UNTIL_VERSION_MAJOR}.${UNTIL_VERSION_MINOR}.${UNTIL_VERSION_PATCH}"


# just in case /usr/bin/which is not available
which() {
	type "$1" > /dev/null 2>&1
}

for cmd in date; do
	which ${cmd}
	if [ "$?" -ne 0 ]; then
		echo "dependency command '${cmd}' missing, aborting."
		exit 0
	fi
done

show_help() {
	echo "usage: $0 <YYYY-MM-DD>"
	echo "  -h  show options"
	echo "  -v  show version"
}

show_version() {
	echo "version ${UNTIL_VERSION}"
}

if [ -z "$1" ]; then
	show_help
	exit 0
fi

while getopts "hv" optchar ; do
	case "${optchar}" in
		v)
			show_version
			exit 0
			;;
		*)
			show_help
			exit 0
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


d1=$(today)
d2=$1
echo "$(diff_days ${d1} ${d2}) days until ${d2}"
