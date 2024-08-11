#!/bin/sh
### autogen.sh - tool to help build borg from a repository checkout
## Heavily inspired by Emacs autogen.sh

## Add Emacs copyright information because we copied parts of their autogen.sh

## SPDX-FileCopyrightText: Copyright (C) 2011-2024 Free Software Foundation, Inc.
## SPDX-FileCopyrightText: Copyright (C) Björn Bidar
## SPDX-License-Identifier: GPL-3.0-or-later

### Commentary:
# Actions which will should be executed after pulling the contents
# of this repository to install git-hooks etc.


### Code:

# Get location of Git's common configuration directory.  For older Git
# versions this is just '.git'.  Newer Git versions support worktrees.
if [ -r .git ] ; then
        git_common_dir=$(git rev-parse --no-flags --git-common-dir 2>/dev/null)
fi
if [ -z "$git_common_dir" ] ; then
    git_common_dir=.git
fi


hooks=$git_common_dir/hooks
tailored_hooks_dir=misc/git-hooks

# Install Git hooks.

tailored_hooks=
sample_hooks=

# shellcheck disable=SC2043
# the loop with one item is intentional to allow to add more hooks
for hook in pre-push; do
    cmp -- $tailored_hooks_dir/$hook "$hooks/$hook" >/dev/null 2>&1 ||
	tailored_hooks="$tailored_hooks $hook"
done

for hook in applypatch-msg pre-applypatch; do
    if [ -r $hooks/$hook.sample ] ; then
        src=$hooks/$hook.sample
        cmp -- "$src" "$hooks/$hook" >/dev/null 2>&1 ||
	        sample_hooks="$sample_hooks $hook"
    fi
done

if [ -n "$tailored_hooks$sample_hooks" ] ;then
	echo "Installing git hooks..."

	if [ ! -d "$hooks" ] ;then
	    printf "mkdir -p -- '%s'\\n" "$hooks"
	    mkdir -p -- "$hooks" || exit
	fi

	if [ -n "$tailored_hooks" ] ;then
	    for hook in $tailored_hooks; do
		    dst=$hooks/$hook
		    cp $cp_options -- $tailored_hooks_dir/$hook "$dst" || exit
		    chmod -- a-w "$dst" || exit
	    done
	fi

	if [ -n "$sample_hooks" ] ; then
	    for hook in $sample_hooks; do
	        if [ -r $hooks/$hook.sample ] ; then
                src=$hooks/$hook.sample
		        dst=$hooks/$hook
		        cp $cp_options -- "$src" "$dst" || exit
		        chmod -- a-w "$dst" || exit
            fi
	    done
	fi
fi
