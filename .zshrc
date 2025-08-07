# =============================================================================
# ZSH CONFIGURATION
# =============================================================================

# --- ZSH Reload & Edit Aliases ---
alias szsh="source ~/.zshrc"
alias ezsh="nvim ~/.zshrc"
alias ezp="nvim ~/.zprofile"

# --- History Configuration ---
HISTFILE=$HOME/.config/zshistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# --- ZSH Plugins ---
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# --- Docker Completion Setup ---
fpath=(/Users/francoaseglio/.docker/completions $fpath)
autoload -Uz compinit
compinit

# =============================================================================
# ENVIRONMENT VARIABLES & PATH
# =============================================================================

# --- Java Environment ---
export JAVA_HOME="/opt/homebrew/opt/openjdk@21"
export PATH="$JAVA_HOME/bin:$PATH"

# --- pipx ---
export PATH="$PATH:/Users/francoaseglio/.local/bin"

# --- ghcup Environment ---
[ -f "/Users/francoaseglio/.ghcup/env" ] && . "/Users/francoaseglio/.ghcup/env"

# --- Bat Theme ---
export BAT_THEME=tokyonight

# --- fzf Theme ---
export FZF_DEFAULT_OPTS="
--color=fg:#CBE0F0
--color=bg:#011628
--color=hl:#7AA2F7
--color=fg+:#CBE0F0
--color=bg+:#143652
--color=hl+:#7AA2F7
--color=info:#B4D0E9
--color=prompt:#CBE0F0
--color=pointer:#7AA2F7
--color=marker:#7AA2F7
--color=spinner:#B4D0E9
--color=header:#627E97
--color=border:#547998
--color=gutter:#011628"

# =============================================================================
# TOOL INITIALIZATIONS
# =============================================================================

# --- Zoxide (better cd) ---
eval "$(zoxide init zsh)"

# --- Starship Prompt ---
eval "$(starship init zsh)"

# =============================================================================
# FUNCTIONS
# =============================================================================

# --- Docker Desktop Toggle ---
function docker_toggle() {
 if /usr/local/bin/docker info &> /dev/null; then
   echo "Quitting Docker..."
   /usr/local/bin/docker stop $(/usr/local/bin/docker ps -q) 2>/dev/null
   pkill -f "Docker"
 else
   echo "Starting Docker..."
   open -a Docker
 fi
}

# --- FZF Directory Navigation ---
function fzf_dir() {
  local dir
  dir=$(find ~/ -type d 2>/dev/null | fzf)
  [[ -n "$dir" ]] && cd "$dir" || echo "No directory selected"
}

# --- FZF File to Neovim ---
function fzf_to_nvim() {
  local files
  files=$(fzf -m --preview="bat --theme=mocha --style=numbers --color=always --line-range=:500 {}")
  [[ -z "$files" ]] && echo "No files selected" && return
  if [ -f pyproject.toml ]; then
    poetry run /opt/homebrew/bin/nvim -p $files
  else
    /opt/homebrew/bin/nvim -p $files
  fi
}

# --- Poetry-Dependent Neovim Launcher ---
function nvim_poetry() {
  if [ -f pyproject.toml ]; then
    poetry run /opt/homebrew/bin/nvim "$@"
  else
    /opt/homebrew/bin/nvim "$@"
  fi
}

# --- FZF Project Navigation to Neovim ---
function fzf_project_nvim() {
  local project
  project=$(find ~ -maxdepth 3 -type d -name ".git" | sed 's/\/.git$//' | fzf)
  [[ -n "$project" ]] && cd "$project"
  nvim .
}

# =============================================================================
# ALIASES
# =============================================================================

# --- Directory Navigation ---
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# --- Quick Directory Access ---
alias gd="cd ~/Desktop"
alias gl="cd ~/Downloads"
alias gt="cd ~/.Trash"
alias gc="cd ~/.config"

# --- Enhanced ls with Eza ---
alias ls="eza --color=always --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias la="eza -a --color=always --git --icons=always"
alias ll="eza --color=always --git --icons=always --long --grid --accessed --modified --created"
alias lla="eza -a --color=always --git --icons=always --long --grid --accessed --modified --created"
alias ls2="eza --tree --level=2"
alias la2="eza -a --tree --level=2"
alias ls3="eza --tree --level=3"
alias la3="eza -a --tree --level=3"

# --- FZF Enhanced Navigation ---
alias fd='fzf_dir'
alias fn='fzf_to_nvim'
alias fp='fzf_project_nvim'

# --- Tool Aliases ---
alias nvim='nvim_poetry'
alias dk='docker_toggle'
alias y='[ -z "$YAZI_LEVEL" ] && yazi || exit'
alias db="cd ~/db && ls"
alias pg="pgcli"

# --- Dotfiles Management (Commented) ---
# alias dotme="git clone git@github.com:FrancoAseglio/dotfiles.git && cd ~/dotfiles"
# alias undot="rm -rf ~/dotfiles"
