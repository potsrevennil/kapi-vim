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
	autoremove = true,
})

return packer.startup(function(use)
	use("wbthomason/packer.nvim")
	use({ "dstein64/vim-startuptime", opt = true })
	use({ "nathom/filetype.nvim", config = "require 'user.filetype'" })
	use({ "echasnovski/mini.nvim", branch = "stable", config = "require 'user.mini'" })

	--auto completion
	use({ "L3MON4D3/LuaSnip", event = "InsertEnter" })

	use({
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		config = "require 'user.cmp'",
		requires = {
			{ "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" },
			{ "hrsh7th/cmp-buffer", after = "nvim-cmp" },
			{ "hrsh7th/cmp-path", after = "nvim-cmp" },
			{ "windwp/nvim-autopairs", after = "nvim-cmp", config = "require 'user.autopairs'" },
		},
	})

	-- LSP
	use({
		"williamboman/nvim-lsp-installer",
		config = "require 'user.lsp.installer'",
		requires = { { "neovim/nvim-lspconfig", config = "require 'user.lsp.config'.setup()" } },
	})

	use({
		"jose-elias-alvarez/null-ls.nvim",
		keys = "<Leader>nl",
		config = "require 'user.null-ls'",
		requires = "nvim-lua/plenary.nvim",
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
		requires = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				run = "make",
				after = "telescope.nvim",
				config = function()
					require("telescope").setup({
						extensions = {
							fzf = {
								fuzzy = true, -- false will only do exact matching
								override_generic_sorter = true, -- override the generic sorter
								override_file_sorter = true, -- override the file sorter
								case_mode = "smart_case", -- or "ignore_case" or "respect_case"
							},
						},
					})

					require("telescope").load_extension("fzf")
				end,
			},
		},
		keys = { "<Leader>ff", "<Leader>fg", "<Leader>fb", "<Leader>fh", "<Leader>fr" },
		config = "require 'user.telescope'",
	})

	-- git
	-- Execute the `Show` command will result in `packer_compiled` error
	use({ "lewis6991/gitsigns.nvim", keys = "<Leader>gs", config = "require 'user.gitsigns'" })

	-- bufferline
	use({
		"akinsho/bufferline.nvim",
		tag = "v2.*",
		requires = "kyazdani42/nvim-web-devicons",
		keys = "<Leader>bl",
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
