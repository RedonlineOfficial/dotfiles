# ------------------------- #
# zsh Environment Variables #
# ------------------------- #

# --- System ---
export EDITOR="nvim"
export TERM="xterm-kitty"

# XDG Base Directory Specification (https://wiki.archlinux.org/title/XDG_Base_Directory)
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.local/cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# --- Custom ---
export DOTDIR="$HOME/dotfiles"

# --- zsh ---
# Move zsh dotfiles to config directory
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# --- ssh ---
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/.bitwarden-ssh-agent.sock"

# --- Bitwarden ---
export BITWARDEN_SSH_AUTH_SOCK="$XDG_RUNTIME_DIR"
