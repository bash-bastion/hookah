# shellcheck shell=bash

task.docs() {
	shdoc < './pkg/share/lib.sh' > './docs/api.md'
}

task.test() {
	bats "$@" ./tests
}
