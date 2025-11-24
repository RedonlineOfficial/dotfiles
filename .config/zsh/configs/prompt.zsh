# ------------------------ #
# zsh Prompt Configuration #
# ------------------------ #

# --- Options ---
setopt prompt_subst # Expand variables

# --- Dependency loading ---
autoload -Uz vcs_info # Loads Git information

# --- Fixes ---
clear-screen() { echoti clear; NEW_LINE_BEFORE_PROMPT=0; precmd; zle redisplay; }
zle -N clear-screen

# --- Styling ---
zstyle ':vcs_info:*' enable git # Enables git

# - Git info format
zstyle ':vcs_info:git:*' formats ' %F{4}%b%f %m %u%c%a'

# - Git options
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr '%F{2}%f '
zstyle ':vcs_info:*' unstagedstr '%F{1}!%f'

# - Custom git functions
# Checks for and displays icon for untracked changes
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked
+git-untracked(){
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
        git status --porcelain | grep '??' &> /dev/null ; then
        # This will show the marker if there are any untracked files in repo.
        # If instead you want to show the marker only if there are untracked
        # files in $PWD, use:
        #[[ -n $(git ls-files --others --exclude-standard) ]] ; then
        hook_com[staged]+=' %F{3}%f'
    fi
}

# Compare local changes to remote changes
# git: Show +N/-N when your local branch is ahead-of or behind remote HEAD.
zstyle ':vcs_info:git*+set-message:*' hooks git-st
function +vi-git-st() {
    local ahead behind
    local -a gitstatus

    ahead=$(git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
    (( $ahead )) && gitstatus+=( "%F{3}+${ahead}%f" )

    behind=$(git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)
    (( $behind )) && gitstatus+=( "%F{3}-${behind}%f" )

    hook_com[misc]+=${(j:/:)gitstatus}
}


# --- Precommand Hooks ---
precmd() {
	vcs_info # Loads git info

	# Creates a new line after command is run or screen is cleared.  Works with ^L
	if [ -z "$NEW_LINE_BEFORE_PROMPT" ] || [ "$NEW_LINE_BEFORE_PROMPT" -eq 0 ]; then
		NEW_LINE_BEFORE_PROMPT=1
	elif [ "$NEW_LINE_BEFORE_PROMPT" -eq 1 ]; then # Only echo new line if var=1
		echo 
	fi
	print -P "%F{8}(%f %F{blue}%~%f %F{8})%f ${vcs_info_msg_0_}"	# Prints current working directory above prompt
}

# --- Prompt ---
PROMPT='%F{6}%n@%m%f %F{5}>%f '



