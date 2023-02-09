local M = {}

function M.setup(opts)
	local status_ok, lspconfig = pcall(require, "lspconfig")
	if not status_ok then
		return
	end

	require("mason").setup({
		ui = {
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
	})
	require("mason-lspconfig").setup({
		ensure_installed = {
			"sumneko_lua",
			"bashls",
			"rust_analyzer",
			"gopls",
			"hls",
			"pylsp",
			"taplo",
			"yamlls",
			"jsonls",
			"dockerls",
		},
	})

	require("mason-lspconfig").setup_handlers({
		function(server_name)
			if server_name == "sumneko_lua" then
				local sumneko_opts = require("user.lsp.settings.sumneko_lua")
				opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
			end

			if server_name == "rust_analyzer" then
				local rust_opts = require("user.lsp.settings.rust_analyzer")
				opts = vim.tbl_deep_extend("force", rust_opts, opts)
			end

			lspconfig[server_name].setup(opts)
		end,
	})
end

return M
