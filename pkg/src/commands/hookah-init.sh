# shellcheck shell=bash

# TODO: script for this repo to ensure the verison numbers are the same as in './share/lib.sh'

hookah-init() {
	local -r hooks_dir='./.hooks'
	local -r hookah_dir="$hooks_dir/.hookah"
	local -r lib_version='0.1.0'

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
			print.hint "Updating library file: $old_version -> $lib_version"
		fi
	else
		print.info "Creating library file"
	fi

	if ! util.run cp -f "$BASALT_PACKAGE_DIR/pkg/share/lib.sh" "$hookah_dir/lib.sh"; then
		print.die "Failed to write to '$hookah_dir/lib.sh'"
	fi
}
