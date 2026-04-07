-- Neovim 0.12+: enable treesitter highlighting and indentation via native API
vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		pcall(vim.treesitter.start)
		vim.bo.indentexpr = "v:lua.require'vim.treesitter'.indentexpr()"
	end,
})
