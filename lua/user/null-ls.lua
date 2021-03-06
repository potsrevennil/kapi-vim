local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
	debug = false,
	sources = {
		null_ls.builtins.code_actions.gitsigns,
		formatting.prettierd.with({
			disabled_list = { "markdown", "yaml" },
			extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
		}),

		-- lua
		formatting.stylua,

		-- python
		-- formatting.yapf,
		formatting.black.with({ extra_args = { "--fast" } }),
		diagnostics.flake8,

		-- go
		formatting.gofmt,
		formatting.goimports,
		diagnostics.staticcheck,

		-- haskell
		formatting.brittany,

		-- rust
		-- formatting.rustfmt,

		-- shell
		formatting.shfmt,

		-- solidity
		diagnostics.solhint,

		-- typescript
		formatting.eslint,
	},
	on_attach = function(client, bufnr)
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
					vim.lsp.buf.formatting_sync()
				end,
			})
		end
	end,
})
