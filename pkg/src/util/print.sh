# shellcheck shell=bash

print.die() {
	printf '%s\n' "Error: $1. Exiting" >&2
	exit 1
}

print.error() {
	printf '%s\n' "Error: $1. Exiting" >&2
}

print.warn() {
	printf '%s\n' "Warn: $1"
}

print.info() {
	printf '%s\n' "Info: $1"
}

print.hint() {
	printf '%s\n' "  -> $1"
}
