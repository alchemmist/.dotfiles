local jdtls = require("jdtls")

-- Определим путь к jdtls и корневую директорию проекта
local root_dir = jdtls.setup.find_root({ ".git", "pom.xml", "build.gradle", ".project" })

-- Определим базовую конфигурацию
local config = {
	cmd = { "jdtls" }, -- Замените на актуальный путь к jdtls
	root_dir = root_dir,
	settings = {
		java = {
			-- здесь можно настроить дополнительные параметры
			format = {
				enabled = true,
				settings = {
					tabSize = 4,
					indentSize = 4,
					insertSpaces = true,
				},
			},
		},
	},
	init_options = {
		bundles = {
			vim.fn.glob("~/.local/share/nvim/mason/packages/jdtls/eclipse.jdt.ls-standalone-*.jar"),
		},
	},
}

-- Запуск или присоединение к серверу
jdtls.start_or_attach(config)

-- Добавим настройки сочетаний клавиш
local mappings = {
	n = {
		["gd"] = { vim.lsp.buf.definition, "LSP definition" },
		["K"] = { vim.lsp.buf.hover, "LSP hover" },
		["gi"] = { vim.lsp.buf.implementation, "LSP implementation" },
		["<leader>D"] = { vim.lsp.buf.type_definition, "LSP type definition" },
		["<leader>ra"] = {
			function()
				require("nvchad.renamer").open()
			end,
			"LSP rename",
		},
		["<leader>ca"] = { vim.lsp.buf.code_action, "LSP code action" },
		["gr"] = { vim.lsp.buf.references, "LSP references" },
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
			"Goto prev diagnostic",
		},
		["]d"] = {
			function()
				vim.diagnostic.goto_next({ float = { border = "rounded" } })
			end,
			"Goto next diagnostic",
		},
		["<leader>q"] = { vim.diagnostic.setloclist, "Diagnostic setloclist" },
		["<leader>wa"] = { vim.lsp.buf.add_workspace_folder, "Add workspace folder" },
		["<leader>wr"] = { vim.lsp.buf.remove_workspace_folder, "Remove workspace folder" },
		["<leader>wl"] = {
			function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end,
			"List workspace folders",
		},

		-- Дополнительные команды для JDTLS
		["<leader>oi"] = { vim.lsp.buf.organize_imports, "Organize Imports" },
		["<leader>ev"] = { vim.lsp.buf.extract_variable, "Extract Variable" },
		["<leader>em"] = { vim.lsp.buf.extract_method, "Extract Method" },
		["<leader>ea"] = { vim.lsp.buf.extract_all, "Extract All Occurrences" },
		["<leader>ec"] = { vim.lsp.buf.extract_constant, "Extract Constant" },
		["<leader>eg"] = { vim.lsp.buf.generate_toString, "Generate toString" },
		["<leader>eh"] = { vim.lsp.buf.generate_hashCode, "Generate hashCode" },
		["<leader>eq"] = { vim.lsp.buf.generate_equals, "Generate equals" },

		-- Для работы с тестами
		["<leader>gt"] = {
			function()
				require("jdtls.tests").goto_subjects()
			end,
			"Goto Test Subjects",
		},
		["<leader>gtg"] = {
			function()
				require("jdtls.tests").generate()
			end,
			"Generate Tests",
		},

		-- Поддержка отладчика
		["<leader>db"] = { ":DapBreakpoint<CR>", "Toggle DAP Breakpoint" },
		["<leader>dc"] = { ":DapContinue<CR>", "DAP Continue" },
		["<leader>di"] = { ":DapStepInto<CR>", "DAP Step Into" },
		["<leader>do"] = { ":DapStepOver<CR>", "DAP Step Over" },
		["<leader>dr"] = { ":DapRepl<CR>", "DAP Repl" },
	},
}

