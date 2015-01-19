#!/usr/bin/env bash

# test if VirtualBox vm is running, if not start it.

set -o errexit
set -o pipefail
set -o nounset
set -o xtrace

# print usage statistics on bad invocation.
usage() {
	echo "${0} [-s vm_name | -l]"
}

# check if vm of name (first argument) is running.
vm_running() {
	# check args
	if test "${#}" -eq 1; then
		# test if running
		if test -n "$(VBoxManage list runningvms | grep -e "^\"${1}\"")"; then
			echo 1 # true
		else
			echo 0 # false
		fi
	else
		echo "incorrect invocation of routine 'vm_running'."
		exit 1
	fi
}

vm_exists() {
	# check args
	if test "${#}" -eq 1; then
		# test if running
		if test -n "$(VBoxManage list vms | grep -e "^\"${1}\"")"; then
			echo 1 # true
		else
			echo 0 # false
		fi
	else
		echo "incorrect invocation of routine 'vm_exists'."
		exit 1
	fi
}

# if vm of name (first argument) is not running, start it.
start_vm() {
	if test "${#}" -eq 1; then
		if $(test $(vm_running "${1}") -eq 0) && $(test $(vm_exists "${1}") -eq 1); then
			VBoxManage startvm "${1}" --type headless
		elif test $(vm_running "${1}") -eq 1; then
			echo "vm is already running"
		else
			echo "vm does not exist"
		fi
	else
		echo "incorrect invocation of routine 'start_vm'."
		exit 1
	fi
}

# check arguments for correct action
if $(test "${1}" == "-s") && $(test "${#}" -eq 2); then
	start_vm "${2}"
elif $(test "${1}" == "-l") && $(test "${#}" -eq 1); then
	VBoxManage list vms
fi
