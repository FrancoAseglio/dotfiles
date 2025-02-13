# ========================================
# ZSH Configuration
# ========================================

# --- Reload & Edit ZSH ---
alias reload-zsh="source ~/.zshrc"
alias edit-zsh="nvim ~/.zshrc"

# --- History Setup ---
HISTFILE=$HOME/.config/zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# ========================================
# Plugins & Enhancements
# ========================================
plugins=(git zsh-syntax-highlighting)

# --- ZSH Plugins ---
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# --- TheFuck (fix typos) ---
alias fk='fuck'
eval $(thefuck --alias)

# --- Zoxide (better cd) ---
eval "$(zoxide init zsh)"

# ========================================
# Environment Variables
# ========================================
# --- Bat (better cat) ---
export BAT_THEME=tokyonight_night

# --- Java (path setup) ---
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

# ========================================
# Aliases & Functions
# ========================================

## --- General Aliases ---
alias t="tty-clock -c -t -s"                      # Show time
alias xxx="cmatrix -B -C yellow"                  # Matrix effect
alias orbq='osascript -e "quit app \"OrbStack\""' # Quit Orbstack
alias y='[ -z "$YAZI_LEVEL" ] && yazi || exit'    # Yazi file manager
alias lg="lazygit"                                # Lazygit

## --- Eza (Better ls) ---
alias ls="eza --color=always --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias ll="eza --header --git --long --grid --accessed --modified --created"
alias ls2="eza --tree --level=2"
alias ls3="eza --tree --level=3"
alias ls4="eza --tree --level=4"
alias ls5="eza --tree --level=5"

## --- fzf Navigation ---
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

# ========================================
# fzf Configuration
# ========================================

## --- fzf theme ---
fg="#CBE0F0"
bg="#011628"
bg_highlight="#143652"
purple="#B388FF"
blue="#06BCE4"
cyan="#2CF9ED"

export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"

## --- fzf git ---
source ~/fzf-git.sh/fzf-git.sh
eval $(fzf --zsh)

# ========================================
# Java Utilities
# ========================================

# --- Java Compile ---
jc() {
    javac "$1"
}

# --- Java Run (supports CL input) ---
jr() {
    local classfile=$(basename "$1" .java)
    shift
    java "$classfile" "$@"
}

# --- Java Compile & Run ---
jcr() {
    jc "$1" && jr "$1" "${@:2}"
}

# ========================================
# Enhancements
# ========================================

# --- Starship Prompt ---
eval "$(starship init zsh)"

