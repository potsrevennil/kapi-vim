if vim.loader then
    vim.loader.enable()
end
require("user.options")
require("user.keymaps")
require("user.plugins")
