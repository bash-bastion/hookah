# shellcheck shell=bash

test_util.get_hookahlib_version() {
	unset -v REPLY; REPLY=
	util.read_line_n "$BASALT_PACKAGE_DIR/pkg/share/lib.sh" 2
	REPLY="$REPLY"
}
