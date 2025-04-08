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

vim.api.nvim_create_autocmd("FileType", {
	pattern = "java",
	callback = function()
		vim.bo.tabstop = 4
		vim.bo.shiftwidth = 4
		vim.bo.expandtab = true
	end,
})

vim.g.python3_host_prog = "/usr/bin/python3"
vim.g.loaded_python3_provider = nil

vim.api.nvim_set_keymap("n", "<A-j>", "<cmd> CoqNext <CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<A-k>", "<cmd> CoqUndo <CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<M-_>", "<cmd>:split<CR>", { noremap = true, silent = true })

vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = "*",
	callback = function()
		require("conform").format({ async = true })
	end,
})

vim.keymap.set("n", "<leader>fm", function()
	require("conform").format({ async = true })
end, { desc = "LSP formatting" })

vim.api.nvim_set_hl(0, "Comment", { fg = "#555555", italic = true })

require("ufo")

vim.keymap.set("n", "zR", require("ufo").openAllFolds)
vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
vim.keymap.set("n", "<leader>h", function()
    local winid = vim.api.nvim_get_current_win()
    local lnum = vim.api.nvim_win_get_cursor(winid)[1]
    local fold_closed = vim.fn.foldclosed(lnum) ~= -1

    if fold_closed then
        vim.cmd("normal! zo")  -- open fold
    else
        vim.cmd("normal! zc")  -- close fold
    end
end, { desc = "Toggle fold under cursor" })


vim.cmd("colorscheme nothing")
