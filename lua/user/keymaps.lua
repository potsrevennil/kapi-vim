vim.g.mapleader = " "
local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

keymap("", "<A-,>", "<C-o>", opts)

keymap("n", "<Leader>ff", ":lua vim.lsp.buf.formatting()<CR>", opts)

keymap(
	"n",
	"<Leader>dv",
	":lua vim.diagnostic.config({virtual_text = not vim.diagnostic.config().virtual_text})<CR>",
	opts
)
keymap("n", "<Leader>do", ":lua vim.diagnostic.open_float()<CR>", opts)
keymap("n", "<Leader>dh", ":lua vim.diagnostic.hide()<CR>", opts)
keymap("n", "<Leader>ds", ":lua vim.diagnostic.show()<CR>", opts)
keymap("n", "<Leader>dl", ":lua vim.diagnostic.setqflist()<CR>", opts)

keymap("n", "<Leader>qf", ":lua vim.lsp.buf.code_action({only=quickfix})<CR>", opts)
keymap("n", "<Leader>rf", ":lua vim.lsp.buf.code_action({only=refactor})<CR>", opts)

keymap("n", "<F2>", ":silent! source ./.session.vim<CR>", opts)
