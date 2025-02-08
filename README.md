# Terminal Configuration

My personal terminal configuration files for macOS, including settings for Neovim, WezTerm, and other development tools.

## 🚀 Features

- Neovim configuration with custom plugins and LSP setup
- WezTerm terminal emulator configuration
- Starship prompt customization
- Various CLI tool configurations (bat, htop, neofetch)
- Shell configuration files (.zshrc)

![ZSH Configuration](./assets/custom0.png)
_Neovim dashboard with system information and quick actions_

![File Management](./assets/custom1.png)
_Terminal-based file management with detailed information and tree structure via aliases_

![Neovim Dashboard](./assets/custom2.png)
_fzf file previw on splits with customs_

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- Git
- Homebrew
- Neovim (latest version)
- Zsh
- WezTerm
- Aerospace
- Starship
- Bat
- Eza
- The Fuck
- Zoxide
- Neofetch
- Htop

## 🔧 Installation

1. Clone the repository:

```bash
git clone git@github.com:FrancoAseglio/dotfiles.git
```

2. Run the installation script:

```bash
cd ~/.terminal-config
chmod +x install.sh
./install.sh
```

The installation script will:

- Create a backup of your existing configurations (stored in `~/.config/backup_[timestamp]`)
- Check for and install required packages via Homebrew
- Create symbolic links from this repo to your `~/.config` directory
- Show colored output for each step of the process

If you encounter any issues:

- Check the backup directory for your previous configurations
- Run the script with `bash -x install.sh` for debugging output
- Ensure you have the necessary permissions

## 📦 Included Configurations

- `.config/`
  - `nvim/` - Neovim configuration
  - `wezterm/` - WezTerm terminal emulator
  - `bat/` - Bat (cat alternative)
  - `htop/` - Process viewer
  - `neofetch/` - System information tool
  - `aerospace/` - Window manager
  - `starship.toml` - Shell prompt

## ⚙️ Post-Installation

1. Open Neovim to install plugins automatically
2. Restart your terminal
3. Check that all symlinks are correctly created

## 🔄 Updating

To update the configurations:

```bash
cd ~/.terminal-config
git pull
./install.sh
```

## 🤝 Contributing

Feel free to fork and submit pull requests.

## 📝 License

MIT License - feel free to use and modify as you wish.
