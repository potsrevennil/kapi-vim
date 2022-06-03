local fn = vim.fn

-- Install vim-plug if not found
local data_dir
if fn.has("nvim") then
	data_dir = fn.stdpath("data") .. "/site"
else
	data_dir = "~/.vim"
end

if fn.empty(fn.glob(data_dir .. "/autoload/plug.vim")) > 0 then
	print("Installing Vim Plug...")
	os.execute(
		"!curl -fLo"
			.. data_dir
			.. "/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
	)
end

-- Run PlugInstall if there are missing plugins
vim.cmd([[
    augroup vim_plug_config
        autocmd!
        autocmd BufWritePost plugins.lua source <afile> | PlugUpdate
        autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)')) 
            \| PlugUpdate | source $MYVIMRC 
        \| endif
    augroup end
]])

local Plug = fn["plug#"]
vim.call("plug#begin")

Plug("nvim-lua/plenary.nvim") -- Useful lua functions used ny lots of plugins
Plug("preservim/nerdcommenter")
Plug("windwp/nvim-autopairs")

--auto completion
Plug("hrsh7th/nvim-cmp")
Plug("hrsh7th/cmp-nvim-lsp")
Plug("L3MON4D3/LuaSnip")

-- LSP
Plug("neovim/nvim-lspconfig")
Plug("williamboman/nvim-lsp-installer")
Plug("jose-elias-alvarez/null-ls.nvim")

-- syntax highlighting
Plug("nvim-treesitter/nvim-treesitter", { ["do"] = fn[":TSUpdate"] })

--Language specific
Plug("rust-lang/rust.vim", { ["for"] = "rust" })
Plug("Julian/lean.nvim", { ["for"] = "lean" })
Plug("neovimhaskell/haskell-vim", { ["for"] = "haskell" })
Plug("iamcco/markdown-preview.nvim", { ["do"] = fn["cd app && yarn install"], ["for"] = "markdown" })

--ui
Plug(
	"vim-airline/vim-airline",
	{ ["on"] = { "AirlineExtensions", "AirlineRefresh", "AirlineTheme", "AirlineToggle", "AirlineToggleWhitespace" } }
)
Plug(
	"vim-airline/vim-airline-themes",
	{ ["on"] = { "AirlineExtensions", "AirlineRefresh", "AirlineTheme", "AirlineToggle", "AirlineToggleWhitespace" } }
)
Plug("cocopon/iceberg.vim")

-- fuzzy finder
Plug("nvim-telescope/telescope.nvim")

-- git
Plug("lewis6991/gitsigns.nvim")

vim.call("plug#end")
