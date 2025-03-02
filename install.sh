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
    configs=("nvim" "wezterm" "bat" "htop" "macchina" "aerospace" "yazi")
    files=("starship.toml")
    packages=("neovim" "wezterm" "bat" "htop" "macchina" "starship" "yazi")

    backup_configs
    detect_and_install_packages
    create_symlinks

    print_success "Installation completed successfully!"
    print_message "Please restart your terminal for changes to take effect."
}

main
