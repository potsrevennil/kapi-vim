return {
	settings = {
		["rust_analyzer"] = {
			-- assist = {
			-- 	importGranularity = "module",
			-- 	importPrefix = "self",
			-- },
			imports = {
				granularity = {
					group = "module",
				},
				prefix = "self",
			},
			cargo = {
				loadOutDirsFromCheck = true,
			},
			procMacro = {
				enable = true,
				attributes = {
					enable = true,
				},
				derive = true,
			},
			checkOnSave = {
				command = "clippy",
			},
		},
	},
}
