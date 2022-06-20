vim.g.mapleader = " "
local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

keymap("", "<A-,>", "<C-o>", opts)

keymap("n", "qf", ":lua vim.diagnostic.setqflist()<CR>", opts)

keymap("n", "ff", ":lua vim.lsp.buf.formatting()<CR>", opts)

keymap("n", "dv", ":lua vim.diagnostic.config({virtual_text = not vim.diagnostic.config().virtual_text})<CR>", opts)
keymap("n", "do", ":lua vim.diagnostic.open_float()<CR>", opts)
keymap("n", "dh", ":lua vim.diagnostic.hide()<CR>", opts)
keymap("n", "ds", ":lua vim.diagnostic.show()<CR>", opts)
