local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
	return
end

local M = {}

M.setup = function()
	local signs = {
		{ name = "DiagnosticSignError", text = "" },
		{ name = "DiagnosticSignWarn", text = "" },
		{ name = "DiagnosticSignHint", text = "" },
		{ name = "DiagnosticSignInfo", text = "" },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

	local config = {
		-- disable virtual text
		virtual_text = false,
		-- show signs
		signs = {
			active = signs,
		},
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focusable = false,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	}

	vim.diagnostic.config(config)

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
	})

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "rounded",
	})
end

local function lsp_highlight_document(client)
	-- Set autocommands conditional on server_capabilities
	if client.server_capabilities.document_highlight then
		vim.api.nvim_exec(
			[[
                augroup lsp_document_highlight
                    autocmd! * <buffer>
                    autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                    autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
                augroup END
        ]],
			false
		)
	end
end

local function lsp_keymaps(bufnr)
	local function buf_set_keymap(...)
		vim.keymap.set(...)
	end

	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Mappings.
	local opts = { noremap = true, silent = true }
	buf_set_keymap("n", "<space>e", vim.diagnostic.open_float, opts)
	buf_set_keymap("n", "[d", function()
		vim.diagnostic.goto_prev({ border = "rounded" })
	end, opts)
	buf_set_keymap("n", "]d", function()
		vim.diagnostic.goto_next({ border = "rounded" })
	end, opts)
	buf_set_keymap("n", "<space>q", vim.diagnostic.setloclist, opts)

	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	buf_set_keymap("n", "<leader>d", vim.lsp.buf.declaration, bufopts)
	buf_set_keymap("n", "<space>.", vim.lsp.buf.definition, bufopts)
	buf_set_keymap("n", "<space>k", vim.lsp.buf.hover, bufopts)
	buf_set_keymap("n", "gi", vim.lsp.buf.implementation, bufopts)
	buf_set_keymap("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
	buf_set_keymap("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
	buf_set_keymap("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
	buf_set_keymap("n", "<space>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
	buf_set_keymap("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
	buf_set_keymap("n", "<space>rn", vim.lsp.buf.rename, bufopts)
	buf_set_keymap("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
	buf_set_keymap("n", "gr", vim.lsp.buf.references, bufopts)
	buf_set_keymap("n", "<space>f", function()
		vim.lsp.buf.format({ async = true })
	end, bufopts)
end

M.on_attach = function(client, bufnr)
	if client.name == "tsserver" then
		client.server_capabilities.documentFormattingProvider = false
	end

	if client.name == "sumneko_lua" then
		client.server_capabilities.documentFormattingProvider = false
	end

	if client.name == "gopls" then
		client.server_capabilities.documentFormattingProvider = false
	end

	if client.name == "pylsp" then
		client.server_capabilities.documentFormattingProvider = false
	end

	lsp_keymaps(bufnr)
	lsp_highlight_document(client)
end

return M
