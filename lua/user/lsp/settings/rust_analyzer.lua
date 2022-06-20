return {
	settings = {
		["rust_analyzer"] = {
			assist = {
				importGranularity = "module",
				importPrefix = "self",
			},
			cargo = {
				loadOutDirsFromCheck = true,
			},
			procMacro = {
				enable = false,
			},
		},
	},
}
