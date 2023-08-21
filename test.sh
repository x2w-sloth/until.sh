#!/bin/sh

ls ./until.sh > /dev/null 2>&1
if [ "$?" -ne 0 ]; then
	echo "until.sh script not found"
	exit 0
fi

script="./until.sh"

# only check exit code, ignore output
check_code() {
	input=$1
	expect_code=$2
	${script} ${input} > /dev/null 2>& 1
	result_code=$?
	echo -n "check_code: ${script} ${input} => "
	if [ "${expect_code}" -ne "${result_code}" ]; then
		echo "expected ${expect_code}, got ${result_code}"
	else
		echo "ok"
	fi
}

# check both exit code and script stdout
check() {
	input=$1
	expect_code=$2
	expect_out=$3
	result_out=$(${script} ${input})
	result_code=$?
	echo -n "check: ${script} ${input} => "
	if [ "${expect_code}" -ne "${result_code}" ]; then
		echo "expected ${expect_code}, got ${result_code}"
		exit 1
	fi
	if [ "${expect_out}" != "${result_out}" ]; then
		echo "\n  expect ${expect_out}\n  result ${result_out}"
		exit 1
	fi
	echo "ok"
}


# exit code 0: show help && show version
check_code "-v" 0
check_code "-h" 0

# exit code 1: show usage brief
check_code "" 1

# days between two dates
check "2023-12-31 -f 2023-01-01 -d" 0 "364"
check "2023-12-31 -f 2023-01-01"    0 "364 days from 2023-01-01 until 2023-12-31"
check "2024-12-31 -f 2024-01-01 -d" 0 "365"
check "2024-12-31 -f 2024-01-01"    0 "365 days from 2024-01-01 until 2024-12-31"
