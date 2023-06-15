local options = {
    clipboard = "unnamedplus",
    cmdheight = 3,
    completeopt = { "menu", "menuone", "noselect" },
    ignorecase = true, -- ignore case in search patterns
    mouse = "a",    -- allow the mouse to be used in neovim
    smartcase = true,
    smartindent = true,
    splitbelow = true,
    splitright = true,
    swapfile = false,
    undofile = true, -- enable persistent undo
    updatetime = 300, -- faster completion (4000ms default)
    expandtab = true,
    shiftwidth = 4,
    shiftround = true,
    tabstop = 4,
    cursorline = true, -- highlight the current line
    cursorcolumn = true, -- highlight the current column
    number = true,
    relativenumber = true,
    numberwidth = 2,
    signcolumn = "yes",
    scrolloff = 10,
    foldenable = false,
    foldmethod = "expr",
    foldexpr = "nvim_treesitter#foldexpr()",
    termguicolors = true,
    virtualedit = "all", -- cursor can be placed anywhere
}

vim.opt.path:append("**")

for k, v in pairs(options) do
    vim.opt[k] = v
end

vim.cmd("set whichwrap+=<,>,[,],h,l")

vim.g.netrw_winsize = 10
vim.g.netrw_banner = 0
