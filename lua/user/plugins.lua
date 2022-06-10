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
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
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
	use({ "dstein64/vim-startuptime", opt = true })
	use({ "nathom/filetype.nvim", config = "require 'user.filetype'" })
	use({ "echasnovski/mini.nvim", branch = "stable", config = "require 'user.mini'" })

	--auto completion
	use({
		"hrsh7th/nvim-cmp",
		config = "require 'user.cmp'",
		requires = {
			{ "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" },
			{ "hrsh7th/cmp-buffer", after = "nvim-cmp" },
			{ "hrsh7th/cmp-path", after = "nvim-cmp" },
			"L3MON4D3/LuaSnip",
			{ "windwp/nvim-autopairs", after = "nvim-cmp", config = "require 'user.autopairs'" },
		},
	})

	-- LSP
	use({
		"neovim/nvim-lspconfig",
		config = "require 'user.lsp'",
		requires = { "williamboman/nvim-lsp-installer", "jose-elias-alvarez/null-ls.nvim", "nvim-lua/plenary.nvim" },
	})

	-- syntax highlighting
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		config = "require 'user.treesitter'",
	})

	--Language specific
	use({ "iamcco/markdown-preview.nvim", run = "cd app && yarn install", ft = "markdown", cmd = "MarkdownPreview" })

	-- fuzzy finder
	use({
		"nvim-telescope/telescope.nvim",
		requires = { "nvim-lua/plenary.nvim", { "nvim-telescope/telescope-fzf-native.nvim", run = "make" } },
		keys = { "<Leader>ff", "<Leader>fg", "<Leader>fb", "<Leader>fh", "<Leader>fr" },
		config = "require 'user.telescope'",
	})

	-- git
	-- Execute the `Show` command will result in `packer_compiled` error
	use({ "lewis6991/gitsigns.nvim", keys = "<Leader>g", config = "require 'user.gitsigns'" })

	-- bufferline
	use({
		"akinsho/bufferline.nvim",
		tag = "v2.*",
		requires = "kyazdani42/nvim-web-devicons",
		keys = "<Leader>b",
		config = "require 'user.bufferline'",
	})

	use({ "cocopon/iceberg.vim", opt = true })
	use({ "dracula/vim", as = "dracula" })

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
