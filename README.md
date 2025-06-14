# DevEnv Config

My personal terminal configuration files for macOS with Neovim, WezTerm, and CLI tools.  
Originally based on [Josean Martinez](https://github.com/josean-dev) work.

---

### 📋 0.1 System Requirements

- Terminal emulator that supports UTF-8: [WezTerm](https://wezfurlong.org/wezterm/)
- Curl for downloading dependencies: [curl](https://curl.se/)
- Fzf for fuzzy finding: [fzf](https://github.com/junegunn/fzf)
- Compatible Nerd Font: [NerdFont](https://www.nerdfonts.com/) 

---

### ⚙️ 0.2 Setup

#### Install Homebrew:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

#### Add to PATH (Apple Silicon):

```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

---

### 📦 1. Clone the Repository

Using HTTPS:

```bash
git clone https://github.com/FrancoAseglio/dotfiles.git
```

Or with SSH (requires SSH key):

```bash
git clone git@github.com:FrancoAseglio/dotfiles.git
```

Step into the dir:

```bash
cd dotfiles
```

---

### 🧹 2. Remove Git Repository

Detach from version control and keep going solo:

```bash
rm -rf .git
```

---

### 🚀 3. Run Installation

```bash
chmod +x install.sh
./install.sh
```

The script performs the following automated steps:

1. **Shell Configuration**

   - Creates a new `.zshrc` with helpful defaults and aliases
   - Integrates with Starship for a minimal, beautiful prompt
   - Adds zsh-autosuggestions if not already installed

2. **Backup Creation**

   - Creates a timestamped directory in `~/.config/`
   - Moves existing configurations into the backup folder

3. **Package Installation**

   - Installs required packages using Homebrew or your Linux package manager
   - Skips anything already installed
   - Installs PostgreSQL and LazyGit using custom logic if needed

4. **Symlink Creation**

   - Links dotfiles from the repo to your home directory
   - Ensures `~/.config` structure exists
   - Keeps your environment consistent and updatable

5. **Aerospace NOT Installed**
   - Rememeber to clone and build Aerospace from source
   - Requires Rust installed beforehand
   - Then apply the custom from here

---

## 🗃️ Backup Management

- Backups are stored in: `~/.config/backup_[timestamp]`
- Review and clean old backups occasionally
- Always keep at least one known good backup

---

## 🔗 Resources

- [Aerospace](https://nikitabobko.github.io/AeroSpace/guide)
- [Homebrew](https://docs.brew.sh/)
- [Neovim](https://neovim.io/doc/)
- [Pgcli](https://github.com/dbcli/pgcli)
- [Starship](https://starship.rs/)
- [Yazi](https://yazi-rs.github.io/docs/installation)
