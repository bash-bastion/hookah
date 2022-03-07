# shellcheck shell=bash

cd_to_closest_git_repo() {
	while [ ! -d '.git' ] && [ "$PWD" != / ]; do
		if ! cd ..; then
			return 1
		fi
	done

	if [ "$PWD" = / ]; then
		return 1
	fi
}

read_line_n() {
	unset REPLY; REPLY=
	local file="$1"
	local -i line_number="$2"

	local -i i=1
	local line=
	while IFS= read -r line; do
		if ((i == line_number)); then
			REPLY=$line
			break
		fi

		((++i))
	done < "$file"; unset -v line
}

print.die() {
	printf '%s\n' "Error: $1. Exiting"
	exit 1
}

print.error() {
	printf '%s\n' "Error: $1. Exiting"
}

print.warn() {
	printf '%s\n' "Warn: $1"
}

print.info() {
	printf '%s\n' "Info: $1"
}

print.hint() {
	printf '%s\n' "--> $1"
}
