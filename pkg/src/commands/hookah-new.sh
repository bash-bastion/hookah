# shellcheck shell=bash

hookah-new() {
	local hook_name="$1"

	local -r hooks_dir='./.hooks'
	local -r hookah_dir="$hooks_dir/.hookah"

	if ! util.cd_to_closest_git_repo; then
		print.die "Failed to 'cd' to closest Git repository"
	fi

	if [ ! -d "$hookah_dir" ]; then
		print.die "Hookah directory does not exist. Did you forget to run 'hookah init'?"
	fi

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

	if [ -z "$hook_name" ]; then
		printf '%s\n' "Hooks: "
		local hook=
		for hook in "${!hooks[@]}"; do
			printf '%s\n' "   $hook: ${hooks[$hook]}"
		done; unset -v hook

		printf '%s' 'Choose: '
		read -re hook_name
	fi

	if [ -z "$hook_name" ]; then
		print.die "Cannot be empty"
	fi

	local is_valid_hook='no' valid_hook_name=
	for valid_hook_name in "${!hooks[@]}"; do
		if [ "$valid_hook_name" = "$hook_name" ]; then
			is_valid_hook='yes'
		fi
	done
	if [ "$is_valid_hook" != 'yes' ]; then
		print.die "Did not enter valid commit hook"
	fi

	cat > "$hooks_dir/$hook_name" <<-"EOF"
	#!/usr/bin/env bash

	source "${0%/*}/.hookah/lib.sh"
	hookah.init

	EOF
	chmod +x "$hooks_dir/$hook_name"
}
