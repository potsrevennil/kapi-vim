local M = {}
local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
    vim.notify("lazy.nvim is not loaded", vim.log.Error)
    return
end

function M.setup(plugins)
    require("lazy").setup(plugins, M.opts)
end

M.opts = {
    defaults = {
        lazy = true,
        version = "*",
    },
}

lazy.setup("plugins")
