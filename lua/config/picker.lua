-- mini.pick as the backend for LazyVim.pick(), which LazyVim calls on its own
-- (dashboard "Find File"/"Find Text"/"Recent Files", <leader>fc, ...). Without
-- this those would fall through to whichever picker extra LazyVim auto-enables.
-- Loaded from lazy.lua, before lazyvim.plugins.xtras: LazyVim.pick.register()
-- only takes effect while specs are being resolved at startup.

---@type LazyPicker
local picker = {
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

LazyVim.pick.register(picker)
