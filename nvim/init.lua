require("core")

require("core.utils").load_mappings()

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	require("core.bootstrap").lazy(lazypath)
end

dofile(vim.g.base46_cache .. "defaults")
vim.opt.rtp:prepend(lazypath)
require("plugins")

vim.cmd([[
function OpenMarkdownPreview (url)
  execute "silent ! google-chrome-stable --new-window --app=" . a:url
endfunction
]])
vim.g.mkdp_browserfunc = "OpenMarkdownPreview"

require("snippets")
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.snippets",
	callback = function()
		vim.cmd("syntax off")
	end,
})

require("git-conflict")


require("null-ls").setup({
  sources = {
    require("null-ls").builtins.formatting.prettier.with({
      extra_args = { "--tab-width", "4" },
    }),
  },
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.expandtab = true
  end
})

vim.g.python3_host_prog = '/usr/bin/python3'
vim.g.loaded_python3_provider=nil

vim.api.nvim_set_keymap('n', '<A-j>', '<cmd> CoqNext <CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-k>', '<cmd> CoqUndo <CR>', { noremap = true, silent = true })

