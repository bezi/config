-- Helper: build the box lines
local function make_box(text)
  local len = vim.fn.strdisplaywidth(text) + 6
  local bar = "# " .. string.rep("=", len)
  local mid = "# -- " .. text .. " --"
  return { bar, mid, bar }
end

-- Command: Boxify the current line
vim.api.nvim_create_user_command("Boxify", function()
  local lnum = vim.api.nvim_win_get_cursor(0)[1]  -- current line number
  local line = vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false)[1]

  if not line or line == "" then
    vim.notify("[Boxify] Current line is empty", vim.log.levels.WARN)
    return
  end

  vim.api.nvim_buf_set_lines(0, lnum - 1, lnum, false, make_box(line))
end, { desc = "Wrap the current line in a comment box" })

vim.keymap.set("n", "<leader>b", ":Boxify<CR>", { noremap = true, silent = true })
