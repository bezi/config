-- Only required if you have packer configured as `opt`
vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
	-- Packer can manage itself
	use("wbthomason/packer.nvim")
	-- Nicely integrate with Tmux
	use("christoomey/vim-tmux-navigator")
	-- Auto-toggle comments
	use("tpope/vim-commentary")
	-- Auto-close quotes and parens
	use("Raimondi/delimitMate")
	-- Lets me use surrounds as a vim motion (di( - delete in separator)
	use("tpope/vim-surround")

	-- Finder plugin
	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.3",
		requires = { { "nvim-lua/plenary.nvim" } },
	})

	-- Helper for telescope sorting
	use({
		"nvim-telescope/telescope-fzf-native.nvim",
		run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
	})

	-- Color scheme
	use({
		"rebelot/kanagawa.nvim",
		config = function()
			vim.cmd.colorscheme("kanagawa-dragon")
		end,
	})

	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	})

	-- LSP Support
	use({
		"VonHeikemen/lsp-zero.nvim",
		branch = "v3.x",
		requires = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" }, -- Required
			{ -- Optional
				"williamboman/mason.nvim",
				run = function()
					pcall(vim.cmd, "MasonUpdate")
				end,
			},
			{ "williamboman/mason-lspconfig.nvim" }, -- Optional

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" }, -- Required
			{ "hrsh7th/cmp-nvim-lsp" }, -- Required
			{ "L3MON4D3/LuaSnip" }, -- Required
		},
	})

	-- Run linters
	use("mfussenegger/nvim-lint")

	-- Autoformatting
	use({
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup()
		end,
	})
end)
