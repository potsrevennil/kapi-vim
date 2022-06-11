vim.g.mapleader = ' '
local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

keymap("", "<A-,>", "<C-o>", opts)

keymap("n", "<Space>qf", ":lua vim.diagnostic.setqflist()<CR>", opts)
