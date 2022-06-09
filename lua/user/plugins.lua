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

vim.cmd([[
    augroup vim_plug_config
        autocmd!
        autocmd BufWritePost plugins.lua source <afile> | PlugUpdate
    augroup end
]])

local Plug = fn["plug#"]
vim.call("plug#begin")
Plug("nvim-lua/plenary.nvim")

Plug("nathom/filetype.nvim")
Plug("echasnovski/mini.nvim", { ["branch"] = "stable" })

--auto completion
Plug("hrsh7th/nvim-cmp")
Plug("hrsh7th/cmp-nvim-lsp")
Plug("hrsh7th/cmp-buffer")
Plug("hrsh7th/cmp-path")
Plug("L3MON4D3/LuaSnip")
Plug("windwp/nvim-autopairs")

-- LSP
Plug("neovim/nvim-lspconfig")
Plug("williamboman/nvim-lsp-installer")
Plug("jose-elias-alvarez/null-ls.nvim")

-- syntax highlighting
Plug("nvim-treesitter/nvim-treesitter")

--Language specific
Plug("iamcco/markdown-preview.nvim", { ["do"] = fn["cd app && yarn install"], ["for"] = "markdown" })

-- fuzzy finder
Plug("nvim-telescope/telescope.nvim")
Plug("nvim-telescope/telescope-fzf-native.nvim", { ["do"] = fn["make"] })

-- git
-- Execute the `Show` command will result in `packer_compiled` error
Plug("lewis6991/gitsigns.nvim", { on = "Show" })

-- bufferline
Plug("kyazdani42/nvim-web-devicons")
Plug("akinsho/bufferline.nvim", { on = "Show" })

vim.call("plug#end")
