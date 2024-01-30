vim.opt.nu = true
vim.opt.colorcolumn = "81"
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
vim.opt.textwidth = 80

vim.opt.swapfile = false
vim.opt.backup = false

vim.opt.signcolumn = "no"
vim.opt.updatetime = 50

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

-- Automatically toggle relative numbers only for the buffer you're in
vim.opt.relativenumber = true
local relative_number_group = vim.api.nvim_create_augroup("beziRelative", {})
vim.api.nvim_create_autocmd("WinEnter", {
	pattern = "*",
	callback = function()
		vim.opt.relativenumber = true
	end,
	group = relative_number_group,
})

vim.api.nvim_create_autocmd("WinLeave", {
	pattern = "*",
	callback = function()
		vim.opt.relativenumber = false
	end,
	group = relative_number_group,
})

-- Save on focus loss
local auto_save_group = vim.api.nvim_create_augroup("beziRelative", {})
vim.api.nvim_create_autocmd("FocusLost", {
	pattern = "*",
	callback = function()
		vim.cmd("wa")
	end,
	group = auto_save_group,
})
