# shellcheck shell=bash

hookah-new() {
	local hook_name_user="$1"

	local -r hooks_dir='./.hooks'
	local -r hookah_dir="$hooks_dir/.hookah"

	if ! util.cd_to_closest_git_repo; then
		util.print_die "Failed to 'cd' to closest Git repository"
	fi

	if [ ! -d "$hookah_dir" ]; then
		util.print_die "Hookah directory does not exist. Did you forget to run 'hookah init'?"
	fi

	###########################################################33
	local data=(
		START 'pre-commit'
		'https://git-scm.com/docs/githooks#_pre_commit'
		'|COMMIT'
		"- Invoked by 'git commit'
- Runs before obtaining commit message
- Non-zero exit aborts action
- Bypassible with '--no-verify'"

		START 'pre-merge-commit'
		'https://git-scm.com/docs/githooks#_pre_merge_commit'
		'|COMMIT'
		"- Invoked by 'git merge'
- Runs after the merge and before obtaining commit message
- Non-zero exit aborts action
- Bypassible with '--no-verify'
- May run 'pre-commit' hook"

		START 'pre-merge-commit'
		'https://git-scm.com/docs/githooks#_prepare_commit_msg'
		'|COMMIT'
		"- Invoked by 'git commit'
- Runs after preparing the default log message and before the editor is started
- Non-zero exit aborts action
- Bypassible with '--no-verify'
- Parameter of '\$1' is name of file holding the commit message"

		START 'commit-msg'
		'https://git-scm.com/docs/githooks#_commit_msg'
		'|COMMIT'
		"- Invoked by 'git commit' and 'git merge'
- Bypassible with '--no-verify'
- If exits non-zero, aborts commit process
- Parameter of '\$1' is name of file holding the commit message"

		START 'post-commit'
		'https://git-scm.com/docs/githooks#_post_commit'
		'|COMMIT'
		"- Invoked by 'git commit'
- Runs after a commit is made"


		START 'applypatch-msg'
		'https://git-scm.com/docs/githooks#_applypatch_msg'
		'|EMAIL'
		"- Runs before patch is applied and before commit is made
- May run 'commit-msg' hook
- Non-zero exit aborts action
- Parameter of '\$1' is name of file holding the commit message"

		START 'pre-applypatch'
		'https://git-scm.com/docs/githooks#_pre_applypatch'
		'|EMAIL'
		"- Runs after patch is applied and before commit is made
- May run 'pre-commit' hooks"

		START 'post-applypatch'
		'https://git-scm.com/docs/githooks#_post_applypatch'
		'|EMAIL'
		"- Runs after patch is applied and after commit is made"


		START 'pre-rebase'
		'https://git-scm.com/docs/githooks#_pre_rebase'
		'|MISC'
		"- Invoked by 'git rebase'
- Parameter of '\$1' is the upstream from which series was forked
- Parameters of '\$2' is name of branch being rebased"

		START 'post-checkout'
		'https://git-scm.com/docs/githooks#_post_checkout'
		'|MISC'
		"- Invoked by 'git checkout' or 'git switch'
- Runs after worktree is updated
- Parameter of '\$1' is the ref of the previous HEAD
- Parameter of '\$2' is the ref of the new HEAD
- Parameter of '\$2' is a flag indicating a branch or file checkout
- Exit code is reflected by invocation of the Git subcommand"

		START 'post-merge'
		'https://git-scm.com/docs/githooks#_post_merge'
		'|MISC'
		"- Invoked by 'git merge'
- Runs when a 'git pull' is done a local repository
- Parameter of '\$1' is a flag specifying if merge was a sqauash merge"

		START 'pre-push'
		'https://git-scm.com/docs/githooks#_pre_push'
		'|MISC'
		"- Invoked by 'git push'"

		START 'pre-receive'
		'https://git-scm.com/docs/githooks#_pre_receive'
		'|MISC'
		"- Invoked by 'git receive-pack'"

		START 'update'
		'https://git-scm.com/docs/githooks#_update'
		'|MISC'
		"- Invoked by 'git receive-pack'"

		START 'proc-receive'
		'https://git-scm.com/docs/githooks#_proc_receive'
		'|MISC'
		"- Invoked by 'git receive-pack'"

		START 'post-update'
		'https://git-scm.com/docs/githooks#_post_update'
		'|MISC'
		"- Invoked by 'git receive-pack'"

		START 'reference-transaction'
		'https://git-scm.com/docs/githooks#_reference_transaction'
		'|MISC'
		"- Invoked by 'git receive-pack'"

		START 'push-to-checkout'
		'https://git-scm.com/docs/githooks#_push_to_checkout'
		'|MISC'
		"- Invoked by 'git receive-pack'"

		START 'pre-auto-gc'
		'https://git-scm.com/docs/githooks#_pre_auto_gc'
		'|MISC'
		"- Invoked by 'git gc --auto'"

		START 'post-rewrite'
		'https://git-scm.com/docs/githooks#_post_rewrite'
		'|MISC'
		"- Invoked by commands that rewrite commits"

		START 'sendemail-validate'
		'https://git-scm.com/docs/githooks#_sendemail_validate'
		'|MISC'
		"- Invoked by 'git send-email'"

		START 'fsmonitor-watchman'
		'https://git-scm.com/docs/githooks#_fsmonitor_watchman'
		'|MISC'
		"- Two versions"

		START 'p4-changelist'
		'https://git-scm.com/docs/githooks#_p4_changelist'
		'|MISC'
		"- Invoked by 'git-p4 submit'"

		START 'p4-prepare-changelist'
		'https://git-scm.com/docs/githooks#_p4_prepare_changelist'
		'|MISC'
		"- Invoked by 'git-p4 submit'"

		START 'p4-post-changelist'
		'https://git-scm.com/docs/githooks#_p4_post_changelist'
		'|MISC'
		"- Invoked by 'git-p4 submit'"

		START 'p4-pre-submit'
		'https://git-scm.com/docs/githooks#_p4_pre_submit'
		'|MISC'
		"- Invoked by 'git-p4 submit'"

		START 'post-index-change'
		'https://git-scm.com/docs/githooks#_post_index_change'
		'|MISC'
		"- Invoked after index is written in 'read-cache.c'"
	)

	local -i i
	for ((i = 0; i < ${#data[@]}; i = i + 5)); do
		local word="${data[i]}"
		local hook_name="${data[i+1]}"
		local hook_url="${data[i+2]}"
		local hook_tags="${data[i+3]}"
		local hook_info="${data[i+4]}"

		term.hyperlink "$hook_name" "$hook_url"
		local hook_name_with_link="$REPLY"

		if [ "$hook_tags" != '|COMMIT' ]; then
			continue
		fi

		printf '%i: %s\n' $((i / 5 + 1)) "$hook_name_with_link"
	done; unset -v i

	if [ -z "$hook_name_user" ]; then
		printf '%s' 'Choose: '
		read -re hook_name_user
	fi

	if [ -z "$hook_name_user" ]; then
		util.print_die "Name of hook cannot be empty"
	fi

	local is_valid_hook='no'
	local -i hook_index='-1'
	local i
	for ((i = 0; i < ${#data[@]}; i = i + 5)); do
		local hook_name="${data[i+1]}"

		if [ "$hook_name" = "$hook_name_user" ]; then
			is_valid_hook='yes'
			hook_index=i
		fi
	done; unset -v i

	if [ "$is_valid_hook" = 'no' ]; then
		util.print_die "Did not enter valid commit hook"
	fi

	if [ -f "$hooks_dir/$hook_name_user" ]; then
		util.print_die "Hook already exists. Not overriding"
	fi

	if ! cat > "$hooks_dir/$hook_name_user" <<-"EOF"; then
	#!/usr/bin/env bash

	source "${0%/*}/.hookah/lib.sh"
	hookah.init

	EOF
		util.print_die "Failed to create new hook file"
	fi

	if ! chmod +x "$hooks_dir/$hook_name_user"; then
		util.print_die "Failed to chmod new hook file"
	fi
}
