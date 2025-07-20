return {
    {
        "Mofiqul/dracula.nvim",
        config = function()
            vim.cmd.colorscheme("dracula")
        end,
    },
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "dracula",
        },
    },
}
