local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.on_attach(function(_client, bufnr)
	lsp.default_keymaps({ buffer = bufnr })
end)

lsp.setup()
