# shellcheck shell=bash

hookah-refresh() {
	local -r hooks_dir='./.hooks'
	local -r hookah_dir="$hooks_dir/.hookah"
	util.read_line_n "$BASALT_PACKAGE_DIR/pkg/share/lib.sh" 2
	local -r lib_version="${REPLY#*: }"

	if ! util.cd_to_closest_git_repo; then
		print.die "Failed to 'cd' to closest Git repository"
	fi

	if ! util.run git config --local core.hooksPath "$hooks_dir"; then
		print.error "Failed to set configuration property"
		print.hint "Please file an issue at 'https://github.com/hyperupcall/hookah'"
		exit 1
	fi

	if ! util.run mkdir -p "$hookah_dir"; then
		print.error "Failed to 'mkdir'"
		print.hint "Both '$hookah_dir' and '${hookah_dir%/*}' should either be directories or non-existant"
		exit 1
	fi

	# Create library filebreak
	if [ -f "$hookah_dir/lib.sh" ]; then
		util.read_line_n "$hookah_dir/lib.sh" 2
		local old_version="${REPLY##* }"

		if [ "$old_version" != "$lib_version" ]; then
			print.info "Updating library file: $old_version -> $lib_version"
		fi
	else
		print.info "Creating library file"
	fi

	if ! util.run cp -f "$BASALT_PACKAGE_DIR/pkg/share/lib.sh" "$hookah_dir/lib.sh"; then
		print.die "Failed to write to '$hookah_dir/lib.sh'"
	fi
}
