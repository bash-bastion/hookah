# shellcheck shell=bash
# Version: 0.1.1
#
hookah.init() {
	printf '%s\n' "Hookah: Running hookah.sh"
}

hookah.run() {
	printf '%s\n' "Hookah: Running command: '$*'"
	"$@"
}
