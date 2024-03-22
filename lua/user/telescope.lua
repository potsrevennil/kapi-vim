local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
    vim.notify("telescope not loaded", vim.log.Error)
    return
end

local _, telescopeConfig = pcall(require, "telescope.config")

local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

table.insert(vimgrep_arguments, "--hidden")
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.git/*")

telescope.setup({
    defaults = {
        -- prompt_prefix = " ",
        -- selection_caret = " ",
        -- path_display = { "smart" },
        vimgrep_arguments = vimgrep_arguments,
    },
    pickers = {
        find_files = {
            -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
            find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
        },
        -- Default configuration for builtin pickers goes here:
        -- picker_name = {
        --   picker_config_key = value,
        --   ...
        -- }
        -- Now the picker_config_key will be applied every time you call this
        -- builtin picker
    },
})

vim.api.nvim_set_keymap("", "<leader>ff", ":Telescope find_files<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("", "<leader>fg", ":Telescope live_grep<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("", "<leader>fb", ":Telescope buffers<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("", "<leader>fh", ":Telescope help_tags<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("", "<leader>fr", ":Telescope resume<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("", "<leader>fl", ":Telescope lsp_references<cr>", { noremap = true, silent = true })
