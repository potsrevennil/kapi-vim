if vim.loader then
    vim.loader.enable()
end
require("options")
require("keymaps")
require("colorscheme")
require("lsp")
require("user.mini")
require("user.cmp")
require("user.telescope")
require("user.treesitter")

require("hardtime").setup()
