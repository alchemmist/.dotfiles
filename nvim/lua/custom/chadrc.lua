---@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files
local highlights = require "custom.highlights"

M.ui = {
  theme = "gruvbox",
  theme_toggle = { "gruvbox", "one_light" },

  hl_override = highlights.override,
  hl_add = highlights.add,
}

M.plugins = "custom.plugins"

-- check core.mappings for table structure
M.mappings = require "custom.mappings"

vim.diagnostic.config({
  float = {
    border = "rounded",  -- Можно использовать: "single", "double", "rounded", "solid", "shadow"
  }
})

vim.cmd [[ inoremap <C-BS> <C-w> ]]
vim.api.nvim_set_keymap('i', '<C-BS>', '<C-W>', {noremap = true})
vim.api.nvim_set_keymap('n', '<S-E>', ':lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })


return M
