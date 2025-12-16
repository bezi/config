return {
	-- Nicely integrate with Tmux
	{ "christoomey/vim-tmux-navigator" },

	-- Auto-toggle comments
	{ "tpope/vim-commentary" },

	-- Auto-close quotes and parens
	{ "Raimondi/delimitMate" },

	-- Lets me use surrounds as a vim motion (di( - delete in separator)
	{ "tpope/vim-surround" },

	-- Finder plugin
	{
		"nvim-telescope/telescope.nvim",
		version = "0.1.3",
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	-- Helper for telescope sorting
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
	},

	-- Color scheme
	{
		"rebelot/kanagawa.nvim",
		config = function()
			vim.cmd.colorscheme("kanagawa-dragon")
		end,
	},

	-- treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
	},

	-- Run linters
	{ "mfussenegger/nvim-lint" },

	-- Autoformatting
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup()
		end,
	},

	-- LSPs
	-- Mason: install servers
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		config = function()
			require("mason").setup()
		end,
	},

	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "pyright", "vtsls" },
				automatic_installation = true,
			})
		end,
	},

	-- LSPconfig & native LSP API
	{
		"neovim/nvim-lspconfig",
		config = function()
			vim.diagnostic.config({
				float = { border = "rounded" },
				update_in_insert = false,
				severity_sort = true,
			})
			-- common on_attach + capabilities
			local on_attach = function(client, bufnr)
				local bufopts = { buffer = bufnr, remap = false }
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
				vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
				vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, bufopts)
			end

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			local cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
			if cmp_ok then
				capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
			end

			local servers = { "pyright", "vtsls", "rust_analyzer" }
			for _, lsp in ipairs(servers) do
				vim.lsp.config(lsp, {
					on_attach = on_attach,
					capabilities = capabilities,
				})
				vim.lsp.enable(lsp)
			end
		end,
	},

	-- CMP + completion
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"L3MON4D3/LuaSnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-n>"] = function(fallback)
						if cmp.visible() then
							cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
						else
							cmp.complete() -- trigger completion menu
						end
					end,
					["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = {
					{ name = "nvim_lsp" },
					{ name = "buffer" },
					{ name = "path" },
				},
			})
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
	},
}
