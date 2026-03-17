return {
    { "nvim-tree/nvim-web-devicons", opts = {} },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            preset = "helix",
        },
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ loop = true, global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        event = "BufRead *.md",
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
        opts = {},
        ft = { "markdown", "codecompanion" },
    },
    {
        "olimorris/codecompanion.nvim",
        branch = "main",
        cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionCmd", "CodeCompanionActions" },
        opts = {},
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
    },
    { "folke/noice.nvim", enabled = false },
    { "mason-org/mason-lspconfig.nvim", enabled = false },
    { "mason-org/mason.nvim", enabled = false },
    { "nvim-mini/mini.ai", enabled = false },
    { "nvim-mini/mini.icons", enabled = false },
    { "nvim-mini/mini.pairs", enabled = false },
    { "nvim-lualine/lualine.nvim", enabled = false },
}
