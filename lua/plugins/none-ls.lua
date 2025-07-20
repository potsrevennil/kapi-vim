return {
    "nvimtools/none-ls.nvim",
    opts = function()
        local null_ls = require("null-ls")
        local diagnostics = null_ls.builtins.diagnostics
        local code_actions = null_ls.builtins.code_actions
        local opts = {
            debug = false,
            sources = {
                -- go
                diagnostics.golangci_lint,
                -- nix
                diagnostics.deadnix,
                code_actions.statix,
            },
        }
        return opts
    end,
}
