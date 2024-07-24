---@type MappingsTable
local M = {}

M.general = {
      n = {
        ["<leader>w"] = { "<cmd>w<CR>", "Save"},
        ["|"] = { "<cmd>:vsplit<CR>", "Vertical split"},
        ["<TAB>"] = { "<cmd>:tabNext<CR>", "Go to next tab"},
        ["."] = {"."}
    }
}

-- more keybinds!

return M
