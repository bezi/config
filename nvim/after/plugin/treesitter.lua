-- Neovim 0.12+: enable treesitter highlighting and indentation via native API.
--
-- `vim.treesitter.start` turns OFF regex syntax highlighting. If the parser is
-- present but the `highlights` query is not, the buffer ends up with neither
-- form of highlighting and looks completely blank. Start treesitter only when
-- both halves are available, and leave regex syntax in place otherwise.
local function has_query(lang, name)
	local ok, query = pcall(vim.treesitter.query.get, lang, name)
	return ok and query ~= nil
end

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("beziTreesitter", { clear = true }),
	callback = function(event)
		local lang = vim.treesitter.language.get_lang(vim.bo[event.buf].filetype)
		if lang == nil then
			return
		end

		-- A missing parser is normal; do not warn about it.
		if not pcall(vim.treesitter.language.add, lang) then
			return
		end

		if not has_query(lang, "highlights") then
			return
		end

		if not pcall(vim.treesitter.start, event.buf, lang) then
			return
		end

		-- Core does not ship `vim.treesitter.indentexpr`; nvim-treesitter does.
		if has_query(lang, "indents") then
			vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end,
})
