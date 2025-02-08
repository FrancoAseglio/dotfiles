#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print with color
print_message() {
    echo -e "${BLUE}==>${NC} $1"
}

print_success() {
    echo -e "${GREEN}==>${NC} $1"
}

print_error() {
    echo -e "${RED}==>${NC} $1"
}

# Create backup of existing configs
backup_configs() {
    print_message "Creating backup of existing configurations..."
    timestamp=$(date +%Y%m%d_%H%M%S)
    backup_dir="$HOME/.config/backup_$timestamp"
    
    mkdir -p "$backup_dir"
    
    # Backup existing configurations
    if [ -d "$HOME/.config/nvim" ]; then
        mv "$HOME/.config/nvim" "$backup_dir/"
    fi
    if [ -d "$HOME/.config/wezterm" ]; then
        mv "$HOME/.config/wezterm" "$backup_dir/"
    fi
    # Add other config backups here
    
    print_success "Backup created at $backup_dir"
}

# Create symbolic links
create_symlinks() {
    print_message "Creating symbolic links..."
    
    # Create .config directory if it doesn't exist
    mkdir -p "$HOME/.config"
    
    # Array of configurations to link
    configs=(
        "nvim"
        "wezterm"
        "bat"
        "htop"
        "neofetch"
        "aerospace"
    )
    
    # Create symlinks
    for config in "${configs[@]}"; do
        if [ -d "$PWD/.config/$config" ]; then
            ln -sf "$PWD/.config/$config" "$HOME/.config/$config"
            print_success "Linked $config configuration"
        fi
    done
    
    # Link individual files
    files=(
        "starship.toml"
    )
    
    for file in "${files[@]}"; do
        if [ -f "$PWD/.config/$file" ]; then
            ln -sf "$PWD/.config/$file" "$HOME/.config/$file"
            print_success "Linked $file"
        fi
    done
}

# Install required packages
install_packages() {
    print_message "Checking for Homebrew..."
    if ! command -v brew &> /dev/null; then
        print_error "Homebrew not found. Please install Homebrew first."
        exit 1
    fi
    
    print_message "Installing required packages..."
    
    # Add your required packages here
    packages=(
        "neovim"
        "wezterm"
        "bat"
        "htop"
        "neofetch"
        "starship"
    )
    
    for package in "${packages[@]}"; do
        if ! brew list $package &> /dev/null; then
            print_message "Installing $package..."
            brew install $package
        else
            print_success "$package already installed"
        fi
    done
}

# Main installation process
main() {
    print_message "Starting installation..."
    
    # Check if script is run from the right directory
    if [ ! -d ".config" ]; then
        print_error "Please run this script from the root of the dotfiles repository"
        exit 1
    fi
    
    # Create backups
    backup_configs
    
    # Install required packages
    install_packages
    
    # Create symlinks
    create_symlinks
    
    print_success "Installation completed successfully!"
    print_message "Please restart your terminal for changes to take effect."
}

# Run main installation
main
