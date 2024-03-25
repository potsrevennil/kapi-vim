local M = {}

local status_ok, null_ls = pcall(require, "null-ls")
if not status_ok then
    vim.notify("null_ls not loaded", vim.log.levels.ERROR)
    return
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

local sources = {
    formatting.prettierd.with({
        disabled_list = { "markdown", "yaml" },
        extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
    }),

    -- NOTE:
    -- tmp comment out
    -- as default config required commitlint-format-json, but the npm package cannot be found in nixpkgs
    --
    -- -- git commit
    -- diagnostics.commitlint,

    -- typst
    formatting.typstfmt,

    -- lua
    formatting.stylua,

    -- python
    formatting.yapf,
    -- formatting.black.with({ extra_args = { "--fast" } }),
    diagnostics.flake8,

    -- go
    formatting.goimports,
    diagnostics.golangci_lint,

    -- haskell
    formatting.brittany,

    -- rust
    formatting.rustfmt,

    -- shell
    formatting.shfmt.with({
        extra_args = { "-s", "-i", "2", "-ci", "-fn" },
    }),

    diagnostics.codespell,

    formatting.astyle,
}

function M.setup(opts)
    null_ls.setup({
        debug = false,
        sources = sources,
        save_after_format = true,
        on_attach = opts.on_attach,
    })
end

return M
