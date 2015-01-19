#!/usr/bin/env bash

# test if VirtualBox vm is running, if not start it.

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

# print usage statistics on bad invocation.
usage() {
	echo "${0} vm_name"
}

# check if vm of name (first argument) is running.
check_vm() {
	# check args
	if test "${#}" -eq 1; then
		# test if running
		if test -n "$(VBoxManage list runningvms | grep -e "^\"${1}\"")"; then
			echo 1 # true
		else
			echo 0 # false
		fi
	else
		usage
		exit 1
	fi
}

# if vm of name (first argument) is not running, start it.
if test "${#}" -eq 1; then
	if test $(check_vm "${1}") -eq 0; then
		VBoxManage startvm "${1}" --type headless
	fi
else
	usage;
	exit 1
fi
