# shellcheck shell=bash

check() {
	printf '%s\n' "$1"
}

main.hookah() {
	local subcommand="$1"

	if [[ $* == *-h* ]]; then
		cat <<-"EOF"
		Subcommands:
		   setup
		      Setup the hooks directory if it doesn't exist and execute sanity checks against the hooks (is readable, executable, shebangs, etc.)
		   create
		      Menu to create one of the various Git hooks
		EOF
		exit
	fi

	if [ -z "$subcommand" ]; then
		print.die "No subcommand passed"
	fi

	# TODO
	hookah-"$subcommand"
}
