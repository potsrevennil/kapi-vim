local M = {}

local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics

local sources = {
	null_ls.builtins.code_actions.gitsigns,
	formatting.prettierd.with({
		disabled_list = { "markdown", "yaml" },
		extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
	}),

	-- lua
	formatting.stylua,

	-- python
	formatting.yapf,
	-- formatting.black.with({ extra_args = { "--fast" } }),
	diagnostics.flake8,

	-- go
	formatting.gofmt,
	formatting.goimports,
	diagnostics.staticcheck,

	-- haskell
	formatting.brittany,

	-- rust
	formatting.rustfmt,

	-- shell
	formatting.shfmt.with({
		extra_args = { "-i", "2", "-ci" },
	}),

	-- solidity
	diagnostics.solhint,

	-- typescript
	formatting.eslint,

	-- dockerfile
	diagnostics.hadolint,
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
