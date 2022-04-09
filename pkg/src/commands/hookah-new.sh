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

	term.hyperlink 'pre-commit' 'https://git-scm.com/docs/githooks#_pre_commit'
	local pre_commit="$REPLY"

	term.hyperlink 'pre-merge-commit' 'https://git-scm.com/docs/githooks#_pre_merge_commit'
	local pre_merge_commit="$REPLY"

	term.hyperlink 'pre-merge-commit' 'https://git-scm.com/docs/githooks#_prepare_commit_msg'
	local prepare_commit_msg="$REPLY"

	term.hyperlink 'commit-msg' 'https://git-scm.com/docs/githooks#_commit_msg'
	local commit_msg="$REPLY"

	term.hyperlink 'post-commit' 'https://git-scm.com/docs/githooks#_post_commit'
	local post_commit="$REPLY"

	term.hyperlink 'applypatch-msg' 'https://git-scm.com/docs/githooks#_applypatch_msg'
	local applypatch_msg="$REPLY"

	term.hyperlink 'pre-applypatch' 'https://git-scm.com/docs/githooks#_pre_applypatch'
	local pre_applypatch="$REPLY"

	term.hyperlink 'post-applypatch' 'https://git-scm.com/docs/githooks#_post_applypatch'
	local post_applypatch="$REPLY"

	term.hyperlink 'pre-rebase' 'https://git-scm.com/docs/githooks#_pre_rebase'
	local pre_rebase="$REPLY"

	term.hyperlink 'post-checkout' 'https://git-scm.com/docs/githooks#_post_checkout'
	local post_checkout="$REPLY"

	term.hyperlink 'post-merge' 'https://git-scm.com/docs/githooks#_post_merge'
	local post_merge="$REPLY"

	term.hyperlink 'pre-push' 'https://git-scm.com/docs/githooks#_pre_push'
	local pre_push="$REPLY"

	term.hyperlink 'pre-receive' 'https://git-scm.com/docs/githooks#_pre_receive'
	local pre_receive="$REPLY"

	term.hyperlink 'update' 'https://git-scm.com/docs/githooks#_update'
	local update="$REPLY"

	term.hyperlink 'proc-receive' 'https://git-scm.com/docs/githooks#_proc_receive'
	local proc_receive="$REPLY"

	term.hyperlink 'post-update' 'https://git-scm.com/docs/githooks#_post_update'
	local post_update="$REPLY"

	term.hyperlink 'reference-transaction' 'https://git-scm.com/docs/githooks#_reference_transaction'
	local reference_transaction="$REPLY"

	term.hyperlink 'push-to-checkout' 'https://git-scm.com/docs/githooks#_push_to_checkout'
	local push_to_checkout="$REPLY"

	term.hyperlink 'pre-auto-gc' 'https://git-scm.com/docs/githooks#_pre_auto_gc'
	local pre_auto_gc="$REPLY"

	term.hyperlink 'post-rewrite' 'https://git-scm.com/docs/githooks#_post_rewrite'
	local post_rewrite="$REPLY"

	term.hyperlink 'sendemail-validate' 'https://git-scm.com/docs/githooks#_sendemail_validate'
	local sendemail_validate="$REPLY"

	term.hyperlink 'fsmonitor-watchman' 'https://git-scm.com/docs/githooks#_fsmonitor_watchman'
	local fsmonitor_watchman="$REPLY"

	term.hyperlink 'p4-changelist' 'https://git-scm.com/docs/githooks#_p4_changelist'
	local p4_changelist="$REPLY"

	term.hyperlink 'p4-prepare-changelist' 'https://git-scm.com/docs/githooks#_p4_prepare_changelist'
	local p4_prepare_changelist="$REPLY"

	term.hyperlink 'p4-post-changelist' 'https://git-scm.com/docs/githooks#_p4_post_changelist'
	local p4_post_changelist="$REPLY"

	term.hyperlink 'p4-pre-submit' 'https://git-scm.com/docs/githooks#_p4_pre_submit'
	local p4_pre_submit="$REPLY"

	term.hyperlink 'post-index-change' 'https://git-scm.com/docs/githooks#_post_index_change'
	local post_index_change="$REPLY"

	local -r hook_info="COMMIT HOOKS
$pre_commit
  - Invoked by 'git commit'
  - Runs before obtaining commit message
  - Non-zero exit aborts action
  - Bypassible with '--no-verify'
$pre_merge_commit
  - Invoked by 'git merge'
  - Runs after the merge and before obtaining commit message
  - Non-zero exit aborts action
  - Bypassible with '--no-verify'
  - May run 'pre-commit' hook
$prepare_commit_msg
  - Invoked by 'git commit'
  - Runs after preparing the default log message and before the editor is started
  - Non-zero exit aborts action
  - Bypassible with '--no-verify'
  - Parameter of '\$1' is name of file holding the commit message
$commit_msg
  - Invoked by 'git commit' and 'git merge'
  - Bypassible with '--no-verify'
  - If exits non-zero, aborts commit process
  - Parameter of '\$1' is name of file holding the commit message
$post_commit
  - Invoked by 'git commit'
  - Runs after a commit is made

EMAIL HOOKS
  - Invoked by 'git am'
$applypatch_msg
  - Runs before patch is applied and before commit is made
  - May run 'commit-msg' hook
  - Non-zero exit aborts action
  - Parameter of '\$1' is name of file holding the commit message
$pre_applypatch
  - Runs after patch is applied and before commit is made
  - May run 'pre-commit' hooks
$post_applypatch
  - Runs after patch is applied and after commit is made

MISCELLANEOUS HOOKS
$pre_rebase
  - Invoked by 'git rebase'
  - Parameter of '\$1' is the upstream from which series was forked
  - Parameters of '\$2' is name of branch being rebased
$post_checkout
  - Invoked by 'git checkout' or 'git switch'
  - Runs after worktree is updated
  - Parameter of '\$1' is the ref of the previous HEAD
  - Parameter of '\$2' is the ref of the new HEAD
  - Parameter of '\$2' is a flag indicating a branch or file checkout
  - Exit code is reflected by invocation of the Git subcommand
$post_merge
  - Invoked by 'git merge'
  - Runs when a 'git pull' is done a local repository
  - Parameter of '\$1' is a flag specifying if merge was a sqauash merge
$pre_push
  - Invoked by 'git push'
$pre_receive
  - Invoked by 'git receive-pack'
$update
  - Invoked by 'git receive-pack'
$proc_receive
  - Invoked by 'git receive-pack'
$post_update
  - Invoked by 'git receive-pack'
$reference_transaction
  - Invoked by 'git receive-pack'
$push_to_checkout
  - Invoked by 'git receive-pack'
$pre_auto_gc
  - Invoked by 'git gc --auto'
$post_rewrite
  - Invoked by commands that rewrite commits
$sendemail_validate
  - Invoked by 'git send-email'
$fsmonitor_watchman
  - Two versions
$p4_changelist
  - Invoked by 'git-p4 submit'
$p4_prepare_changelist
  - Invoked by 'git-p4 submit'
$p4_post_changelist
  - Invoked by 'git-p4 submit'
$p4_pre_submit
  - Invoked by 'git-p4 submit'
$post_index_change
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
