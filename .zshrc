# --- Reload & Edit ZSH ---
alias szsh="source ~/.zshrc"
alias ezsh="nvim ~/.zshrc"

# --- History Setup ---
HISTFILE=$HOME/.config/zhistory
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
export BAT_THEME=tokyonight_night

# --- General Aliases ---
alias xxx="cmatrix -B -C yellow"                  # Matrix effect
alias orbq='osascript -e "quit app \"OrbStack\""' # Quit Orbstack
alias y='[ -z "$YAZI_LEVEL" ] && yazi || exit'    # Yazi file manager
alias db="cd ~/db && pgcli"                       # Postgres

# --- Eza (Better ls) ---
alias ls="eza --color=always --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias ll="eza --header --git --long --grid --accessed --modified --created"
alias ls2="eza --tree --level=2"
alias ls3="eza --tree --level=3"
alias ls4="eza --tree --level=4"
alias ls5="eza --tree --level=5"

# --- Parental dir navigation ---
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ..../../.."

# --- fzf cd: fd ---
function fd() {
    local dir
    dir=$(find ~/ -type d 2>/dev/null | fzf)
    [[ -n "$dir" ]] && cd "$dir"
}

# --- fzf file preview = ff ---
alias ff='fzf --preview="bat --style=numbers --color=always --line-range=:500 {}"'

# --- fzf file open in nvim = fn ---
alias fn='nvim -p $(fzf -m --preview="bat --style=numbers --color=always --line-range=:500 {}")'

# --- fzf theme ---
fg="#CBE0F0"
bg="#011628"
bg_highlight="#143652"
purple="#B388FF"
blue="#06BCE4"
cyan="#2CF9ED"

export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"

# --- fzf git ---
source ~/fzf-git.sh/fzf-git.sh
eval $(fzf --zsh)

# --- Starship Prompt ---
eval "$(starship init zsh)"

# --- Java Path ---
export JAVA_HOME="/opt/homebrew/opt/openjdk@21"
export PATH="$JAVA_HOME/bin:$PATH"
