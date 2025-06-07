local servers = {
    "lua_ls",
    "bashls",
    "rust_analyzer",
    "gopls",
    "hls",
    "pylsp",
    "taplo",
    "yamlls",
    "jsonls",
    "dockerls",
    "nixd",
    "tinymist",
    "clangd",
    "lean",
}

local user = {}

function user.init()
    local config = {
        -- disable virtual text
        virtual_text = { severity = vim.diagnostic.severity.ERROR },
        -- show signs
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = '"',
                [vim.diagnostic.severity.WARN] = " ",
                [vim.diagnostic.severity.INFO] = " ",
                [vim.diagnostic.severity.HINT] = " ",
            },
        },
        severity_sort = true,
        float = {
            border = "rounded",
            source = "if_many",
        },
    }

    vim.diagnostic.config(config)

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.buf.hover({
        border = "rounded",
    })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.buf.signature_help({
        border = "rounded",
    })
end

function user.keymap(eb)
    local keymap = function(mode, lhs, rhs, desc, buf)
        vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, buffer = buf, desc = desc })
    end

    -- key mapping
    keymap("n", "<space>e", vim.diagnostic.open_float, "vim.diagnostic.open_float")
    keymap("n", "<space>q", vim.diagnostic.setloclist, "vim.diagnostic.setloclist")

    keymap("n", "<space>.", vim.lsp.buf.definition, "vim.lsp.buf.definition", eb)
    keymap("n", "<space>k", vim.lsp.buf.hover, "Hover", eb)
    keymap("n", "gd", vim.lsp.buf.definition, "Definition", eb)
    keymap("n", "gD", vim.lsp.buf.declaration, "Declaration", eb)
    keymap("n", "gi", vim.lsp.buf.implementation, "Implementation", eb)
    keymap("n", "go", vim.lsp.buf.type_definition, "Type definition", eb)
    keymap("n", "<space>rn", vim.lsp.buf.rename, "Rename", eb)
    keymap("n", "gra", vim.lsp.buf.code_action, "Code action", eb)
    keymap("n", "grr", vim.lsp.buf.references, "References", eb)
end

-- semantic highlight
function user.highlight(client, buf)
    if client.supports_method("textDocument/documentHighlight") then
        local group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
        vim.api.nvim_clear_autocmds({ buffer = buf, group = group })
        vim.api.nvim_create_autocmd("CursorHold", {
            group = group,
            buffer = buf,
            callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd("CursorMoved", {
            group = group,
            buffer = buf,
            callback = vim.lsp.buf.clear_references,
        })
    end
end

return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "Julian/lean.nvim",
    },
    opts = {
        capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
        flags = {
            debounce_text_changes = 150,
        },
    },
    init = user.init,
    config = function(_, opts)
        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(event)
                user.keymap(event.buf)

                local client = vim.lsp.get_client_by_id(event.data.client_id)
                if client == nil then
                    return
                end

                user.highlight(client, event.buf)
            end,
        })

        -- lspconfig
        for _, server in ipairs(servers) do
            local lsp_ok, lsp = pcall(function()
                if server == "lean" then
                    return require("lean")
                else
                    return require("lspconfig")[server]
                end
            end)
            if not lsp_ok then
                vim.notify("server config " .. server .. " not found.", vim.log.WARN)
                return
            end

            if server ~= "lean" then
                vim.lsp.config(server, { settings = { [server] = {} } })
                vim.lsp.enable(server)
            else
                lsp.setup(opts)
            end
        end
    end,
}
