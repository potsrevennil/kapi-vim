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
    -- neo-tree require()s `nui.line`, but its extra never declares the dep --
    -- stock LazyVim pulls nui in via lazyvim.plugins.ui, which we dropped.
    {
        "nvim-neo-tree/neo-tree.nvim",
        dependencies = { "MunifTanjim/nui.nvim" },
    },
    -- LazyVim defaults we don't use, disabled rather than loaded: mason (nix
    -- provides the LSP servers), mini.pairs (nvim-autopairs instead), and the
    -- noice/mini.icons/lualine UI layer.
    { "folke/noice.nvim", enabled = false },
    { "mason-org/mason-lspconfig.nvim", enabled = false },
    { "mason-org/mason.nvim", enabled = false },
    { "nvim-mini/mini.ai", enabled = false },
    { "nvim-mini/mini.icons", enabled = false },
    { "nvim-mini/mini.pairs", enabled = false },
    { "nvim-lualine/lualine.nvim", enabled = false },
    -- editor/util plugins LazyVim bundles that we don't use; telescope,
    -- treesitter and the LSP diagnostics cover what these offered.
    { "MagicDuck/grug-far.nvim", enabled = false },
    { "folke/todo-comments.nvim", enabled = false },
    { "folke/trouble.nvim", enabled = false },
    { "folke/persistence.nvim", enabled = false },
    { "lewis6991/gitsigns.nvim", enabled = false },
}
