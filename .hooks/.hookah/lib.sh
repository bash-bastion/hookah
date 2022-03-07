# shellcheck shell=bash
# Version: 0.1.2

# @file lib.sh
# @description Function library for Git hooks configured with Hookah

# @description initiates the environment, sets up stacktrace printing on 'ERR' trap,
# and sets the directory to the root of the Git repository
# @noargs
hookah.init() {
	if [ -z "$BASH_VERSION" ]; then
		printf '%s\n' "Hookah: Error: This script is only compatible with Bash. Exiting" >&2
		exit 1
	fi

	set -Eeo pipefail
	shopt -s dotglob extglob globasciiranges globstar lastpipe shift_verbose
	export LANG='C' LC_CTYPE='C' LC_NUMERIC='C' LC_TIME='C' LC_COLLATE='C' LC_MONETARY='C' LC_MESSAGES='C' \
		LC_PAPER='C' LC_NAME='C' LC_ADDRESS='C' LC_TELEPHONE='C' LC_MEASUREMENT='C' LC_IDENTIFICATION='C' LC_ALL='C'
	trap '__hookah_trap_err' 'ERR'

	while [ ! -d '.git' ] && [ "$PWD" != / ]; do
		if ! cd ..; then
			printf '%s\n' "Hookah: Error: Failed to 'cd' to nearest Git repository. Exiting" >&2
			return 1
		fi
	done
	if [ "$PWD" = / ]; then
		printf '%s\n' "Hookah: Error: Failed to 'cd' to nearest Git repository. Exiting" >&2
		return 1
	fi

	# TODO print large
	printf '%s\n' "Hookah: Running ${BASH_SOURCE[1]##*/}"
}

# @description Prints a command before running it
hookah.run() {
	printf '%s\n' "Hookah: Running command: '\$*'"
	"\$@"
}

# @description Prints a command before running it. If the command fails, print a message,
# but do not abort execution
hookah.run_allow_fail() {
	if ! hookah.run \$@; then
		printf '%s\n' "Hookah: Command failed"
	fi
}

# @description Test whether color should be outputed
# @exitcode 0 if should print color
# @exitcode 1 if should not print color
# @internal
__hookah_is_color() {
	if [[ -v NO_COLOR || $TERM == dumb ]]; then
		return 1
	else
		return 0
	fi
}

# @internal
__hookah_internal_error() {
	printf '%s\n' "Internal Error: $1" >&2
}

# @internal
__hookah_trap_err() {
	local error_code=$?

	# TODO
	__hookah_internal_error "Your hook did not exit successfully"
	__hookah_print_stacktrace

	exit $error_code
} >&2

# TODO: fix (broken)
# @internal
__hookah_print_stacktrace() {
	if __hookah_is_color; then
		printf '\033[4m%s\033[0m\n' 'Stacktrace:'
	else
		printf '%s\n' 'Stacktrace:'
	fi

	local i=
	for ((i=0; i<${#FUNCNAME[@]}-1; i++)); do
		local __bash_source=${BASH_SOURCE[$i]}; __bash_source="${__bash_source##*/}"
		printf '%s\n' "  in ${FUNCNAME[$i]} ($__bash_source:${BASH_LINENO[$i-1]})"
	done; unset -v i __bash_source
} >&2
