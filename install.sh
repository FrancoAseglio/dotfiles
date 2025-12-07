#!/bin/bash
set -euo pipefail

# ========== Output Colors ==========
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# ========== Output Functions ==========
print_message() { echo -e "${BLUE}==>${NC} $1"; }
print_success() { echo -e "${GREEN}==>${NC} $1"; }
print_error() { echo -e "${RED}==>${NC} $1"; }

# ========== Resolve Script Path ==========
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ========== Config Targets ==========
configs=("nvim" "wezterm" "bat" "yazi" "lazygit" "pgcli")
files=("starship.toml")
base_packages=("neovim" "bat" "starship" "yazi" "git" "glow")

# ========== Backup Configs ==========
backup_configs() {
    print_message "Creating backup of existing configurations..."
    timestamp=$(date +%Y%m%d_%H%M%S)
    backup_dir="$HOME/.config/backup_$timestamp"
    mkdir -p "$backup_dir"
    [[ -f "$HOME/.zshrc" ]] && cp "$HOME/.zshrc" "$backup_dir/" && print_success "Backed up .zshrc"
    for config in "${configs[@]}"; do
        [[ -d "$HOME/.config/$config" ]] && mv "$HOME/.config/$config" "$backup_dir/"
    done
    for file in "${files[@]}"; do
        [[ -f "$HOME/.config/$file" ]] && mv "$HOME/.config/$file" "$backup_dir/"
    done
    print_success "Backups stored in $backup_dir"
}

# ========== Create Symlinks ==========
create_symlinks() {
    print_message "Creating symbolic links..."
    mkdir -p "$HOME/.config"
    if [[ -f "$SCRIPT_DIR/.zshrc" ]]; then
        ln -sf "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"
        print_success "Linked .zshrc"
    else
        print_error "Missing .zshrc in $SCRIPT_DIR"
        exit 1
    fi
    for config in "${configs[@]}"; do
        src="$SCRIPT_DIR/.config/$config"
        dst="$HOME/.config/$config"
        [[ -d "$src" ]] && ln -sfn "$src" "$dst" && print_success "Linked $config"
    done
    for file in "${files[@]}"; do
        src="$SCRIPT_DIR/.config/$file"
        dst="$HOME/.config/$file"
        [[ -f "$src" ]] && ln -sfn "$src" "$dst" && print_success "Linked $file"
    done
}

# ========== Install zsh-autosuggestions ==========
install_zsh_autosuggestions() {
    print_message "Setting up zsh-autosuggestions..."
    
    # Ensure git is available
    if ! command -v git &>/dev/null; then
        print_error "Git is required but not installed. Please install git first."
        exit 1
    fi
    
    plugin_dir="$HOME/.zsh/zsh-autosuggestions"
    mkdir -p "$HOME/.zsh"
    if [[ ! -d "$plugin_dir" ]]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions.git "$plugin_dir"
        print_success "Installed zsh-autosuggestions"
    else
        print_success "zsh-autosuggestions already exists"
    fi
    if ! grep -q "zsh-autosuggestions.zsh" "$HOME/.zshrc" 2>/dev/null; then
        echo "source \$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> "$HOME/.zshrc"
        print_success "Added autosuggestions source to .zshrc"
    fi
}

# ========== Install Base Packages ==========
install_base_packages() {
    print_message "Installing base packages..."
    for pkg in "${base_packages[@]}"; do
        if ! command -v "$pkg" &>/dev/null; then
            print_message "Installing $pkg..."
            case "$PKG_MANAGER" in
                apt) sudo apt update && sudo apt install -y "$pkg" ;;
                dnf) sudo dnf install -y "$pkg" ;;
                pacman) sudo pacman -Sy --noconfirm "$pkg" ;;
                brew) brew install "$pkg" ;;
            esac
            print_success "$pkg installed"
        else
            print_success "$pkg is already installed"
        fi
    done
}

