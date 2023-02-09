local M = {}

local keymap = vim.keymap.set

local function lsp_keymaps(bufnr)
	local opts = { noremap = true, silent = true }

	keymap("n", "[d", function()
		vim.diagnostic.goto_prev({ border = "rounded" })
	end, opts)
	keymap("n", "]d", function()
		vim.diagnostic.goto_next({ border = "rounded" })
	end, opts)
	keymap("n", "<space>e", vim.diagnostic.open_float, opts)
	keymap("n", "<space>q", vim.diagnostic.setloclist, opts)

	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	keymap("n", "<leader>d", vim.lsp.buf.declaration, bufopts)
	keymap("n", "<space>.", vim.lsp.buf.definition, bufopts)
	keymap("n", "<space>k", vim.lsp.buf.hover, bufopts)
	keymap("n", "gi", vim.lsp.buf.implementation, bufopts)
	keymap("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
	keymap("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
	keymap("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
	keymap("n", "<space>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
	keymap("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
	keymap("n", "<space>rn", vim.lsp.buf.rename, bufopts)
	keymap("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
	keymap("n", "gr", vim.lsp.buf.references, bufopts)
	keymap("n", "<space>f", function()
		vim.lsp.buf.format({
			filter = function(client)
				return client.name == "null-ls"
			end,
			bufnr = bufnr,
		})
	end, bufopts)
end

function M.setup(bufnr)
	lsp_keymaps(bufnr)
end

return M
