local M = {}

M.autoformat = true

function M.format(bufnr)
    if M.autoformat then
        vim.lsp.buf.format({ bufnr = bufnr })
    end
end

function M.setup(client, bufnr)
    local enable = true
    client.server_capabilities.documentFormattingProvider = enable
    client.server_capabilities.documentRangeFormattingProvider = enable

    if client.server_capabilities.documentFormattingProvider then
        local lsp_format_grp = vim.api.nvim_create_augroup("LspFormat", { clear = true })
        vim.api.nvim_create_autocmd("BufWritePre", {
            callback = function()
                M.format(bufnr)
            end,
            group = lsp_format_grp,
            buffer = bufnr,
        })
    end
end

return M
