local M = {}

function M.setup(opts)
    local status_ok, lspconfig = pcall(require, "lspconfig")
    if not status_ok then
        return
    end

    local servers = {
        "lua_ls",
        "bashls",
        "rust_analyzer",
        "gopls",
        "hls",
        "pylsp",
        "taplo",
        "yamlls",
        "jsonls",
        "dockerls",
    }

    for _, server in pairs(servers) do
        local require_ok, conf_opts = pcall(require, "user.lsp.settings."..server)
        if require_ok then
            opts = vim.tbl_deep_extend("force", conf_opts, opts)
        end
        lspconfig[server].setup(opts)
    end

    -- require("mason").setup({
    --     ui = {
    --         icons = {
    --             package_installed = "✓",
    --             package_pending = "➜",
    --             package_uninstalled = "✗",
    --         },
    --     },
    -- })
    -- require("mason-lspconfig").setup({
    --     ensure_installed = {
    --         "lua_ls",
    --         "bashls",
    --         "rust_analyzer",
    --         "gopls",
    --         "hls",
    --         "pylsp",
    --         "taplo",
    --         "yamlls",
    --         "jsonls",
    --         "dockerls",
    --     },
    -- })
    --
    -- require("mason-lspconfig").setup_handlers({
    --     function(server_name)
    --         local require_ok, conf_opts = pcall(require, "user.lsp.settings."..server_name)
    --         if require_ok then
    --             opts = vim.tbl_deep_extend("force", conf_opts, opts)
    --         end
    --         lspconfig[server_name].setup(opts)
    --     end,
    -- })
end

return M
