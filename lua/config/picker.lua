-- Makes mini.pick LazyVim's one and only picker. Called from lazy.lua while
-- specs are being resolved (see the comment there for why that spot).
local M = {}

-- Backend for LazyVim.pick(), which LazyVim calls on its own (dashboard
-- "Find File"/"Find Text"/"Recent Files", <leader>fc, ...).
---@type LazyPicker
M.picker = {
    name = "mini.pick",
    -- LazyVim's command names -> mini.pick/mini.extra picker names
    commands = {
        find_files = "files",
        live_grep = "grep_live",
    },
    open = function(command, opts)
        local source = { cwd = opts and opts.cwd }
        local fn = require("mini.pick").builtin[command] or require("mini.extra").pickers[command]
        if not fn then
            return LazyVim.warn(("LazyVim.pick: mini.pick has no `%s` picker"):format(command))
        end
        fn(nil, { source = source })
    end,
}

function M.setup()
    -- Turn off whichever picker extra LazyVim chose as the default. Its
    -- import hook skips any default extra marked disabled, and xtras only
    -- adds the enabled ones -- LazyVim's own mechanism, just with none left
    -- on for the picker group.
    for _, extra in pairs(LazyVim.config.get_defaults()) do
        if extra.group == "picker" then
            extra.enabled = false
        end
    end
    LazyVim.pick.register(M.picker)
end

return M
