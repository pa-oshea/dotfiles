require('which-key').setup()
require('lualine').setup()
require('symbols-outline').setup()
require('Comment').setup()

local lsp = require('lsp-zero')

lsp.preset('recommended')
lsp.ensure_installed({
    'sumneko_lua',
})
lsp.nvim_workspace()
lsp.setup()

require("indent_blankline").setup {
    show_end_of_line = true,
    space_char_blankline = " ",
}

vim.cmd(":TSInstall all"); -- figure out the point of this
