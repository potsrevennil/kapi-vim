return {
    "stevearc/conform.nvim",
    opts = {
        formatters_by_ft = {
            lua = { "stylua" },
            sh = { "shfmt", "shellcheck" },
            nix = { "nixpkgs_fmt" },
            python = { "black" },
            go = { "goimports" },
            c = { "clang-format" },
            cpp = { "clang-format" },
            typst = { "typstyle" },
            toml = { "taplo" },
            rust = { "rustfmt", lsp_format = "fallback" },
            haskell = { "ormolu" },
            ["*"] = { "codespell" },
            ["_"] = { "trim_whitespace", "trim_newlines" },
        },
        default_format_opts = {
            lsp_format = "fallback",
        },
        log_level = vim.log.levels.DEBUG,
        -- Per-language formatters (black, goimports, clang-format, ...) come
        -- from each project's devShell, so outside one they are expected to
        -- be missing; don't warn about it, same as Neovim does for servers.
        notify_no_formatters = false,
        formatters = {
            shfmt = {
                args = { "-s", "-i", "2", "-ci", "-fn", "-filename", "$FILENAME" },
            },
            black = {
                prepend_args = { "--fast" },
            },
        },
    },
}
