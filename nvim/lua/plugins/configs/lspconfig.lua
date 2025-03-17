dofile(vim.g.base46_cache .. "lsp")
require("nvchad.lsp")

local M = {}

local servers = { "html", "cssls", "ts_ls", "clangd", "pyright", "lua_ls", "rust_analyzer", "eslint", "gopls" }

local utils = require("core.utils")

-- export on_attach & capabilities for custom lspconfigs

local cmp = require("cmp")
local lspconfig = require("lspconfig")
local mason_status, mason = pcall(require, "mason-registry")


M.on_attach = function(client, bufnr)
	client.server_capabilities.documentFormattingProvider = false
	client.server_capabilities.documentRangeFormattingProvider = false

	utils.load_mappings("lspconfig", { buffer = bufnr })

	-- if client.server_capabilities.signatureHelpProvider then
	--   require("nvchad.signature").setup(client)
	-- end

	if not utils.load_config().ui.lsp_semantic_tokens and client.supports_method("textDocument/semanticTokens") then
		client.server_capabilities.semanticTokensProvider = nil
	end
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem = {
	documentationFormat = { "markdown", "plaintext" },
	snippetSupport = true,
	preselectSupport = true,
	insertReplaceSupport = true,
	labelDetailsSupport = true,
	deprecatedSupport = true,
	commitCharactersSupport = true,
	tagSupport = { valueSet = { 1 } },
	resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
		},
	},
}

vim.diagnostic.config({
	virtual_text = false, -- Отключаем текст ошибок
	signs = false, -- Оставляем иконки (красный крестик)
	update_in_insert = false,
	underline = true,
	severity_sort = true,
	open_loclist = true,
})

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_attach = M.on_attach,
		capabilities = M.capabilities,
		format = {
			indentSize = 4,
			tabSize = 4,
		},
	})
end

lspconfig.lua_ls.setup({
	on_attach = M.on_attach,
	capabilities = M.capabilities,

	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
					[vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types"] = true,
					[vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy"] = true,
				},
				maxPreload = 100000,
				preloadFileSize = 10000,
			},
		},
	},
})

-- Настройка автодополнения с nvim-cmp
cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" }, -- Сниппеты (если используются)
	}, {
		{ name = "buffer" },
		{ name = "path" },
	}),
})

-- Настройка LSP для Go (gopls)
lspconfig.gopls.setup({
	on_attach = function(client, bufnr)
		-- Настройка диагностики
		vim.diagnostic.config({
			virtual_text = false, -- Отключаем виртуальный текст с ошибками
			signs = true, -- Отключаем знаки (крестик)
			underline = true, -- Включаем подчеркивание
			update_in_insert = false,
			severity_sort = true, -- Сортировка по важности
		})
		vim.o.splitright = false
		vim.o.splitbelow = false
	end,
})

-- local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
--
-- local JDTLS_PATH = mason.get_package("jdtls"):get_install_path()
-- print(os.getenv("XDG_DATA_HOME"))
-- print(project_name)
-- local JDTLS_DATA = os.getenv("XDG_DATA_HOME") .. "/jdtls/" .. project_name


lspconfig.jdtls.setup({
	cmd = { "jdtls" },
    -- cmd = {
    --     "java",
    --     "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    --     "-Dosgi.bundles.defaultStartLevel=4",
    --     "-Declipse.product=org.eclipse.jdt.ls.core.product",
    --     "-Dlog.protocol=true",
    --     "-Dlog.level=ALL",
    --     "-javaagent:" .. JDTLS_PATH .. "/lombok.jar",
    --     "-Xmx1g",
    --     "--add-modules=ALL-SYSTEM",
    --     "--add-opens",
    --     "java.base/java.util=ALL-UNNAMED",
    --     "--add-opens",
    --     "java.base/java.lang=ALL-UNNAMED",
    --
    --     "-jar",
    --     vim.fn.glob(JDTLS_PATH .. "/plugins/org.eclipse.equinox.launcher_*.jar", true),
    --
    --     "-configuration",
    --     JDTLS_PATH .. "/config_linux",
    --
    --     "-data",
    --     JDTLS_DATA,
    -- },


	root_dir = require("lspconfig.util").root_pattern("pom.xml", "build.gradle", ".git"),
	settings = {
		java = {
			format = {
				enabled = true,
				settings = {
					tabSize = 4,
					indentSize = 4,
					insertSpaces = true,
				},
			},
			imports = {
				gradle = {
					wrapper = {
						checksums = {
							{
								sha256 = "81a82aaea5abcc8ff68b3dfcb58b3c3c429378efd98e7433460610fecd7ae45f",
								allowed = true,
							},
						},
					},
				},
			},
		},
	},
	on_attach = function(client, bufnr)
		vim.bo[bufnr].shiftwidth = 4
		vim.bo[bufnr].expandtab = true
	end,
})

require("lspconfig").coq_lsp.setup({})

return M
