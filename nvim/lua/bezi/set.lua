vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.colorcolumn = '81'
vim.opt.termguicolors = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.scrolloff = 8
vim.opt.cursorline = true
vim.opt.ruler = true

vim.opt.wrap = true
vim.opt.textwidth=80

vim.opt.swapfile = false
vim.opt.backup = false

vim.opt.signcolumn = "no"

-- smarter search defaults
vim.opt.ignorecase = true

-- case insensitive search unless there's varied casing, then it's case sensitive
vim.opt.smartcase = true

-- automatically overwrite all instances on s//.  To get previous behaviour, use
--   s//g
vim.opt.gdefault = true

-- hilight as you type search
vim.opt.incsearch = true
vim.opt.showmatch = true
vim.opt.hlsearch = true

vim.opt.updatetime = 50
