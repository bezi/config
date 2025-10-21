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

-- Use system clipboard
vim.opt.clipboard = "unnamedplus"

-- Make Vim split behavior match tmux
vim.opt.splitright = true
vim.opt.splitbelow = true

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

local auto_save_group = vim.api.nvim_create_augroup("beziAutoSave", {})
vim.api.nvim_create_autocmd("FocusLost", {
	group = auto_save_group,
	callback = function()
		local buf = vim.api.nvim_get_current_buf()
		local name = vim.api.nvim_buf_get_name(buf)

		-- skip unnamed, readonly, or unmodifiable buffers
		if name ~= "" and vim.bo[buf].modifiable and not vim.bo[buf].readonly and vim.bo[buf].modified then
			vim.cmd("silent write")
		end
	end,
})
