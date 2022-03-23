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

	local -r hook_info="COMMIT HOOKS
pre-commit
  - Invoked by 'git commit'
  - Runs before obtaining commit message
  - Non-zero exit aborts action
  - Bypassible with '--no-verify'
pre-merge-commit
  - Invoked by 'git merge'
  - Runs after the merge and before obtaining commit message
  - Non-zero exit aborts action
  - Bypassible with '--no-verify'
  - May run 'pre-commit' hook
prepare-commit-msg
  - Invoked by 'git commit'
  - Runs after preparing the default log message and before the editor is started
  - Non-zero exit aborts action
  - Bypassible with '--no-verify'
  - Parameter of '\$1' is name of file holding the commit message
commit-msg
  - Invoked by 'git commit' and 'git merge'
  - Bypassible with '--no-verify'
  - If exits non-zero, aborts commit process
  - Parameter of '\$1' is name of file holding the commit message
post-commit
  - Invoked by 'git commit'
  - Runs after a commit is made

EMAIL HOOKS
  - Invoked by 'git am'
applypatch-msg
  - Runs before patch is applied and before commit is made
  - May run 'commit-msg' hook
  - Non-zero exit aborts action
  - Parameter of '\$1' is name of file holding the commit message
pre-applypatch
  - Runs after patch is applied and before commit is made
  - May run 'pre-commit' hooks
post-applypatch
  - Runs after patch is applied and after commit is made

MISCELLANEOUS HOOKS
pre-rebase
  - Invoked by 'git rebase'
  - Parameter of '\$1' is the upstream from which series was forked
  - Parameters of '\$2' is name of branch being rebased
post-checkout
  - Invoked by 'git checkout' or 'git switch'
  - Runs after worktree is updated
  - Parameter of '\$1' is the ref of the previous HEAD
  - Parameter of '\$2' is the ref of the new HEAD
  - Parameter of '\$2' is a flag indicating a branch or file checkout
  - Exit code is reflected by invocation of the Git subcommand
post-merge
  - Invoked by 'git merge'
  - Runs when a 'git pull' is done a local repository
  - Parameter of '\$1' is a flag specifying if merge was a sqauash merge
pre-push
  - Invoked by 'git push'
pre-receive
  - Invoked by 'git receive-pack'
update
  - Invoked by 'git receive-pack'
proc-receive
  - Invoked by 'git receive-pack'
post-update
  - Invoked by 'git receive-pack'
reference-transaction
  - Invoked by 'git receive-pack'
push-to-checkout
  - Invoked by 'git receive-pack'
pre-auto-gc
  - Invoked by 'git gc --auto'
post-rewrite
  - Invoked by commands that rewrite commits
sendemail-validate
  - Invoked by 'git send-email'
fsmonitor-watchman
  - Two versions
p4-changelist
  - Invoked by 'git-p4 submit'
p4-prepare-changelist
  - Invoked by 'git-p4 submit'
p4-post-changelist
  - Invoked by 'git-p4 submit'
p4-pre-submit
  - Invoked by 'git-p4 submit'
post-index-change
  - Invoked after index is written in 'read-cache.c'"

	local -a hook_list=()
	local line=
	while IFS= read -r line; do
		if [[ $line == *@( |HOOKS)* ]]; then
			continue
		fi

		hook_list+=("$line")
	done <<< "$hook_info"; unset -v line

	if [ -z "$hook_name" ]; then
		printf '%s\n' "$hook_info"
		printf '%s' 'Choose: '
		read -re hook_name
	fi

	if [ -z "$hook_name" ]; then
		print.die "Name of hook cannot be empty"
	fi

	local is_valid_hook='no' valid_hook_name=
	for valid_hook_name in "${hook_list[@]}"; do
		if [ "$valid_hook_name" = "$hook_name" ]; then
			is_valid_hook='yes'
		fi
	done
	if [ "$is_valid_hook" != 'yes' ]; then
		print.die "Did not enter valid commit hook"
	fi

	if [ -f "$hooks_dir/$hook_name" ]; then
		print.die "Hook already exists. Not overriding"
	fi

	if ! cat > "$hooks_dir/$hook_name" <<-"EOF"; then
	#!/usr/bin/env bash

	source "${0%/*}/.hookah/lib.sh"
	hookah.init

	EOF
		print.die "Failed to create new hook file"
	fi

	if ! chmod +x "$hooks_dir/$hook_name"; then
		print.die "Failed to chmod new hook file"
	fi
}
