# ----------------- #
# zsh Configuration #
# ----------------- #
autoload -Uz compinit; compinit

# --- Helper functions ---
# Source all .zsh files in $ZDOTDIR
setopt extendedglob # Enables extended globbing to support ** and ~
source_zsh_files() {
  local file
  for file in "$ZDOTDIR"/**/*.zsh~"$ZDOTDIR/.zshrc"(.); do # Recursively checks for any file with the extension .zsh and excludes .zshrc
    source "$file"
  done
}
source_zsh_files

# Zoxide init
eval "$(zoxide init zsh)"
