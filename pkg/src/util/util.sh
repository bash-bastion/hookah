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
	print.exec "$*"

	if "$@"; then :; else
		return $?
	fi
}

util.show_help() {
	cat <<"EOF"
Usage:
  hookah [--help] <subcommand> [args...]

Subcommands:
  refresh
    Initializes the hooks directory or updates it if it already exists

  new
    Opens a menu for creating a new Git hook. Once chosen, a corresponding
    minimal hook template will be created in the hooks directory

  check
    Run sanity checks in the hooks directory. It ensures the scripts are
    readable, executable, has the proper shabangs, and other things
EOF
}
