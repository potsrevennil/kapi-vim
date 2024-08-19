return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        {
            "nvim-telescope/telescope-live-grep-args.nvim",
            -- This will not install any breaking changes.
            -- For major updates, this must be adjusted manually.
            version = "^1.0.0",
        },
    },
    opts = function()
        local status_ok, telescopeConfig = pcall(require, "telescope.config")

        local vimgrep_arguments

        if status_ok then
            vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

            table.insert(vimgrep_arguments, "--hidden")
            table.insert(vimgrep_arguments, "--glob")
            table.insert(vimgrep_arguments, "!**/.git/*")
        end

        local opts = {
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
        }
        return opts
    end,
    config = function(_, opts)
        local telescope = require("telescope")
        telescope.setup(opts)
        telescope.load_extension("fzf")
        telescope.load_extension("live_grep_args")
    end,
    init = function()
        local builtin = require("telescope.builtin")
        vim.keymap.set("", "<leader>ff", builtin.find_files, { noremap = true, silent = true })
        vim.keymap.set(
            "",
            "<leader>fg",
            ":lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>",
            { noremap = true, silent = true }
        )
        vim.keymap.set("", "<leader>fb", builtin.buffers, { noremap = true, silent = true })
        vim.keymap.set("", "<leader>fh", builtin.help_tags, { noremap = true, silent = true })
        vim.keymap.set("", "<leader>fr", builtin.resume, { noremap = true, silent = true })
        vim.keymap.set("", "<leader>fl", builtin.lsp_references, { noremap = true, silent = true })
        vim.keymap.set("", "<leader>fw", builtin.grep_string, { noremap = true, silent = true })
    end,
}
