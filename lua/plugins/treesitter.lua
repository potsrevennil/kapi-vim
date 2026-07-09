return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            -- Languages this repo needs beyond LazyVim's own defaults
            -- (lazyvim.plugins.treesitter, opts_extend'd rather than
            -- replaced -- see lua/config/lazy.lua for import order).
            ensure_installed = {
                "asm",
                "cmake",
                "comment",
                "dockerfile",
                "git_config",
                "git_rebase",
                "gitcommit",
                "gitignore",
                "go",
                "gomod",
                "gosum",
                "haskell",
                "jq",
                "nix",
                "objdump",
                "ocaml",
                "rust",
                "sql",
                "typst",
            },
            indent = { enable = true, disable = { "yaml" } },
        },
    },
}
