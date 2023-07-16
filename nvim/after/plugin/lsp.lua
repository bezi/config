local lsp = require('lsp-zero')

lsp.preset('recommended')

lsp.on_attach(function(_client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
  lsp.buffer_autoformat()
end)

lsp.setup()
