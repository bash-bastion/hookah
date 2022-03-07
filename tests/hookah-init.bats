#!/usr/bin/env bats

load './util/init.sh'

@test "Inits properly" {
	hookah init

	ls -al .
	assert [ -d './.hooks' ]
	assert [ -d './.hooks/.hookah' ]
	assert [ -f './.hooks/.hookah/lib.sh' ]
}

@test "Inits properly when ran twice" {
	hookah init

	run hookah init

	test_util.get_hookahlib_version
	local current_hookahlib_version="$REPLY"

	assert_success
	assert [ -d './.hooks' ]
	assert [ -d './.hooks/.hookah' ]
	assert [ -f './.hooks/.hookah/lib.sh' ]
	assert_line -p "0.1.2 -> $current_hookahlib_version"
}
