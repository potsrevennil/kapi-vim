vim.g.mapleader = " "
local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

keymap("", "<A-,>", "<C-o>", opts)

keymap("n", "qf", ":lua vim.diagnostic.setqflist()<CR>", opts)

keymap("n", "ff", ":lua vim.lsp.buf.formatting()<CR>", opts)

keymap("n", "dv", ":lua vim.diagnostic.config({virtual_text = not vim.diagnostic.config().virtual_text})<CR>", opts)
