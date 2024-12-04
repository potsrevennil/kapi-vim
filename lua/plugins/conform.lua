return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
        formatters_by_ft = {
            lua = { "stylua" },
            sh = { "shfmt", "shellcheck" },
            nix = { "nixpkgs_fmt" },
            python = { "black" },
            go = { "goimports" },
            c = { "clang-format" },
            typst = { "typstyle" },
            toml = { "taplo" },
            ["*"] = { "codespell" },
            ["_"] = { "trim_whitespace", "trim_newlines" },
        },
        default_format_opts = {
            lsp_format = "fallback",
        },
        log_level = vim.log.levels.DEBUG,
        format_on_save = function(buf)
            if vim.g.disable_autoformat or vim.b[buf].disable_autoformat then
                return
            end
            return {}
        end,
        formatters = {
            shfmt = {
                args = { "-s", "-i", "2", "-ci", "-fn", "-filename", "$FILENAME" },
            },
            black = {
                prepend_args = { "--fast" },
            },
        },
    },
    config = function(_, opts)
        require("conform").setup(opts)

        vim.api.nvim_create_user_command("FormatToggle", function()
            vim.g.disable_autoformat = not vim.g.disable_autoformat
            vim.b.disable_autoformat = not vim.b.disable_autoformat
            print(vim.g.disable_autoformat)
            print(vim.b.disable_autoformat)
        end, { desc = "Disable format on save" })
    end,
    init = function()
        -- If you want the formatexpr, here is the place to set it
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
}
