local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

keymap("", "<A-,>", "<C-o>", opts)

function enable_plugin(p)
    local status_ok, _ = require("user." .. p)
    if not status_ok then
        vim.notify(p .. " can not be enabled", vim.log.levels.WARN)
    end
end

vim.api.nvim_create_user_command("Show", function()
    local ps = {'gitsigns', 'bufferline', 'lsp', 'telescope'}
    for _, p in ipairs(ps) do
        enable_plugin(p)
    end

end, {})

keymap("n", "<leader>s", ":Show<CR>", opts)

vim.api.nvim_set_keymap("", "<leader>ff", ":Telescope find_files<CR>", opts)
vim.api.nvim_set_keymap("", "<leader>fg", ":Telescope live_grep<CR>", opts)
vim.api.nvim_set_keymap("", "<leader>fb", ":Telescope buffers<CR>", opts)
vim.api.nvim_set_keymap("", "<leader>fh", ":Telescope help_tags<CR>", opts)
vim.api.nvim_set_keymap("", "<leader>fr", ":Telescope resume<CR>", opts)
