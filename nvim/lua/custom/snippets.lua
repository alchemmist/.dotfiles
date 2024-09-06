local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node

ls.add_snippets("python", {
	s("pprint", {
		t({ "from pprint import pprint", "pprint(" }),
		i(1),
		t(")"),
	}),
})

ls.add_snippets("tex", {
	s("not", {
		t({ "\\overline{" }),
		i(1),
		t("}"),
	}),
})

ls.add_snippets("tex", {
	s("fr", {
		t({ "\\frac{" }),
		i(1),
		t("}{"),
		i(2),
		t("}"),
	}),
})

ls.add_snippets("tex", {
	s("an", {
		t({ "\\begin{align}", "\t" }),
		i(1),
		t({ "", "\\end{align}" }),
	}),
})


ls.add_snippets("tex", {
	s("a", {
		t({ "\\begin{align*}", "\t" }),
		i(1),
		t({ "", "\\end{align*}" }),
	}),
})

ls.add_snippets("tex", {
	s("div", {
		t("\\ \\vdots \\ "),
        i(1)
	}),
})

ls.add_snippets("tex", {
	s(">=", {
		t("\\geqslant "),
        i(1)
	}),
})

ls.add_snippets("tex", {
	s("<=", {
		t("\\eqslantless "),
        i(1)
	}),
})

ls.add_snippets("tex", {
	s("<=>", {
		t("\\Leftrightarrow "),
        i(1)
	}),
})
