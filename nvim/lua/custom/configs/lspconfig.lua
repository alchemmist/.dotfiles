local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")

-- if you just want default config for the servers then put them in a table
local servers = { "html", "cssls", "ts_ls", "clangd", "pyright", "lua_ls", "rust_analyzer", "eslint", "gopls" }

for _, lsp in ipairs(servers) do
	if lsp == "pyright" then
		lspconfig[lsp].setup({
			root_dir = function()
				return vim.loop.cwd()
			end,
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				python = {
					-- pythonPath = vim.fn.getcwd() .. "/venv/bin/python",
				},
			},
            format = {
                indentSize = 4,
                tabSize = 4
            }

		})
	else
		lspconfig[lsp].setup({
			on_attach = on_attach,
			capabilities = capabilities,
            format = {
                indentSize = 4,
                tabSize = 4
            }

		})
	end
end
