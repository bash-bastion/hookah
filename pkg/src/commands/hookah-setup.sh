# shellcheck shell=bash

hookah-setup() {
	local -r hooks_dir='./.hooks'
	local -r hookah_dir="$hooks_dir/.hookah"
	local -r libfile="$hookah_dir/lib.sh"
	local -r libfile_version='0.1.1'

	if ! cd_to_closest_git_repo; then
		print.die "Failed to 'cd' to closest Git repository"
	fi

	print.info "Settings Git config 'core.hooksPath' to '$hooks_dir'"
	if ! git config --local core.hooksPath "$hooks_dir"; then
		print.error "Failed to set configuration property"
		print.hint "Please file an issue at 'https://github.com/hyperupcall/hookah'"
		exit 1
	fi

	if ! mkdir -p "$hookah_dir"; then
		print.error "Failed to 'mkdir'"
		print.hint "Both '$hookah_dir' and '${hookah_dir%/*}' should either be directories or non-existant"
		exit 1
	fi

	# Create library file
	if [ -f "$libfile" ]; then
		read_line_n "$libfile" 2
		local old_version="${REPLY##* }"

		if [ "$old_version" != "$libfile_version" ]; then
			print.hint "Updating library file: $old_version -> $libfile_version"
		fi
	else
		print.info "Creating library file"
	fi

	if ! cat > "$libfile" <<EOF; then
# shellcheck shell=bash
# Version: $libfile_version
#
hookah.init() {
	printf '%s\n' "Hookah: Running ${BASH_SOURCE[1]##*/}"
}

hookah.run() {
	printf '%s\n' "Hookah: Running command: '\$*'"
	"\$@"
}
EOF
		print.die "Failed to write to '$libfile'"
	fi

	# Ensure all scripts are runnable
	local hookFile=
	for hookFile in "$hooks_dir"/*; do
		if [ -r "$hookFile" ]; then
			print.warn "File '$hookFile' is not readable"
			print.hint "You may need to \`chmod +r '$hookFile'\`"
			print.hint "You may need to \`chown $USER:$USER '$hookFile'\`"
			continue
		fi

		if [ ! -x "$hookFile" ]; then
			print.warn "File '$hookFile' is not set as executable"
			print.hint "You may need to \`chmod +x '$hookFile'\`"
			continue
		fi

		# TODO: SELinux

		read_line_n "$hookFile" 1
		local line=$REPLY
		local arguments="${line#* }"
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
		elif [[ $line != \#!/usr/bin/env ]]; then
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
