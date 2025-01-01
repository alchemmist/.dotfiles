local null_ls = require("null-ls")

local b = null_ls.builtins

local sources = {

	-- webdev stuff
	b.formatting.prettier, -- choosed deno for ts/js files cuz its very fast!
	b.diagnostics.eslint_d,
	-- Lua
	b.formatting.stylua,
	-- Python
	b.formatting.black,
	-- Latex
	b.formatting.latexindent,

	-- cpp
	b.formatting.clang_format,
}

null_ls.setup({
	debug = true,
	sources = sources,
})
