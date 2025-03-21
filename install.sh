#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print messages with colors
print_message() { echo -e "${BLUE}==>${NC} $1"; }
print_success() { echo -e "${GREEN}==>${NC} $1"; }
print_error() { echo -e "${RED}==>${NC} $1"; }

# Backup existing configs
backup_configs() {
    print_message "Creating backup of existing configurations..."
    timestamp=$(date +%Y%m%d_%H%M%S)
    backup_dir="$HOME/.config/backup_$timestamp"
    mkdir -p "$backup_dir"

    # Backup .zshrc if it exists
    if [ -f "$HOME/.zshrc" ]; then
        cp "$HOME/.zshrc" "$backup_dir/"
        print_success "Backed up .zshrc to $backup_dir"
    fi

    # Backup only if config exists
    for config in "${configs[@]}"; do
        if [ -d "$HOME/.config/$config" ]; then
            mv "$HOME/.config/$config" "$backup_dir/"
            print_success "Backed up $config to $backup_dir"
        fi
    done

    for file in "${files[@]}"; do
        if [ -f "$HOME/.config/$file" ]; then
            mv "$HOME/.config/$file" "$backup_dir/"
            print_success "Backed up $file to $backup_dir"
        fi
    done
}

# Create symbolic links
create_symlinks() {
    print_message "Creating symbolic links..."
    mkdir -p "$HOME/.config"

    # Link .zshrc from root directory
    if [ -f "$PWD/.zshrc" ]; then
        ln -sf "$PWD/.zshrc" "$HOME/.zshrc"
        print_success "Linked .zshrc configuration"
    else
        print_error ".zshrc not found in dotfiles directory"
        exit 1
    fi

    for config in "${configs[@]}"; do
        if [ -d "$PWD/.config/$config" ]; then
            ln -sfn "$PWD/.config/$config" "$HOME/.config/$config"
            print_success "Linked $config configuration"
        fi
    done

    for file in "${files[@]}"; do
        if [ -f "$PWD/.config/$file" ]; then
            ln -sfn "$PWD/.config/$file" "$HOME/.config/$file"
            print_success "Linked $file"
        fi
    done
}

# Install zsh-autosuggestions
install_zsh_autosuggestions() {
    print_message "Setting up zsh-autosuggestions..."
    
    # Create zsh plugins directory if it doesn't exist
    mkdir -p "$HOME/.zsh"
    
    # Check if zsh-autosuggestions is already installed
    if [ ! -d "$HOME/.zsh/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions.git "$HOME/.zsh/zsh-autosuggestions"
        print_success "Installed zsh-autosuggestions"
    else
        print_success "zsh-autosuggestions is already installed"
    fi
    
    # Check if source line exists in .zshrc
    if ! grep -q "zsh-autosuggestions.zsh" "$HOME/.zshrc"; then
        echo "source \$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> "$HOME/.zshrc"
        print_success "Added zsh-autosuggestions to .zshrc"
    else
        print_success "zsh-autosuggestions already in .zshrc"
    fi
}

# Install required packages based on OS
detect_and_install_packages() {
    print_message "Detecting operating system..."
    OS="$(uname -s)"

    case "$OS" in
        Linux*)  PKG_MANAGER="$(command -v apt || command -v dnf || command -v pacman)" ;;
        Darwin*) PKG_MANAGER="brew" ;;
        *) print_error "Unsupported OS: $OS"; exit 1 ;;
    esac

    if [ -z "$PKG_MANAGER" ]; then
        print_error "No suitable package manager found. Install packages manually."
        exit 1
    fi

    print_message "Installing required packages using $PKG_MANAGER..."
    for package in "${packages[@]}"; do
        if ! command -v "$package" &> /dev/null; then
            print_message "Installing $package..."
            if [[ "$PKG_MANAGER" == "apt" ]]; then
                sudo apt update && sudo apt install -y "$package"
            elif [[ "$PKG_MANAGER" == "dnf" ]]; then
                sudo dnf install -y "$package"
            elif [[ "$PKG_MANAGER" == "pacman" ]]; then
                sudo pacman -Sy --noconfirm "$package"
            elif [[ "$PKG_MANAGER" == "brew" ]]; then
                brew install "$package"
            fi
        else
            print_success "$package is already installed"
        fi
    done
    
    # Install PostgreSQL separately due to package name differences
    print_message "Installing PostgreSQL..."
    if ! command -v psql &> /dev/null; then
        if [[ "$PKG_MANAGER" == "apt" ]]; then
            sudo apt update && sudo apt install -y postgresql postgresql-contrib
        elif [[ "$PKG_MANAGER" == "dnf" ]]; then
            sudo dnf install -y postgresql-server postgresql-contrib
            sudo postgresql-setup --initdb
            sudo systemctl enable postgresql
            sudo systemctl start postgresql
        elif [[ "$PKG_MANAGER" == "pacman" ]]; then
            sudo pacman -Sy --noconfirm postgresql
            sudo -u postgres initdb -D /var/lib/postgres/data
            sudo systemctl enable postgresql
            sudo systemctl start postgresql
        elif [[ "$PKG_MANAGER" == "brew" ]]; then
            brew install postgresql@15
            brew services start postgresql@15
        fi
        print_success "Installed PostgreSQL"
    else
        print_success "PostgreSQL is already installed"
    fi
    
    # Install lazygit separately
    print_message "Installing lazygit..."
    if ! command -v lazygit &> /dev/null; then
        if [[ "$PKG_MANAGER" == "apt" ]]; then
            # Add lazygit PPA for Ubuntu/Debian
            LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
            curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
            tar xf lazygit.tar.gz lazygit
            sudo install lazygit /usr/local/bin
            rm lazygit lazygit.tar.gz
        elif [[ "$PKG_MANAGER" == "dnf" ]]; then
            sudo dnf copr enable atim/lazygit -y
            sudo dnf install -y lazygit
        elif [[ "$PKG_MANAGER" == "pacman" ]]; then
            sudo pacman -Sy --noconfirm lazygit
        elif [[ "$PKG_MANAGER" == "brew" ]]; then
            brew install lazygit
        fi
        print_success "Installed lazygit"
    else
        print_success "lazygit is already installed"
    fi
}

# Main installation process
main() {
    print_message "Starting installation..."

    if [ ! -d ".config" ]; then
        print_error "Please run this script from the root of the dotfiles repository"
        exit 1
    fi

    # Check if .zshrc exists in root directory
    if [ ! -f ".zshrc" ]; then
        print_error "No .zshrc found in dotfiles directory"
        exit 1
    fi

    # Configurations and files to be linked
    configs=("nvim" "wezterm" "bat" "btop" "macchina" "aerospace" "yazi" "pgcli" "lazygit")
    files=("starship.toml")
    packages=("neovim" "wezterm" "bat" "btop" "macchina" "starship" "yazi" "pgcli" "git")

    backup_configs
    detect_and_install_packages
    create_symlinks
    install_zsh_autosuggestions

    print_success "Installation completed successfully!"
    print_message "Please restart your terminal for changes to take effect."
}

main
