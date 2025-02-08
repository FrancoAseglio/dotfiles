# Terminal Configuration

My personal terminal configuration files for macOS, including settings for Neovim, WezTerm, and other development tools.

## 🚀 Features

- Neovim configuration with custom plugins and LSP setup
- WezTerm terminal emulator configuration
- Starship prompt customization
- Various CLI tool configurations (bat, htop, neofetch)
- Shell configuration files (.zshrc)

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- Git
- Homebrew
- Neovim (latest version)
- Zsh
- WezTerm

## 🔧 Installation

1. Clone the repository:

```bash
git clone https://github.com/YourUsername/terminal-config.git ~/.terminal-config
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

## 💡 Tips

- Use `SPC + ee` for File Explorer
- Use `SPC + ff` for Find File
- Use `SPC + fs` for Live Grep
- Use `SPC + wr` to Restore Session

## 🤝 Contributing

Feel free to fork and submit pull requests.

## 📝 License

MIT License - feel free to use and modify as you wish.
