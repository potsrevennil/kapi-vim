local function is_null_ls_formatting_enabled(bufnr)
    local file_type = vim.bo[bufnr].filetype
    local generators =
        require("null-ls.generators").get_available(file_type, require("null-ls.methods").internal.FORMATTING)
    return #generators > 0
end

return {
    "nvimtools/none-ls.nvim",
    opts = function()
        local null_ls = require("null-ls")
        local formatting = null_ls.builtins.formatting
        local diagnostics = null_ls.builtins.diagnostics
        local code_actions = null_ls.builtins.code_actions
        local opts = {
            debug = false,
            sources = {
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
                formatting.black.with({ extra_args = { "--fast" } }),

                -- go
                formatting.goimports,
                diagnostics.golangci_lint,

                -- shell
                formatting.shfmt.with({
                    extra_args = { "-s", "-i", "2", "-ci", "-fn" },
                }),

                diagnostics.codespell,

                -- c
                formatting.astyle,

                -- nix
                formatting.nixpkgs_fmt,
                diagnostics.deadnix,
                code_actions.statix,
            },
            save_after_format = true,
            on_attach = function(client, buf)
                if client.server_capabilities.documentFormattingProvider then
                    if client.name == "null-ls" and is_null_ls_formatting_enabled(buf) or client.name ~= "null-ls" then
                        vim.bo[buf].formatexpr = "v:lua.vim.lsp.formatexpr()"
                        vim.keymap.set(
                            "n",
                            "<leader>gq",
                            "<cmd>lua vim.lsp.buf.format({ async = true })<CR>",
                            { noremap = true, silent = true, buffer = buf }
                        )
                    else
                        vim.bo[buf].formatexpr = nil
                    end

                    local augroup = vim.api.nvim_create_augroup("LspFormat", {})
                    vim.api.nvim_clear_autocmds({ group = augroup, buffer = buf })
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = augroup,
                        buffer = buf,
                        callback = function()
                            vim.lsp.buf.format()
                        end,
                    })
                end
            end,
        }
        return opts
    end,
}
