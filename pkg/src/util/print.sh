# shellcheck shell=bash

print.die() {
	print.error "$1. Exiting"
	exit 1
}

print.error() {
	if util.should_print_color; then
		printf "\033[1;31m\033[1mHookah \033[1m[error]:\033[0m %s\n" "$1"
	else
		printf "Hookah [error]: %s\n" "$1"
	fi
} >&2

print.warn() {
	if util.should_print_color; then
		printf "\033[1;33m\033[1mHookah \033[1m[warn]:\033[0m %s\n" "$1"
	else
		printf "Hookah [warn]: %s\n" "$1"
	fi
} >&2

print.info() {
	if util.should_print_color; then
		printf "\033[0;36m\033[1mHookah \033[1m[info]:\033[0m %s\n" "$1"
	else
		printf "Hookah [info]: %s\n" "$1"
	fi
}

print.exec() {
	if util.should_print_color; then
		printf "\033[1mHookah \033[1m[exec]:\033[0m %s\n" "$*"
	else
		printf "Hookah [exec]: %s\n" "$*"
	fi
}

print.hint() {
	printf '%s\n' "  -> $1"
}
