return {
    "nvim-treesitter/nvim-treesitter",
    opts = {
        sync_install = false,
        autopairs = {
            enable = true,
        },
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        indent = { enable = true, disable = { "yaml" } },
    },
}
