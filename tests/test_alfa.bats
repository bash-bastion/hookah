#!/usr/bin/env bats

load './util/init.sh'

@test "Outputs 'woofers!'" {
	run hookah

	[ "$status" -eq 0 ]
	[ "$output" = "woofers!" ]
}
