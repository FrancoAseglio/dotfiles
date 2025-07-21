vim.cmd("let g:netrw_liststyle = 3")

-- input timing
vim.opt.timeoutlen = 500

-- line numbers
vim.opt.relativenumber = true
vim.opt.number         = true

-- tabs & indentation
vim.opt.tabstop    = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab  = true
vim.opt.autoindent = true

-- line wrapping
vim.opt.wrap = false

-- search settings
vim.opt.ignorecase = true
vim.opt.smartcase  = true

-- cursor line
vim.opt.cursorline = true

-- appearance
vim.opt.termguicolors = true
vim.opt.background    = "dark"
vim.opt.signcolumn    = "yes"

-- backspace
vim.opt.backspace = "indent,eol,start"

-- turn off swapfile
vim.opt.swapfile = false

-- system clipboard as default register
vim.opt.clipboard:append("unnamedplus")

-- folding
vim.opt.foldenable     = true
vim.opt.foldlevel      = 10
vim.opt.foldlevelstart = 10
vim.opt.foldcolumn     = "0"
vim.opt.foldmethod     = "expr"
vim.opt.foldexpr       = "nvim_treesitter#foldexpr()"
