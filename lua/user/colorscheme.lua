local colorscheme = "iceberg"

vim.cmd([[
    syntax on
    filetype plugin indent on
]])

local status_ok, _ = pcall(vim.cmd, 'colorscheme ' .. colorscheme)
if not status_ok then
  vim.notify('colorscheme ' .. colorscheme .. ' not found!')
  return
end
