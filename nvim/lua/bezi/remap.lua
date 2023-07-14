vim.g.mapleader = ","
vim.keymap.set("i", "jj", "<ESC>")
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Center on search, makes it nice and pretty
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")

-- Really throw people under a bus, huh
vim.keymap.set("n", "<up>", "<nop>")
vim.keymap.set("n", "<down>", "<nop>")
vim.keymap.set("n", "<left>", "<nop>")
vim.keymap.set("n", "<right>", "<nop>")
vim.keymap.set("i", "<up>", "<nop>")
vim.keymap.set("i", "<down>", "<nop>")
vim.keymap.set("i", "<left>", "<nop>")
vim.keymap.set("i", "<right>", "<nop>")
vim.keymap.set("i", "<ESC>", "<nop>")

-- Clear search hilighting
vim.keymap.set("n", "<leader><space>", vim.cmd.noh)

-- Move code around in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Better behaviour for joining lines, keep cursor the same
vim.keymap.set("n", "J", "mzJ`z")
