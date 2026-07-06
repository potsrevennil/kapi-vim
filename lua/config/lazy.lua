local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if vim.fn.isdirectory(lazypath) == 0 then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
    vim.notify("lazy.nvim is not loaded", vim.log.Error)
    return
end

lazy.setup({
    spec = {
        -- LazyVim itself, pinned. `import = "lazyvim.plugins"` used to pull in
        -- every lazyvim/plugins/*.lua module implicitly in one line; listed
        -- explicitly below instead so each future removal is a one-line diff,
        -- not an opaque blanket import. No functional change: this is the
        -- exact same set of modules `lazyvim.plugins` would have imported
        -- (verified by diffing the synced lazy-lock.json plugin list before
        -- and after this change).
        { "LazyVim/LazyVim", version = "v15.14.0" },
        { import = "lazyvim.plugins.init" },
        { import = "lazyvim.plugins.coding" },
        { import = "lazyvim.plugins.colorscheme" },
        { import = "lazyvim.plugins.editor" },
        { import = "lazyvim.plugins.formatting" },
        { import = "lazyvim.plugins.linting" },
        { import = "lazyvim.plugins.lsp" },
        { import = "lazyvim.plugins.treesitter" },
        { import = "lazyvim.plugins.ui" },
        { import = "lazyvim.plugins.util" },
        { import = "lazyvim.plugins.xtras" },
        { import = "lazyvim.plugins.extras.editor.telescope" },
        { import = "lazyvim.plugins.extras.coding.nvim-cmp" },
        { import = "lazyvim.plugins.extras.coding.luasnip" },
        { import = "lazyvim.plugins.extras.lsp.none-ls" },
        -- import/override with your plugins
        { import = "plugins" },
    },
    checker = {
        enabled = true, -- check for plugin updates periodically
        notify = false, -- notify on update
    }, -- automatically check for plugin updates
    performance = {
        rtp = {
            -- disable some rtp plugins
            disabled_plugins = {
                "gzip",
                -- "matchit",
                -- "matchparen",
                -- "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})
