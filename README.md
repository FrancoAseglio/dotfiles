# Terminal Configuration

My personal terminal configuration files for macOS;  
providing a comprehensive development environment with Neovim, WezTerm, and CLI tools.
This setup aims to create a consistent, efficient, and pleasant terminal experience.

## 🚀 Features

- **Neovim Configuration**
  - Custom plugin setup for enhanced development
  - Language Server Protocol (LSP) integration
  - Syntax highlighting and code completion
  - File explorer and fuzzy finding
  - Git integration and status indicators
- **WezTerm Terminal Emulator**
  - Modern GPU-accelerated terminal
  - Custom keybindings and shortcuts
  - Split panes and tab management
  - Unicode and ligature support
- **Starship Prompt**
  - Git status integration
  - Command execution time
  - Python virtual environment indicator
  - Node.js version display
- **Development Tools**
  - bat: Modern replacement for cat
  - btop: Interactive process viewer
  - macchina: System information display
  - aerospace: Window management for macOS
  - yazi: Modern terminal file manager with image preview

---

![ZSH Configuration](./assets/custom0.png)
_Neovim dashboard featuring system information and quick actions_

![File Management](./assets/custom1.png)
_Terminal-based file management with detailed information and tree structure_

![Neovim Dashboard](./assets/custom2.png)
_FZF file preview with customized split panes_

![Lazy Git](./assets/custom3.png)
_Lazy Git for easy access on terminal interface_

![Yazi](./assets/custom4.png)
_Yazi terminal file system management_

---

## 📋 Prerequisites

### System Requirements

- Git for version control
- Curl for downloading dependencies
- Terminal emulator that supports UTF-8
- Optional: Compatible Nerd Font

### macOS Setup

- Install Homebrew:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

- Add to PATH (for Apple Silicon Macs):

```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

---

## 🔧 Installation

### 1. Clone the Repository

```bash
git clone git@github.com:FrancoAseglio/dotfiles.git
cd ~/.dotfiles
```

### 2. Review the Configuration

Before installation, you can review:

- `.config/` directory structure
- Package list in install.sh
- Backup mechanism

### 3. Run Installation

```bash
chmod +x install.sh
./install.sh
```

### Installation Process

The script performs the following steps:

1. **Shell Configuration**

   - Generates a new `.zshrc` file in your home directory
   - Configures ZSH with optimal defaults and aliases
   - Sets up integration with Starship prompt

1. **Backup Creation**

   - Creates timestamped backup directory
   - Moves existing configurations to backup
   - Preserves your previous settings

1. **Package Installation**

   - Installs missing required packages via Homebrew
   - Skips already installed packages
   - Reports installation status

1. **Symlink Creation**
   - Creates ~/.config directory if needed
   - Sets up symbolic links for all configurations
   - Maintains easy update capability

### Troubleshooting Installation

**Common Issues:**

1. Permission Denied

```bash
sudo chown -R $USER:$USER ~/.config
```

2. Debug Mode

```bash
bash -x install.sh
```

3. Homebrew Issues

```bash
brew doctor
```

## 📦 Configuration Structure

```
# Home Directory
~/.zshrc                         

# Configuration Directory
.config/
├── nvim/                         
│   ├── init.lua                  
│   ├── lua/                    
│   └── plugins/                  
├── wezterm/                      
│   └── wezterm.lua               
├── bat/                          
│   └── config                    
├── btop/                         
│   ├─ themes/
│   ├─ btop.conf
│   └─ btop.log
├── aerospace/                    
│   └── aerospace.toml            
├── yazi/                         
│   ├── flavors/                 
│   │   └── catppuccin-mocha.yazi/
│   │       ├── flavor.toml    
│   │       ├── LICENSE           
│   │       ├── LICENSE-tmtheme   
│   │       ├── README.md         
│   │       └── tmtheme.xml       
│   ├── keymap.toml               
│   ├── package.toml              
│   ├── theme.toml                
│   └── yazi.toml                
└── starship.toml                
```

## 🔄 Maintaining Your Setup

### Updating Configurations

```bash
cd ~/.dotfiles
git pull
./install.sh
```

---

### Adding New Configurations

1. Add directory/file to `.config/`
2. Update `configs` or `files` array in install.sh
3. Add package name to `packages` array if needed
4. Run installation script

### Backup Management

- Backups are stored in `~/.config/backup_[timestamp]`
- Review and clean old backups periodically
- Keep at least one known working backup

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test the installation script
5. Submit a pull request

Guidelines:

- Follow existing code style
- Update documentation
- Test on macOS
- Include relevant screenshots

## 📚 Resources

- [Neovim Documentation](https://neovim.io/doc/)
- [WezTerm Reference](https://wezfurlong.org/wezterm/)
- [Starship Configuration](https://starship.rs/)
- [Homebrew Guide](https://docs.brew.sh/)
- [Aerospace Documentation](https://nikitabobko.github.io/AeroSpace/guide)
- [Yazi Documentation](https://yazi-rs.github.io/docs/installation)
