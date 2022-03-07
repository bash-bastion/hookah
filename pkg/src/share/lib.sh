# shellcheck shell=bash
# shellcheck shell=bash
# Version: 0.1.2
#

hookah.init() {
	printf '%s\n' "Hookah: Running ${BASH_SOURCE[1]##*/}"
	# TODO: if debug, print shell options
	# TODO: only set some if bash
	set -Eeo pipefail
	shopt -s dotglob extglob globasciiranges globstar lastpipe shift_verbose
	export LANG='C' LC_CTYPE='C' LC_NUMERIC='C' LC_TIME='C' LC_COLLATE='C' LC_MONETARY='C' LC_MESSAGES='C' \
		LC_PAPER='C' LC_NAME='C' LC_ADDRESS='C' LC_TELEPHONE='C' LC_MEASUREMENT='C' LC_IDENTIFICATION='C' LC_ALL='C'
	trap '__hookah_trap_err' 'ERR'
}

hookah.run() {
	printf '%s\n' "Hookah: Running command: '\$*'"
	"\$@"
}

hookah.run_allow_fail() {
	if ! hookah.run \$@; then :; fi
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


__hookah_internal_error() {
	printf '%s\n' "Internal Error: $1"
}

__hookah_trap_err() {
	local error_code=$?

	# TODO
	__hookah_internal_error "Your hook did not exit successfully"
	__hookah_print_stacktrace

	exit $error_code
} >&2

# TODO: fix (broken)
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
