local ls = require('luasnip')
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node

ls.add_snippets('python', {
    s('pprint', {
        t({'from pprint import pprint', 'pprint('}),
        i(1),
        t(')')
    }),
})

