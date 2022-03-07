# shellcheck shell=bash

hookah-create() {
	# TODO: not dry
	local -r hooks_dir='./.hooks'
	local -r hookah_dir="$hooks_dir/.hookah"
	local -r libfile="$hookah_dir/lib.sh"

	# post-update undocumented?
	# TODO: figure out where these hooks come from: https://github.com/rycus86/githooks#supported-hooks
	local -Ar hooks=(
		# Committing
		[pre-commit]='If exits non-zero, aborts commit (bypassable with --no-verify)'
		[prepare-commit-msg]='Enables editing the default commit message'
		[commit-msg]='If exits non-zero, aborts commit process'
		[post-commit]='After everything completes'

		# Email
		[applypatch-msg]=
		[pre-applypatch]='Runs AFTER applying a patch'
		[post-applypatch]=

		# Miscellaneous client
		[pre-rebase]=
		[post-rewrite]=
		[post-checkout]=
		[post-merge]=
		[pre-push]=
		[pre-auto-gc]=

		# Server-side hooks
		[pre-receive]=
		[update]=
		[post-receive]=
	)

	printf '%s\n' "Hooks: "
	local hook=
	for hook in "${!hooks[@]}"; do
		printf '%s\n' "   $hook: ${hooks[$hook]}"
	done; unset -v hook

	printf '%s' 'Choose: '
	read -re

	local user_hook="$REPLY"
	# TODO
	if [[ ${!hooks[*]} != *"$user_hook"* ]]; then
		print.die "Did not enter valid commit hook"
	fi

	if [ -z "$user_hook" ]; then
		print.die "Cannot be empty"
	fi

	# TODO: hardcoded lib.sh
	cat > "$hooks_dir/$user_hook.sh" <<-"EOF"
	# shellcheck shell=bash

	source "${0%/*}/.hookah/lib.sh"
	hookah.init

	EOF
}
