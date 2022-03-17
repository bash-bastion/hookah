# shellcheck shell=bash

global_trap_exit() {
	local exit_code=$?
	core.stacktrace_print
	exit $exit_code
}

main.hookah() {
	core.init
	core.trap_add 'global_trap_exit' ERR

	local arg=
	for arg; do case $arg in
	-h|--help)
		util.show_help
		exit 0
		;;
	esac done; unset -v arg

	local subcommand="$1"
	case $subcommand in
	refresh)
		if ! shift; then print.die 'Failed shift'; fi
		hookah-refresh "$@"
		;;
	new)
		if ! shift; then print.die 'Failed shift'; fi
		hookah-new "$@"
		;;
	check)
		if ! shift; then print.die 'Failed shift'; fi
		hookah-check "$@"
		;;
	*)
		if [ -n "$subcommand" ]; then
			print.die "Subcommand '$1' is not valid"
		else
			util.show_help
			print.die 'No subcommand passed'
		fi
		;;
	esac
}
