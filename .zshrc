alias reload-zsh="source ~/.zshrc"
alias edit-zsh="nvim ~/.zshrc"

# history setup
HISTFILE=$HOME/.config/zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# --- thefuck (typos) ---
alias fk='fuck'
plugins=(git zsh-syntax-highlighting)
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
eval $(thefuck --alias)

# ----- Bat (better cat) -----
export BAT_THEME=tokyonight_night

# ---- Eza (better ls) -----
alias ls="eza --color=always --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias ll="eza --header --git --long --grid --accessed --modified --created"
alias ls2="eza --tree --level=2"
alias ls3="eza --tree --level=3"
alias ls4="eza --tree --level=4"
alias ls5="eza --tree --level=5"

# ---- Zoxide (better cd) ----
eval "$(zoxide init zsh)"

# --- fzf cd: fd ---
function fd() {
    local dir
    dir=$(find ~/ -type d 2>/dev/null | fzf)
    
    if [[ -n "$dir" ]]; then
        cd "$dir"
    fi
}
# --- fzf file: preview only = ff ---
alias ff='fzf --preview="bat --style=numbers --color=always --line-range=:500 {}"'
# --- fzf file opening in nvim = fn ---
alias fn='nvim -p $(fzf -m --preview="bat --style=numbers --color=always --line-range=:500 {}")'

# --- fzf theme ---
fg="#CBE0F0"
bg="#011628"
bg_highlight="#143652"
purple="#B388FF"
blue="#06BCE4"
cyan="#2CF9ED"

export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"

#--- fzf git ---
source ~/fzf-git.sh/fzf-git.sh
eval $(fzf --zsh)

#---- ttyt time ----
alias t="tty-clock -c -t -s"

#---- cmatrix ----
alias xxx="cmatrix -B -C yellow"

#---- Starship ~.config/starship.toml  ----
eval "$(starship init zsh)"

#---- Yazi cd 
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
