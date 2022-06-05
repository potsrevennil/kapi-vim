local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

keymap("", "<A-,>", "<C-o>", opts)

vim.api.nvim_create_user_command(
	"Show",
	"echo 'enable gitsigns and bufferline'",
	{ desc = "Show gitsigns and bufferlines" }
)

keymap("", "<S-s>", ":Show<cr>", opts)
