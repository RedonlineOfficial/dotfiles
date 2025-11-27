# ----------- #
# zsh Aliases #
# ----------- #

# --- System ---
alias hg='history | grep'
alias please='sudo $(fc -ln -1)'

# --- zsh ---
alias zrc='nvim ~/.config/zsh/.zshrc'
alias src='source ~/.config/zsh/.zshrc'

# --- Package Management ---
# Pacman
alias pac='sudo pacman -S'	# Install package
alias pacu='sudo pacman -Syu'	# Update
alias pacr='sudo pacman -Rs' 	# Remove
alias pacs='pacman -Ss'		# Search
alias paci='pacman -Si'		# Info
alias pacq='pacman -Qm'		# List locally installed packages (AUR packages count as local)
alias pacle='pacman -Qqe'	# List explicitly installed
alias paclo='sudo pacman -Qdt'	# List orphans
alias pacro='pacman -Qdt && sudo pacman -Rns $(pacman -Qtdq)' # Remove orphans
alias pacc='sudo pacman -Scc'	# Clean cache
alias paclf='pacman -Ql'	# List files

# Yay
alias yi='yay -S'		# Install package
alias yu='yay -Syu'		# Update
alias yr='yay -Rs'		# Remove
alias ys='yay -Ss'		# Search
alias ysi='yay -Si'		# Info
alias yq='yay -Qm'		# List locally installed packages (AUR packages count as local)
alias ylo='yay -Qdt'		# List orphans
alias yro='yay -Qdt && sudo yay -Rns $(yay -Qtdq)' # Remove orphans
alias yc='yay -Scc'	# Clean cache

# --- Navigation ---
# - cd/zoxide
# Check if zoxide is installed and enables cd replacement commands
if command -v zoxide > /dev/null; then
	# Zoxide specific commands
	alias cd='z'
fi

# Generic cd commands
alias cd..='cd ..'
alias ..='cd ..'
alias 2.='cd ../..'
alias 3.='cd ../../..'
alias 4.='cd ../../../..'
alias 5.='cd ../../../../..'
alias back='cd -'

# - Dotfiles
alias dots='cd ~/dotfiles/.config'
# Stow dotfiles from anywhere using GNU Stow
sdots() {
    cwd=$PWD    # Remember current directory
    cd ~/dotfiles # cd into dotfiles
    stow . # Stow files
    cd $cwd # Go back to current directory
}

# --- File/Folder ---
# - LS/LSD
if command -v lsd > /dev/null; then # Check if lsd is installed and sets aliases for it
	# - Ls Deluxe specific commands
	alias l='lsd -A --group-directories-first --hyperlink auto --ignore-glob .git'
    alias ls='l'
	alias lt='l --tree'
	alias llt='ll --tree'
	
	# Checks if the directory is a git repo and adds the git block if it is
	function ll() {
		if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
			lsd -AX --group-directories-first --hyperlink auto --ignore-glob .git --header --blocks git,name,size,user,group,permission,date
		else
			lsd -AX --group-directories-first --hyperlink auto --header --blocks name,size,user,group,permission,date
		fi
	}
else # Otherwise use ls on the same aliases
	# Ls Specific
	alias l='ls -AX --group-directories-first --hyperlink auto --color=always'
	alias ll='l -lhs'
fi

# - File/Folder Manipulation
alias mkd='mkdir -pv'
function mcd() {
	mkdir -pv $1
	cd $1
}

alias rmd='rm -rf'
alias cp='cp -r'

# - Useful utilities
alias weather='curl wttr.in'
alias myip='curl ifconfig.me'

# Multi-extract
ex() {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *.deb)       ar x $1      ;;
      *.tar.xz)    tar xf $1    ;;
      *.tar.zst)   unzstd $1    ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}


# --- Other Programs ---
# - Neovim
alias v='nvim'
alias sv='sudo nvim'

# - Git
alias lg='lazygit'
alias g='git'
alias gs='git status'
alias gl='git log --pretty=format:"%C(yellow)%h\\ %ad%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --date=short'
alias gc='git commit'
alias gpush='git push'
alias gpull='git pull'
alias ga='git add'
alias gaa='git add -A'
gac() {
	git add $1
	git commit
}
alias gaac='git add -A && git commit'

# - Wallust
alias wal='wallust'
alias walt='wal theme'
alias waltl='walt list'

# - Hypr
alias hyprpaperReloadWallpaper='$HOME/bin/hypr/hyprpaper_reloadWallpaper.sh'
