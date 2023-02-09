local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

configs.setup({
	ensure_installed = {
		"bash",
		"gitignore",
		"go",
		"gomod",
		"javascript",
		"json",
		"lua",
		"markdown",
		"python",
		"rust",
		"sql",
		"tlaplus",
		"toml",
		"typescript",
		"vim",
		"yaml",
		"jsonnet",
	},
	sync_install = false,
	autopairs = {
		enable = true,
	},
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	indent = { enable = true, disable = { "yaml" } },
})
