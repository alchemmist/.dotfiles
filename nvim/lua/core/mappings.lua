-- n, v, i, t = mode names

-- local latex_mappings = require("custom.latex")

local M = {}

M.general = {
	i = {
		["<C-b>"] = { "<ESC>^i", "Beginning of line" },
		["<C-e>"] = { "<End>", "End of line" },

		["<C-.>"] = { "\\Rightarrow", "Latex right arrow" },
		["<C-,>"] = { "\\Leftarrow", "Latex left arrow" },

		-- navigate within insert mode
		-- ["<C-h>"] = { "<Left>", "Move left" },
		-- ["<C-l>"] = { "<Right>", "Move right" },
		-- ["<C-j>"] = { "<Down>", "Move down" },
		-- ["<C-k>"] = { "<Up>", "Move up" },

		-- my
		["<A-BS>"] = { "<ESC>dbi<DEL>", "Delete previus word" },
		-- ["<C-j>"] = {
		--         function()
		--             require("cmp").mapping.complete()
		--         end,
		--         "Enable complititon"
		--     },
	},

	n = {
		["<Esc>"] = { "<cmd> noh <CR>", "Clear highlights" },
		["<C-BS>"] = { "<ESC>dbi", "Delete previus word" },
		-- switch between windows
		["<C-h>"] = { "<C-w>h", "Window left" },
		["<C-l>"] = { "<C-w>l", "Window right" },
		["<C-j>"] = { "<C-w>j", "Window down" },
		["<C-k>"] = { "<C-w>k", "Window up" },

		-- save
		["<C-s>"] = { "<cmd> w <CR>", "Save file" },
		-- run script
		["<leader>rp"] = { "<cmd> !python % <CR>", "Fust run python file" },
		["<leader>rr"] = { "<cmd> RustRun <CR>", "Fust run rust file" },
		["<leader>rl"] = { "<cmd> !lua % <CR>", "Fust run lua file" },

		-- Copy all
		["<C-c>"] = { "<cmd> %y+ <CR>", "Copy whole file" },

		-- line numbers
		["<leader>n"] = { "<cmd> set nu! <CR>", "Toggle line number" },
		["<leader>rn"] = { "<cmd> set rnu! <CR>", "Toggle relative number" },

		-- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
		-- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
		-- empty mode is same as using <cmd> :map
		-- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
		["j"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", opts = { expr = true } },
		["k"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", opts = { expr = true } },
		["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", opts = { expr = true } },
		["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", opts = { expr = true } },

		["<leader>z"] = { "<cmd>Nvdash<CR>", "Dashboard" },
		["<leader>l"] = { "<cmd>LazyGit<CR>", "LazyGit" },
		["<leader>ch"] = { "<cmd> NvCheatsheet <CR>", "Mapping cheatsheet" },

		["<leader>fm"] = {
			function()
				vim.lsp.buf.format({ async = true })
			end,
			"LSP formatting",
		},
		["<leader>b"] = { "<cmd>VimtexCompile<CR>", "Build latex doc" },
		["<leader>v"] = { "<cmd>VimtexView<CR>", "View place in latex doc" },
        ["<leader>w"] = { "<cmd>w<CR>", "Save"},
        ["|"] = { "<cmd>:vsplit<CR>", "Vertical split"},
        ["<TAB>"] = { "<cmd>:tabNext<CR>", "Go to next tab"},
        ["."] = {"."},
        ["<S-E>"] = {vim.diagnostic.open_float, "Show LSP message"},
	},

	t = {
		["<C-x>"] = { vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true), "Escape terminal mode" },
	},

	v = {
		["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", opts = { expr = true } },
		["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", opts = { expr = true } },
		["<"] = { "<gv", "Indent line" },
		[">"] = { ">gv", "Indent line" },
		-- ["<C-b>"] = {
		-- 	latex_mappings.wrap_text_in_textbf,
		-- 	"Wrap text in \\textbf{}",
		-- 	opts = {
		-- 		callback = function()
		-- 			if vim.bo.filetype == "tex" then
		-- 				latex_mappings.wrap_text_in_textbf()
		-- 			end
		-- 		end,
		-- 	},
		-- },
	},

	x = {
		["j"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", opts = { expr = true } },
		["k"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", opts = { expr = true } },
		-- Don't copy the replaced text after pasting in visual mode
		-- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
		["p"] = { 'p:let @+=@0<CR>:let @"=@0<CR>', "Dont copy replaced text", opts = { silent = true } },
	},
}

M.tabufline = {
	plugin = true,

	n = {
		-- cycle through buffers
		["<S-l>"] = {
			function()
				require("nvchad.tabufline").tabuflineNext()
			end,
			"Goto next buffer",
		},

		["<S-h>"] = {
			function()
				require("nvchad.tabufline").tabuflinePrev()
			end,
			"Goto prev buffer",
		},

		-- close buffer + hide terminal buffer
		["<leader>x"] = {
			function()
				require("nvchad.tabufline").close_buffer()
			end,
			"Close buffer",
		},
		["<leader>ч"] = {
			function()
				require("nvchad.tabufline").close_buffer()
			end,
			"Close buffer",
		},
	},
}

M.comment = {
	plugin = true,

	-- toggle comment in both modes
	n = {
		["<leader>/"] = {
			function()
				require("Comment.api").toggle.linewise.current()
			end,
			"Toggle comment",
		},
	},

	v = {
		["<leader>/"] = {
			"<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
			"Toggle comment",
		},
	},
}

M.lspconfig = {
	plugin = true,

	-- See `<cmd> :help vim.lsp.*` for documentation on any of the below functions

	n = {
		["gD"] = {
			function()
				vim.lsp.buf.declaration()
			end,
			"LSP declaration",
		},
		["gd"] = {
			function()
				vim.lsp.buf.definition()
			end,
			"LSP definition",
		},

		["K"] = {
			function()
				vim.lsp.buf.hover()
			end,
			"LSP hover",
		},

		["gi"] = {
			function()
				vim.lsp.buf.implementation()
			end,
			"LSP implementation",
		},

		["<leader>D"] = {
			function()
				vim.lsp.buf.type_definition()
			end,
			"LSP definition type",
		},

		["<leader>ra"] = {
			function()
				require("nvchad.renamer").open()
			end,
			"LSP rename",
		},

		["<leader>ca"] = {
			function()
				vim.lsp.buf.code_action()
			end,
			"LSP code action",
		},

		["gr"] = {
			function()
				vim.lsp.buf.references()
			end,
			"LSP references",
		},

		["E"] = {
			function()
				vim.diagnostic.open_float({ border = "rounded" })
			end,
			"Floating diagnostic",
		},

		["[d"] = {
			function()
				vim.diagnostic.goto_prev({ float = { border = "rounded" } })
			end,
			"Goto prev",
		},

		["]d"] = {
			function()
				vim.diagnostic.goto_next({ float = { border = "rounded" } })
			end,
			"Goto next",
		},

		["<leader>q"] = {
			function()
				vim.diagnostic.setloclist()
			end,
			"Diagnostic setloclist",
		},

		["<leader>wa"] = {
			function()
				vim.lsp.buf.add_workspace_folder()
			end,
			"Add workspace folder",
		},

		["<leader>wr"] = {
			function()
				vim.lsp.buf.remove_workspace_folder()
			end,
			"Remove workspace folder",
		},

		["<leader>wl"] = {
			function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end,
			"List workspace folders",
		},
	},

	v = {
		["<leader>ca"] = {
			function()
				vim.lsp.buf.code_action()
			end,
			"LSP code action",
		},
	},
    i = {
		["<C-l>"] = {
			function()
				vim.lsp.buf.signature_help()
			end,
			"LSP signature help",
		},
    },

}

M.nvimtree = {
	plugin = true,

	n = {
		-- toggle
		-- ["<C-n>"] = { "<cmd> NvimTreeToggle <CR>", "Toggle nvimtree" },

		-- focus
		["<leader>e"] = { "<cmd> Neotree float<CR>", "Focus nvimtree" },
		["<leader>у"] = { "<cmd> Neotree float<CR>", "Focus nvimtree" },
	},
}

M.telescope = {
	plugin = true,

	n = {
		-- find
		["<leader>ff"] = { "<cmd>Telescope find_files <CR>", "Find files" },
		["<leader>fa"] = { "<cmd>Telescope find_files follow=true no_ignore=true hidden=true <CR>", "Find all" },
		["<leader>fw"] = { "<cmd>Telescope live_grep <CR>", "Live grep" },
		["<leader>fb"] = { "<cmd>Telescope buffers <CR>", "Find buffers" },
		["<leader>fh"] = { "<cmd>Telescope help_tags <CR>", "Help page" },
		["<leader>fo"] = { "<cmd>Telescope oldfiles <CR>", "Find oldfiles" },
		["<leader>fz"] = { "<cmd>Telescope current_buffer_fuzzy_find <CR>", "Find in current buffer" },

		-- git
		["<leader>cm"] = { "<cmd> Telescope git_commits <CR>", "Git commits" },
		["<leader>gt"] = { "<cmd> Telescope git_status <CR>", "Git status" },

		-- pick a hidden term
		["<leader>pt"] = { "<cmd> Telescope terms <CR>", "Pick hidden term" },

		-- theme switcher
		["<leader>th"] = { "<cmd> Telescope themes <CR>", "Nvchad themes" },

		["<leader>ma"] = { "<cmd> Telescope marks <CR>", "telescope bookmarks" },
	},
}

M.nvterm = {
	plugin = true,

	t = {
		-- toggle in terminal mode
		["<A-i>"] = {
			function()
				require("nvterm.terminal").toggle("float")
			end,
			"Toggle floating term",
		},

		["<A-h>"] = {
			function()
				require("nvterm.terminal").toggle("horizontal")
			end,
			"Toggle horizontal term",
		},

		["<A-v>"] = {
			function()
				require("nvterm.terminal").toggle("vertical")
			end,
			"Toggle vertical term",
		},
	},

	n = {
		-- toggle in normal mode
		["<A-f>"] = {
			function()
				require("nvterm.terminal").toggle("float")
			end,
			"Toggle floating term",
		},

		["<A-h>"] = {
			function()
				require("nvterm.terminal").toggle("horizontal")
			end,
			"Toggle horizontal term",
		},

		["<A-v>"] = {
			function()
				require("nvterm.terminal").toggle("vertical")
			end,
			"Toggle vertical term",
		},
	},
}

M.whichkey = {
	plugin = true,

	n = {
		["<leader>wK"] = {
			function()
				vim.cmd("WhichKey")
			end,
			"Which-key all keymaps",
		},
		["<leader>wk"] = {
			function()
				local input = vim.fn.input("WhichKey: ")
				vim.cmd("WhichKey " .. input)
			end,
			"Which-key query lookup",
		},
	},
}

M.blankline = {
	plugin = true,

	n = {
		["<leader>cc"] = {
			function()
				local ok, start = require("indent_blankline.utils").get_current_context(
					vim.g.indent_blankline_context_patterns,
					vim.g.indent_blankline_use_treesitter_scope
				)

				if ok then
					vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { start, 0 })
					vim.cmd([[normal! _]])
				end
			end,

			"Jump to current context",
		},
	},
}


return M
