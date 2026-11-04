local M = {}

-- rust-analyzer only removes unused imports inside the requested range, so ask
-- for the whole file. Synchronous so it can run as part of a save.
function M.remove_unused_imports(bufnr)
	-- lib.rs is mostly `pub use` re-exports, which rust-analyzer considers unused.
	if vim.fs.basename(vim.api.nvim_buf_get_name(bufnr)) == "lib.rs" then
		return
	end

	local client = vim.lsp.get_clients({ bufnr = bufnr, name = "rust_analyzer" })[1]
	if not client then
		return
	end

	local params = vim.lsp.util.make_given_range_params(
		{ 1, 0 },
		{ vim.api.nvim_buf_line_count(bufnr), 0 },
		bufnr,
		client.offset_encoding
	)
	params.context = { diagnostics = {} }

	local response = client:request_sync("textDocument/codeAction", params, 500, bufnr)
	for _, action in ipairs(response and response.result or {}) do
		if action.title == "Remove all unused imports" then
			if not action.edit then
				local resolved = client:request_sync("codeAction/resolve", action, 500, bufnr)
				action = resolved and resolved.result or action
			end
			if action.edit then
				vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
			end
			return
		end
	end
end

return M
