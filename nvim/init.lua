require("core")

local custom_init_path = vim.api.nvim_get_runtime_file("lua/custom/init.lua", false)[1]

if custom_init_path then
	dofile(custom_init_path)
end

require("core.utils").load_mappings()

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- bootstrap lazy.nvim!
if not vim.loop.fs_stat(lazypath) then
	require("core.bootstrap").gen_chadrc_template()
	require("core.bootstrap").lazy(lazypath)
end

-- Rust setup
dofile(vim.g.base46_cache .. "defaults")
vim.opt.rtp:prepend(lazypath)
require("plugins")
local rt = require("rust-tools")

rt.setup({
	server = {
		on_attach = function(_, bufnr)
			-- Hover actions
			-- vim.keymap.set("n", "<Leader>b", rt.hover_actions.hover_actions, { buffer = bufnr })
			-- Code action groups
			-- vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
		end,
	},
})

vim.cmd([[
function OpenMarkdownPreview (url)
  execute "silent ! google-chrome-stable --new-window --app=" . a:url
endfunction
]])
vim.g.mkdp_browserfunc = "OpenMarkdownPreview"

require("custom.snippets")

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.snippets",
	callback = function()
		vim.cmd("syntax off")
	end,
})

require("custom.figures")
vim.api.nvim_set_keymap(
	"v",
	"<C-f>",
	":lua require('lua.custom.figures').create_figure()<CR>",
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
	"v",
	"<C-e>",
	":lua require('lua.custom.figures').edit_figure()<CR>",
	{ noremap = true, silent = true }
)
