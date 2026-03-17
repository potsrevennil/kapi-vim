return {
    {
        "neovim/nvim-lspconfig",
        opts = function(_, opts)
            ---@class PluginLspOpts
            local ret = vim.tbl_deep_extend("force", opts, {
                inlay_hints = {
                    enabled = true,
                    exclude = { "rust" },
                },
                float = {
                    border = "rounded",
                    source = "if_mang",
                },
                servers = {
                    bashls = {},
                    clangd = {},
                    hls = {},
                    nixd = {},
                    pylsp = {},
                    rust_analyzer = dofile(vim.fn.stdpath("config") .. "/lsp/rust_analyzer.lua"),
                    taplo = {},
                    tinymist = {},
                    yamlls = {},
                },
            })

            return ret
        end,
    },
}
