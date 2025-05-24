# --- Reload & Edit ZSH ---
alias szsh="source ~/.zshrc"
alias ezsh="nvim ~/.zshrc"

# --- History Setup ---
HISTFILE=$HOME/.config/zshistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# --- ZSH Plugins ---
plugins=(git zsh-syntax-highlighting)
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# --- Zoxide (better cd) ---
eval "$(zoxide init zsh)"

# --- Bat (better cat) ---
export BAT_THEME=tokyonight

# --- fzf ---
export FZF_DEFAULT_OPTS="
  --color=fg:${fg},bg:${bg},hl:${purple} \
  --color=fg+:${fg},bg+:${bg_highlight},hl+:${purple} \
  --color=info:${blue},prompt:${cyan},pointer:${cyan} \
  --color=marker:${cyan},spinner:${cyan},header:${cyan}
"

# --- Java Path ---
export JAVA_HOME="/opt/homebrew/opt/openjdk@21"
export PATH="$JAVA_HOME/bin:$PATH"

# --- Starship Prompt ---
eval "$(starship init zsh)"

# --- Aliases ---

# Parental dir navigation 
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Useful Dir Navigation
alias gd="cd ~/Desktop"
alias gl="cd ~/Downloads"
alias gt="cd ~/.Trash"
alias gc="cd ~/.config"

# Eza (Better ls)
alias ls="eza --color=always --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias la="eza -a --color=always --git --icons=always"
alias ll="eza --color=always --git --icons=always --long --grid --accessed --modified --created"
alias lla="eza -a --color=always --git --icons=always --long --grid --accessed --modified --created"
alias ls2="eza --tree --level=2"
alias la2="eza -a --tree --level=2"
alias ls3="eza --tree --level=3"
alias la3="eza -a --tree --level=3"
alias ls4="eza --tree --level=4"
alias la4="eza -a --tree --level=4"
alias ls5="eza --tree --level=5"
alias la5="eza -a --tree --level=5"

# fzf cd
function fd() {
  local dir
  dir=$(find ~/ -type d 2>/dev/null | fzf)
  [[ -n "$dir" ]] && cd "$dir"
}

# fzf file to nvim
alias fn='nvim -p $(fzf -m --preview="bat --style=numbers --color=always --line-range=:500 {}")'

# Various
alias orbq='osascript -e "quit app \"OrbStack\""'
alias y='[ -z "$YAZI_LEVEL" ] && yazi || exit'
alias db="cd ~/db && ls"
alias pg="pgcli"

# dotfiles
# alias dotme="git clone git@github.com:FrancoAseglio/dotfiles.git"
# alias undot="rm -rf ~/dotfiles"
