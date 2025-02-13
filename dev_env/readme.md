# Mac Environment Backup Scripts

A pair of scripts for backing up and restoring your macOS development environment, including configurations for various tools, dotfiles, and Homebrew packages.

## Features

- Backs up:
  - Homebrew packages (formulae and casks)
  - Config directories (.config/\*)
  - Neovim configuration and plugins
  - Various dotfiles (.zshrc, .gitconfig, etc.)
  - Terminal configurations (WezTerm, etc.)
- Cross-platform restore capability
- Verification of backed-up files
- Automatic package manager setup on restore

## Prerequisites

- macOS (for backup)
- Any Unix-like system or Windows with WSL (for restore)
- Bash shell
- `zip` utility (for backup)
- `unzip` utility (for restore)

## Usage

### Backup (macOS only)

```bash
chmod +x backup.sh
./backup.sh
```

This will create a zip file named `mac_env_backup_YYYYMMDD_HHMMSS.zip` in your current directory.

### Restore (Cross-platform)

```bash
chmod +x restore.sh
./restore.sh <backup_zip_file>
```

## Post-Restore Steps

Depending on your OS:

- macOS: `source ~/.zshrc`
- Linux: `chsh -s $(which zsh)`
- Windows: Consider using WSL for better compatibility

## Customization

To add more directories or files to backup, edit the `CONFIG_DIRS` and `CONFIG_FILES` arrays in `macos-backup.sh`.

## Troubleshooting

If you encounter issues:

1. Check file permissions
2. Ensure all required utilities are installed
3. Verify the backup zip file exists and isn't corrupted
4. Check available disk space in the destination
