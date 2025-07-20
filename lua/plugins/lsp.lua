local servers = {
    "bashls",
    "clangd",
    "dockerls",
    "hls",
    "jsonls",
    "lua_ls",
    "nixd",
    "pylsp",
    "rust_analyzer",
    "taplo",
    "tinymist",
    "yamlls",
}
return {
    {
        "neovim/nvim-lspconfig",
        opts = function(_, opts)
            local keys = require("lazyvim.plugins.lsp.keymaps").get()
            keys[#keys + 1] = { "<space>de", vim.diagnostic.open_float }
            opts.servers = opts.servers or {}
            for _, s in ipairs(servers) do
                opts.servers[s] = opts.servers[s] or {}
                opts.servers[s].mason = false
            end
            opts.inlay_hints.exclude = { "rust" }
            opts.float = {
                border = "rounded",
                source = "if_mang",
            }

            return opts
        end,
    },
}
