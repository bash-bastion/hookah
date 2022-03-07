# shellcheck shell=bash

util.cd_to_closest_git_repo() {
	while [ ! -d '.git' ] && [ "$PWD" != / ]; do
		if ! cd ..; then
			return 1
		fi
	done

	if [ "$PWD" = / ]; then
		return 1
	fi
}

util.read_line_n() {
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

util.run() {
	printf '%s\n' "Running: $*"
	if "$@"; then :; else
		return 1
	fi
}

util.show_help() {
	cat <<"EOF"
Usage:
   hookah [--help] <subcommand> [args...]
Subcommands:
   setup
      Setup the hooks directory if it doesn't exist and execute sanity checks against the hooks (is readable, executable, shebangs, etc.)
   check
      Checks to ensure that the hooks directory is setup correctly
   create
      Menu to create one of the various Git hooks
EOF
}
