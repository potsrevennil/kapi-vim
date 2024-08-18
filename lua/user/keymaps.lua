vim.g.mapleader = " "
local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set

keymap("", "<A-,>", "<C-o>", opts)

keymap(
    "n",
    "<Leader>dv",
    ":lua vim.diagnostic.config({virtual_text = not vim.diagnostic.config().virtual_text})<CR>",
    opts
)
keymap("n", "<Leader>dh", vim.diagnostic.hide, opts)
keymap("n", "<Leader>ds", vim.diagnostic.show, opts)
keymap("n", "<Leader>dl", vim.diagnostic.setqflist, opts)

keymap("n", "<Leader>qf", function()
    vim.lsp.buf.code_action({ only = quickfix })
end, opts)
keymap("n", "<Leader>rf", function()
    vim.lsp.buf.code_action({ only = refactor })
end, opts)

keymap("n", "<F2>", ":silent! source ./.session.vim<CR>", opts)
