# ===========================================================================
#                            ZSH Configuration
# ===========================================================================
# Enable vi mode EARLY to avoid conflicts
bindkey -v
export KEYTIMEOUT=1
# ───────────────────────────────────────────────────────────────────────────
# History Configuration
HISTFILE=$HOME/.config/zshistory
SAVEHIST=1000
HISTSIZE=1000
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify
setopt hist_ignore_space
setopt auto_pushd
setopt pushd_ignore_dups
# ───────────────────────────────────────────────────────────────────────────
# Completions (load early)
fpath=(/Users/francoaseglio/.docker/completions $fpath)
autoload -Uz compinit
# ───────────────────────────────────────────────────────────────────────────
# Only regenerate compinit once per day for performance
if [[ -n ${ZDOTDIR}/.zcompdump(#qNmh+24) ]]; then
  compinit
else
  compinit -C
fi

# ===========================================================================
#                          Environment Variables
# ===========================================================================
export BAT_THEME="mocha"
export JAVA_HOME="/opt/homebrew/opt/openjdk@21"
export PATH="$JAVA_HOME/bin:$HOME/.local/bin:$PATH"
eval "$(/opt/homebrew/bin/brew shellenv)"
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6ac,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6ac,hl+:#f38ba8"

# ===========================================================================
#                       External Tool Initialization
# ===========================================================================
# Plugins
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# ───────────────────────────────────────────────────────────────────────────
# Tool inits (load after environment is set)
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

# ===========================================================================
#                         VI Mode Configuration
# ===========================================================================
function zle-keymap-select {
  case ${KEYMAP} in
    vicmd|block)      echo -ne '\e[2 q' ;;  # Steady block
    main|viins|''|beam) echo -ne '\e[5 q' ;;  # Blinking beam
  esac
  zle reset-prompt
}
zle -N zle-keymap-select

zle-line-init() {
  echo -ne "\e[5 q"  # Beam cursor on startup
  zle reset-prompt
}
zle -N zle-line-init

bindkey "^?" backward-delete-char

# ===========================================================================
#                    Navigation & Directory Shortcuts
# ===========================================================================
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
# ───────────────────────────────────────────────────────────────────────────
alias gc="cd ~/.config"
alias gd="cd ~/Desktop"
alias gl="cd ~/Downloads"
alias gt="cd ~/.Trash"
alias gu="cd ~/unito/25-26/"
alias db="cd ~/db && ls"

# ===========================================================================
#                             File Operations
# ===========================================================================
# Base eza options
_EZA_BASE="eza --color=always --git --icons=always"
# ───────────────────────────────────────────────────────────────────────────
# Listing
alias ls="$_EZA_BASE"
alias la="$_EZA_BASE -a"
alias ll="$_EZA_BASE --long --grid --accessed --modified --created"
alias lla="$_EZA_BASE -a --long --grid --accessed --modified --created"
alias ls2="eza --tree --level=2"
alias ls3="eza --tree --level=3"
alias la2="eza -a --tree --level=2"
alias la3="eza -a --tree --level=3"
# ───────────────────────────────────────────────────────────────────────────
# Config management
alias szsh="source ~/.zshrc"
alias ezsh="nvim ~/.zshrc"
alias ezp="nvim ~/.zprofile"
# ───────────────────────────────────────────────────────────────────────────
# Dotfiles management
alias dotme="git clone git@github.com:FrancoAseglio/dotfiles.git && cd dotfiles"
alias undot="rm -rf ~/dotfiles && cd ~"

# ===========================================================================
#                          Application Shortcuts
# ===========================================================================
alias pg="pgcli"
# alias mg='mongosh -u admin -p ciravegna --authenticationDatabase admin'
alias mg="mongosh --quiet"
alias y='[ -z "$YAZI_LEVEL" ] && yazi || exit'
alias lg="lazygit"

# ===========================================================================
#                            Custom Functions
# ===========================================================================
# vscode opener
function open_in_vscode(){
  local file="$1"

  if [[ -z "$file" ]]; then
    open -a vscode .
  else
    open -a vscode "$file"
  fi
}
alias code="open_in_vscode"

# ───────────────────────────────────────────────────────────────────────────
# Navigation with fzf
function fzf_dir() {
  local dir
  dir=$(find ~/ -type d 2>/dev/null | fzf)
  [[ -n "$dir" ]] && cd "$dir"
}
alias fd='fzf_dir'

# ───────────────────────────────────────────────────────────────────────────
# Nvim opener
function fzf_to_nvim() {
  local files
  files=$(fzf -m --preview="bat --theme=mocha --style=numbers --color=always --line-range=:500 {}")
  [[ -z "$files" ]] && return 1

  if [[ -f pyproject.toml ]]; then
    poetry run sh -c "/opt/homebrew/bin/nvim -p $files"
  else
    /opt/homebrew/bin/nvim -p $files
  fi
}
alias fn='fzf_to_nvim'
# ───────────────────────────────────────────────────────────────────────────
# Poetry-aware nvim launcher
function nvim_poetry() {
  if [[ -f pyproject.toml ]]; then
    poetry run /opt/homebrew/bin/nvim "$@"
  else
    /opt/homebrew/bin/nvim "$@"
  fi
}
alias nvim='nvim_poetry'

# ───────────────────────────────────────────────────────────────────────────
# Project management
function fzf_project_nvim() {
  local project
  project=$(find ~ -maxdepth 3 -type d -name ".git" 2>/dev/null | sed 's/\/.git$//' | fzf \
    --preview '
      echo "=== GIT STATUS ===";
      git -C {} status --short 2>/dev/null || echo "No git changes";
      echo "";
      echo "=== README ===";
      for readme in {}/README.{md,txt}; do
        if [[ -f "$readme" ]]; then
          if [[ "$readme" == *.md ]] && command -v glow &>/dev/null; then
            glow -s dark "$readme" 2>/dev/null;
          elif [[ "$readme" == *.md ]] && command -v mdcat &>/dev/null; then
            mdcat "$readme" 2>/dev/null;
          else
            bat --theme=mocha --style=plain --color=always --line-range=:15 "$readme" 2>/dev/null;
          fi;
          break;
        fi;
      done;
      echo "";
      echo "=== REPO STRUCTURE ===";
      eza --tree --level=3 --color=always --icons=always {} 2>/dev/null || ls -la {};
    ' \
    --preview-window=right:60%:wrap \
    --ansi)
  [[ -n "$project" ]] && cd "$project" && nvim .
}
alias fp='fzf_project_nvim'

# ───────────────────────────────────────────────────────────────────────────
# Docker utils
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
alias dk='docker_toggle'

# ───────────────────────────────────────────────────────────────────────────
# Python x Poetry DataAnalysis Setup
alias data="poetry add jupyter pandas numpy matplotlib seaborn regex geopandas folium\
            && poetry install && mkdir datasets notebooks && touch ./notebooks/nb.ipynb"

alias exportd="poetry run pip freeze > requirements.txt"
# ───────────────────────────────────────────────────────────────────────────
