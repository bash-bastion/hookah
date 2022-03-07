# shellcheck shell=bash

test_util.get_hookahlib_version() {
	unset -v REPLY; REPLY=

	local line=
	while IFS= read -r line; do
		if [[ $line == *local\ -r\ lib_version=\'* ]]; then
			REPLY=${line#*\'}
			REPLY=${REPLY%\'*}
			return
		fi
	done < "$BASALT_PACKAGE_DIR/pkg/src/commands/hookah-init.sh"; unset -v line

	printf '%s\n' "Error: test_util.get_hookahlib_version: Failed to get version string" >&2
	exit 1
}
