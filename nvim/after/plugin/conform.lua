require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "ruff_fix", "ruff_format" },
		html = { "prettierd", "prettier", stop_after_first = true },
		css = { "prettierd", "prettier", stop_after_frist = true },
		javascript = { "prettierd", "prettier", stop_after_first = true },
		typescript = { "prettierd", "prettier", stop_after_first = true },
		javascriptreact = { "prettierd", "prettier", stop_after_first = true },
		typescriptreact = { "prettierd", "prettier", stop_after_first = true },
		json = { "prettierd", "prettier", stop_after_first = true },
		rust = { "rustfmt" },
		nix = { "nixfmt" },
		["*"] = { "trim_whitespace", "trim_newlines" },
	},
	formatters = {
		rustfmt = {
			-- imports_granularity is nightly-only; merge each crate's imports into one `use`.
			options = { nightly = true },
			append_args = { "--config", "imports_granularity=Crate" },
		},
	},
	format_on_save = function(bufnr)
		-- Strip unused imports before rustfmt so it tidies up after them.
		if vim.bo[bufnr].filetype == "rust" then
			require("bezi.rust").remove_unused_imports(bufnr)
		end

		-- These options will be passed to conform.format()
		return {
			timeout_ms = 500,
			lsp_fallback = true,
		}
	end,
})
