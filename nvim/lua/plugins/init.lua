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
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' },


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

	-- LSP Support
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v2.x",
		dependencies = {
			{ "neovim/nvim-lspconfig" },
			{
				"williamboman/mason.nvim",
				build = ":MasonUpdate",
			},
			{ "williamboman/mason-lspconfig.nvim" },

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "L3MON4D3/LuaSnip" },
		},
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
}
