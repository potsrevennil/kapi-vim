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

-- LazyVim's git log keymaps open Snacks.picker, a third picker UI; point them at
-- mini.extra so they look like every other picker. (<leader>gb, blame line,
-- has no mini equivalent and stays on Snacks.)
-- stylua: ignore start
keymap("n", "<leader>gl", function() require("mini.extra").pickers.git_commits({ path = LazyVim.root.git() }) end, { desc = "Git Log" })
keymap("n", "<leader>gL", function() require("mini.extra").pickers.git_commits({ path = vim.fn.getcwd() }) end, { desc = "Git Log (cwd)" })
keymap("n", "<leader>gf", function() require("mini.extra").pickers.git_commits({ path = vim.api.nvim_buf_get_name(0) }) end, { desc = "Git Current File History" })
-- stylua: ignore end