# ========== Install WezTerm ==========
install_wezterm() {
    if ! command -v wezterm &>/dev/null; then
        print_message "Installing WezTerm..."
        case "$PKG_MANAGER" in
            apt) 
                curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
                echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
                sudo apt update && sudo apt install -y wezterm ;;
            dnf) sudo dnf copr enable wezfurlong/wezterm-nightly && sudo dnf install -y wezterm ;;
            pacman) sudo pacman -Sy --noconfirm wezterm ;;
            brew) brew install --cask wezterm ;;
        esac
        print_success "WezTerm installed"
    else
        print_success "WezTerm already installed"
    fi
}

# ========== Install PostgreSQL ==========
install_postgresql() {
    if ! command -v psql &>/dev/null; then
        print_message "Installing PostgreSQL..."
        case "$PKG_MANAGER" in
            apt) sudo apt install -y postgresql postgresql-contrib ;;
            dnf) sudo dnf install -y postgresql-server postgresql-contrib && \
                 sudo postgresql-setup --initdb && \
                 sudo systemctl enable --now postgresql ;;
            pacman) sudo pacman -Sy --noconfirm postgresql && \
                    sudo -u postgres initdb -D /var/lib/postgres/data && \
                    sudo systemctl enable --now postgresql ;;
            brew) brew install postgresql@15 && brew services start postgresql@15 ;;
        esac
        print_success "PostgreSQL installed"
    else
        print_success "PostgreSQL already installed"
    fi
}

# ========== Install pgcli ==========
install_pgcli() {
    if ! command -v pgcli &>/dev/null; then
        print_message "Installing pgcli..."
        # pgcli is usually available via pip, but some package managers have it
        if command -v pip3 &>/dev/null; then
            pip3 install --user pgcli
        else
            case "$PKG_MANAGER" in
                apt) sudo apt install -y pgcli ;;
                dnf) sudo dnf install -y pgcli ;;
                pacman) sudo pacman -Sy --noconfirm pgcli ;;
                brew) brew install pgcli ;;
            esac
        fi
        print_success "pgcli installed"
    else
        print_success "pgcli already installed"
    fi
}

# ========== Install LazyGit ==========
install_lazygit() {
    if ! command -v lazygit &>/dev/null; then
        print_message "Installing lazygit..."
        case "$PKG_MANAGER" in
            apt)
                LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
                curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
                tar xf lazygit.tar.gz lazygit
                sudo install lazygit /usr/local/bin
                rm lazygit lazygit.tar.gz ;;
            dnf)
                sudo dnf copr enable atim/lazygit -y && sudo dnf install -y lazygit ;;
            pacman)
                sudo pacman -Sy --noconfirm lazygit ;;
            brew)
                brew install lazygit ;;
        esac
        print_success "lazygit installed"
    else
        print_success "lazygit already installed"
    fi
}

# ========== Detect OS and Install All Packages ==========
detect_and_install_packages() {
    print_message "Detecting OS and installing packages..."
    OS="$(uname -s)"
    case "$OS" in
        Darwin) PKG_MANAGER="brew" ;;
        Linux) 
            if command -v apt &>/dev/null; then
                PKG_MANAGER="apt"
            elif command -v dnf &>/dev/null; then
                PKG_MANAGER="dnf"
            elif command -v pacman &>/dev/null; then
                PKG_MANAGER="pacman"
            else
                print_error "No supported package manager found"
                exit 1
            fi
            ;;
        *) print_error "Unsupported OS: $OS" && exit 1 ;;
    esac
    
    # Install packages in order
    install_base_packages
    install_wezterm
    install_postgresql
    install_pgcli
    install_lazygit
}

# ========== Main ==========
main() {
    print_message "Starting setup..."
    if [[ ! -d "$SCRIPT_DIR/.config" ]]; then
        print_error "Run this script from the root of your dotfiles repository"
        exit 1
    fi
    backup_configs
    detect_and_install_packages
    create_symlinks
    install_zsh_autosuggestions
    print_message "Note: AeroSpace is not installed automatically."
    print_message "You can install it manually from https://github.com/nikitabobko/AeroSpace"
    print_success "All done!"
    print_message "Restart your terminal to apply changes."
}
main
