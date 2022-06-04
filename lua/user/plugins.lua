local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

return packer.startup(function(use)
	use("preservim/nerdcommenter")
	use("windwp/nvim-autopairs")

	--auto completion
	use({ "hrsh7th/nvim-cmp", "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path" })
	use("L3MON4D3/LuaSnip")

	-- LSP
	use({
		"neovim/nvim-lspconfig",
		"williamboman/nvim-lsp-installer",
	})
	use({ "jose-elias-alvarez/null-ls.nvim", requires = "nvim-lua/plenary.nvim" })

	-- syntax highlighting
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	})

	--Language specific
	use({ "iamcco/markdown-preview.nvim", run = "cd app && yarn install", ft = "markdown", cmd = "MarkdownPreview" })

	--ui
	use({
		{
			"vim-airline/vim-airline",
			cmd = "AirlineToggle",
		},
		{
			"vim-airline/vim-airline-themes",
			cmd = "AirlineToggle",
		},
	})
	use({ "cocopon/iceberg.vim", event = "ColorScheme" })

	-- fuzzy finder
	use({
		{ "nvim-telescope/telescope.nvim", requires = "nvim-lua/plenary.nvim", cmd = "Telescope" },
		{ "nvim-telescope/telescope-fzf-native.nvim", run = "make", cmd = "Telescope" },
	})

	-- git
	use("lewis6991/gitsigns.nvim")

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
