local opt = vim.opt

opt.clipboard = "unnamedplus"
opt.relativenumber = true
opt.cursorline = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

opt.scrolloff=15

opt.smartindent = true
opt.wrap = true

opt.hlsearch = false
opt.incsearch = true

opt.list = true
-- vim.opt.listchars:append "space:⋅"
opt.listchars:append "eol:↴"
-- opt.termguicolors = true

vim.g.mapleader = " "
