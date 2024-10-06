return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
        ensure_installed = {
            "asm",
            "bash",
            "c",
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
            "html",
            "javascript",
            "jq",
            "json",
            "lua",
            "luadoc",
            "nix",
            "objdump",
            "ocaml",
            "python",
            "rust",
            "sql",
            "toml",
            "typst",
            "vim",
            "vimdoc",
            "yaml",
        },
        sync_install = false,
        auto_install = true,
        autopairs = {
            enable = true,
        },
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        indent = { enable = true, disable = { "yaml" } },
    },
    config = function(_, opts)
        local config = require("nvim-treesitter.parsers").get_parser_configs()
        config.jasmin = {
            install_info = {
                url = "https://github.com/y4cer/tree-sitter-jasmin",
                files = { "src/parser.c" },
                generate_requires_npm = false,
                requires_generate_from_grammar = false,
            },
        }

        require("nvim-treesitter.configs").setup(opts)
    end,
}
