-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.snacks_animate = false
-- vim.o.fillchars = { vert = "│", eob = " ", fold = " ", diff = " ", foldopen = "", foldclose = "" }
-- vim.o.fillchars = "vert:│,eob: ,fold: ,diff: ,foldopen:,foldclose:"

vim.o.backup = true -- enable backup
vim.o.backupcopy = "yes" -- make a copy of the file and overwrite the original
vim.o.backupdir = vim.fn.stdpath("data") .. "/backup"
vim.o.undofile = true -- persistent undoopt
vim.o.undolevels = 10000
vim.o.undodir = vim.fn.stdpath("data") .. "/undo"

vim.g.rooter_manual_only = 1
