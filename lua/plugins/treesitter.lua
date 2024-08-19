return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
        ensure_installed = {
            "vimdoc",
            "luadoc",
            "vim",
            "lua",
        },
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
