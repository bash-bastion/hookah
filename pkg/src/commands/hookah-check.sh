# shellcheck shell=bash

hookah-check() {
	local -r hooks_dir='./.hooks'

	if ! util.cd_to_closest_git_repo; then
		print.die "Failed to 'cd' to closest Git repository"
	fi

	local hookFile=
	for hookFile in "$hooks_dir"/*; do
		if [ ! -r "$hookFile" ]; then
			print.warn "File '$hookFile' is not readable"
			print.hint "You may need to \`chmod +r '$hookFile'\`"
			print.hint "You may need to \`chown $USER:$USER '$hookFile'\`"
			continue
		fi

		if [ ! -x "$hookFile" ]; then
			print.warn "File '$hookFile' is not set as executable"
			print.hint "You may need to \`chmod +x '$hookFile'\`"
		fi

		if [[ $line == *.* ]]; then
			print.warn "File should not have an excention"
			print.hint "For example, the hook 'pre-commit' should be at './hooks/pre-commit'"
		fi

		util.read_line_n "$hookFile" 1
		local line=$REPLY; local arguments="${line#* }"

		if [ -z "$line" ]; then
			print.warn "File '$hookFile' must have a shebang"
			print.hint "You may need to \`printf '%s\n' '#!/usr/bin/env bash'\`"
		elif [[ $line != \#!* ]]; then
			check "File '$hookFile' does not have a shebang"
			print.hint "You may need to \`printf '%s\n' '#!/usr/bin/env bash'\`"
		elif [[ $line != \#!/* ]]; then
			check "File '$hookFile' does not have a proper shebang"
			print.hint "Shebangs should be absolute paths"
			print.hint "You may need to \`printf '%s\n' '#!/usr/bin/env bash'\`"
		elif [[ $line != \#!/usr/bin/env* ]]; then
			print.warn "Shebang must point to /usr/bin/env"
			print.hint "Users of NixOS require this"
		elif [[ $arguments == *[\ -]* ]]; then
			print.warn "Must not pass any flags to /usr/bin/env"
			print.hint "Some options (like '-S') are not portable"
		elif ! command -v "$arguments" &>/dev/null; then
			print.warn "Executable '$arguments' specified in hook file '$hookFile' does not exist"
		fi
		# Do not place anything under here unless 'continue's are placed in the
		# previous if-elif branches
	done; unset -v hookFile
}
