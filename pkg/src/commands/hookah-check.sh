# shellcheck shell=bash

hookah-check() {
	local -r hooks_dir='./.hooks'

	if ! util.cd_to_closest_git_repo; then
		util.print_die "Failed to 'cd' to closest Git repository"
	fi

	local hook_file=
	for hook_file in "$hooks_dir"/*; do
		if [ ! -r "$hook_file" ]; then
			std.fprint_warn 'hookah' "File '$hook_file' is not readable"
			util.print_hint "You may need to \"chmod +r '$hook_file'\""
			util.print_hint "You may need to \"chown $USER:$USER '$hook_file'\""
			continue
		fi

		if [ ! -x "$hook_file" ]; then
			std.fprint_warn 'hookah' "File '$hook_file' is not set as executable"
			util.print_hint "You may need to \"chmod +x '$hook_file'\""
		fi

		# TODO: Instead of disallow-list type fltering, create an allow-list of
		# valid script/hook names
		if [[ $line == *.* ]]; then
			std.fprint_warn 'hookah' "File should not have an excention"
			util.print_hint "For example, the hook 'pre-commit' should be at './hooks/pre-commit'"
		fi

		util.read_line_n "$hook_file" 1
		local line=$REPLY; local arguments="${line#* }"

		if [ -z "$line" ]; then
			std.fprint_warn 'hookah' "File '$hook_file' must have a shebang"
			util.print_hint "You may need to \"printf '%s\n' '#!/usr/bin/env bash'\""
		elif [[ $line != \#!* ]]; then
			check "File '$hook_file' does not have a shebang"
			util.print_hint "You may need to \"printf '%s\n' '#!/usr/bin/env bash'\""
		elif [[ $line != \#!/* ]]; then
			check "File '$hook_file' does not have a proper shebang"
			util.print_hint "Shebangs should be absolute paths"
			util.print_hint "You may need to \"printf '%s\n' '#!/usr/bin/env bash'\""
		elif [[ $line != \#!/usr/bin/env* ]]; then
			std.fprint_warn 'hookah' "Shebang must point to /usr/bin/env"
			util.print_hint "Users of NixOS require this"
		elif [[ $arguments == *[\ -]* ]]; then
			std.fprint_warn 'hookah' "Must not pass any flags to /usr/bin/env"
			util.print_hint "Some options (like '-S') are not portable"
		elif ! command -v "$arguments" &>/dev/null; then
			std.fprint_warn 'hookah' "Executable '$arguments' specified in hook file '$hook_file' does not exist"
		fi
		# Do not place anything under here unless 'continue's are placed in the
		# previous if-elif branches
	done; unset -v hook_file

	std.fprint_info 'hookah' 'Done.'
}
