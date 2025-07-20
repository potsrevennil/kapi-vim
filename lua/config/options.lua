local opts = {
    cmdheight = 3,
    scrolloff = 10,
    shiftwidth = 4,
    shortmess = "aoOtTICF",
    tabstop = 4,
    virtualedit = "all", -- cursor can be placed anywhere
}

vim.opt.path:append("**")

for k, v in pairs(opts) do
    vim.opt[k] = v
end

vim.cmd("set whichwrap+=<,>,[,],h,l")

local gopts = {
    netrw_winsize = 10,
    netrw_banner = 0,
    netrw_keepdir = 0,
    snacks_animate = false,
    lazyvim_cmp = "nvim-cmp",
    trouble_lualine = false,
    lazyvim_picker = "telescope",
}

for k, v in pairs(gopts) do
    vim.g[k] = v
end
