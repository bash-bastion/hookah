# shellcheck shell=bash

check() {
	printf '%s\n' "$1"
}

main.hookah() {
	local subcmd="$1"

	local hooksDir='./.hooks'

	case $subcmd in
	init)
		git config --local core.hooksPath "$hooksDir"

		mkdir -p "$hooksDir"
		;;
	check)
		if [ ! -d "$hooksDir" ]; then
			check "Hooks directory does not exist"
		fi

		local file=
		for file in "$hooksDir"/*; do
			if [ -r "$file" ]; then
				check "File '$file' is not redable (does it have the correct permissions?). It will be skipped"
			fi

			if [ ! -x "$file" ]; then
				check "File '$file' is not set as executable. It will be skipped"
			fi

			local -i i=0
			while IFS= read -r line; do
				if ((i == 0)); then
					if [[ $line != \#!/* ]]; then
						check "File '$file' does not have a proper shebang"
					fi

					local cmd="${line#\#!}"
					cmd=${cmd%%* }
					if [ -n "$cmd" ]; then
						if ! command -v "$cmd" &>/dev/null; then
							check "Shebang with command '$cmd' in '$file' does not actually exist"
						fi
					fi
				fi

				if ((i == 1)); then
					break
				fi

				((++i))
			done < "$file"; unset -v line
		done; unset -v file
		;;
	esac
}
