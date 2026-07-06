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

-- lazy.nvim defaults to stdpath("config")/lazy-lock.json, which isn't this
-- repo's lazy-lock.json for the nix-wrapped packages (they load via `-u
-- <store-path>/init.lua`, not via $XDG_CONFIG_HOME). Derive the real path
-- from this file's own location instead -- works either way.
local config_root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h:h")
local source_lockfile = config_root .. "/lazy-lock.json"

-- Normal usage: read/write that file directly, same as lazy.nvim's default.
-- Nix-wrapped usage: config_root is a read-only store path, so lazy.nvim
-- can't write its lockfile update there. Seed a writable copy once and
-- point lazy.nvim at that instead.
local lockfile = source_lockfile
if vim.fn.filewritable(config_root) ~= 2 then
    lockfile = vim.fn.stdpath("state") .. "/lazy-lock.json"
    if vim.fn.filereadable(lockfile) == 0 and vim.fn.filereadable(source_lockfile) == 1 then
        vim.fn.mkdir(vim.fn.fnamemodify(lockfile, ":h"), "p")
        vim.fn.writefile(vim.fn.readfile(source_lockfile), lockfile)
    end
end

lazy.setup({
    lockfile = lockfile,
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
            -- lazy.setup() rebuilds 'runtimepath' from scratch (reset, on by
            -- default), dropping config_root for the nix-wrapped packages
            -- since it's not "your config dir" as far as that reset is
            -- concerned. That silently broke both `{ import = "plugins" }`
            -- above and this repo's ftdetect/*.vim + filetype.lua (all
            -- resolved via a runtimepath scan, confirmed empirically: e.g.
            -- *.ec fell back to Neovim's built-in esqlc instead of this
            -- repo's easycrypt rule). `paths` re-adds it right after the
            -- reset, before specs are resolved.
            paths = { config_root },
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
