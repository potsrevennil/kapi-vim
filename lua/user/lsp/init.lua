local M = {}

function M.on_attach(client, bufnr)
	-- Enable completion triggered by <C-X><C-O>
	-- See `:help omnifunc` and `:help ins-completion` for more information.
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Use LSP as the handler for formatexpr.
	-- See `:help formatexpr` for more information.
	vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")

	-- Configure key mappings
	require("user.lsp.keymaps").setup(bufnr)

	-- Configure highlighting
	require("user.lsp.highlighter").setup(client)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local opts = {
	on_attach = M.on_attach,
	capabilities = M.capabilities,
	flags = {
		debounce_text_changes = 150,
	},
}

-- Setup LSP config
require("user.lsp.handler").setup()

function M.setup()
	-- Installer
	require("user.lsp.installer").setup(opts)
end

return M
