return {
    "nvimtools/none-ls.nvim",
    opts = function()
        local null_ls = require("null-ls")
        local diagnostics = null_ls.builtins.diagnostics
        local code_actions = null_ls.builtins.code_actions
        local opts = {
            debug = false,
            sources = {
                -- go: golangci-lint comes from the project's devShell; skip
                -- it (rather than erroring on spawn) where it isn't on PATH.
                diagnostics.golangci_lint.with({
                    runtime_condition = function()
                        return vim.fn.executable("golangci-lint") == 1
                    end,
                }),
                -- nix
                diagnostics.deadnix,
                code_actions.statix,
            },
        }
        return opts
    end,
}
