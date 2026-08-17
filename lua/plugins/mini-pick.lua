local function have(exe)
    return vim.fn.executable(exe) == 1
end

-- Run `fn` only if `exe` is on PATH; otherwise warn and no-op. Never errors --
-- mini.pick's matcher is pure Lua (no fzf), and the only external tools it can
-- use are rg/fd/git, so a missing tool should degrade to a notification, not a
-- stack trace. files() needs no guard (it falls back to a Lua directory walk).
local function guard(exe, purpose, fn)
    return function()
        if have(exe) then
            fn()
        else
            vim.notify(
                ("mini.pick: '%s' not found on PATH -- %s unavailable"):format(exe, purpose),
                vim.log.levels.WARN
            )
        end
    end
end

return {
    {
        "nvim-mini/mini.pick",
        dependencies = { "nvim-mini/mini.extra" },
        cmd = "Pick",
        opts = {},
        config = function(_, opts)
            require("mini.pick").setup(opts)
            require("mini.extra").setup() -- registers MiniExtra.pickers.*

            -- One-time, non-fatal advisory about missing optional CLI tools.
            -- Deferred so it never blocks startup; purely informational.
            vim.schedule(function()
                local optional = {
                    { "rg", "live grep + fast file listing" },
                    { "git", "git pickers (commits/status)" },
                }
                local missing = {}
                for _, t in ipairs(optional) do
                    if not have(t[1]) then
                        missing[#missing + 1] = ("%s (%s)"):format(t[1], t[2])
                    end
                end
                if #missing > 0 then
                    vim.notify(
                        "mini.pick: optional tools missing, related pickers will warn on use: "
                            .. table.concat(missing, ", "),
                        vim.log.levels.WARN
                    )
                end
            end)
        end,
        -- stylua: ignore
        -- Keymap scheme MIRRORS LazyVim's published layout (lhs + desc ported
        -- from extras/editor/telescope.lua) so muscle memory and LazyVim's
        -- cheatsheet still apply; only the RHS is swapped to mini.pick/extra.
        keys = {
            -- files (LazyVim: <leader><space> and <leader>ff both find files)
            { "<leader><space>", function() require("mini.pick").builtin.files() end, desc = "Find Files" },
            { "<leader>ff",      function() require("mini.pick").builtin.files() end, desc = "Find Files" },
            { "<leader>fb",      function() require("mini.pick").builtin.buffers() end, desc = "Buffers" },
            { "<leader>fr",      function() require("mini.extra").pickers.oldfiles() end, desc = "Recent Files" },
            -- grep (LazyVim: <leader>/ and <leader>sg both live-grep) -- guarded on rg
            { "<leader>/",  guard("rg", "live grep", function() require("mini.pick").builtin.grep_live() end), desc = "Grep (root)" },
            { "<leader>sg", guard("rg", "live grep", function() require("mini.pick").builtin.grep_live() end), desc = "Grep (root)" },
            -- search group (no external tool)
            { "<leader>sk", function() require("mini.extra").pickers.keymaps() end, desc = "Keymaps" },
            { "<leader>sh", function() require("mini.pick").builtin.help() end, desc = "Help Pages" },
            { "<leader>sR", function() require("mini.pick").builtin.resume() end, desc = "Resume" },
            { "<leader>sm", function() require("mini.extra").pickers.marks() end, desc = "Jump to Mark" },
            { "<leader>sd", function() require("mini.extra").pickers.diagnostic({ scope = "current" }) end, desc = "Document Diagnostics" },
            { "<leader>sD", function() require("mini.extra").pickers.diagnostic({ scope = "all" }) end, desc = "Workspace Diagnostics" },
            { "<leader>ss", function() require("mini.extra").pickers.lsp({ scope = "document_symbol" }) end, desc = "Goto Symbol" },
            { "<leader>sS", function() require("mini.extra").pickers.lsp({ scope = "workspace_symbol" }) end, desc = "Goto Symbol (Workspace)" },
            -- git (LazyVim: <leader>gc commits, <leader>gs status) -- guarded on git
            { "<leader>gc", guard("git", "git commits", function() require("mini.extra").pickers.git_commits() end), desc = "Git Commits" },
            { "<leader>gs", guard("git", "git status", function() require("mini.extra").pickers.git_files({ scope = "modified" }) end), desc = "Git Status" },
            -- colorscheme (LazyVim: <leader>uC) -- mini has no builtin; small custom source
            { "<leader>uC", function()
                require("mini.pick").start({ source = {
                    name = "Colorschemes",
                    items = vim.fn.getcompletion("", "color"),
                    choose = function(item) vim.cmd.colorscheme(item) end,
                } })
            end, desc = "Colorscheme" },
        },
    },
}
