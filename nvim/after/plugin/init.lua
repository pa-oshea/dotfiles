require('which-key').setup()
require('lualine').setup()

vim.opt.list = true
-- vim.opt.listchars:append "space:⋅"
vim.opt.listchars:append "eol:↴"

require("indent_blankline").setup {
    show_end_of_line = true,
    space_char_blankline = " ",
}

vim.cmd(":TSInstall all"); -- figure out the point of this
