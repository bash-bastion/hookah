# shellcheck shell=bash

main.hookah() {
	local subcommand="$1"

	local arg=
	for arg; do case $arg in
	-h|--help)
		util.show_help
		exit 0
		;;
	esac done; unset -v arg

	case $subcommand in
	init)
		if ! shift; then print.die 'Failed shift'; fi
		hookah-init "$@"
		;;
	create)
		if ! shift; then print.die 'Failed shift'; fi
		hookah-create "$@"
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
