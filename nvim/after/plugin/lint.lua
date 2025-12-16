local lint = require("lint")

lint.linters.clippy.args = {
	"clippy",
	"--message-format=json",
	"--all-targets",
	"--",
	"-W",
	"clippy::all",
}

lint.linters_by_ft = {
	python = { "ruff" },
	javascript = { "eslint_d" },
	typescript = { "eslint_d" },
	javascriptreact = { "eslint_d" },
	typescriptreact = { "eslint_d" },
	rust = { "clippy" },
}

vim.api.nvim_create_autocmd("BufWritePost", {
	callback = function()
		lint.try_lint()
	end,
})
