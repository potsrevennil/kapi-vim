return {
    settings = {
        ['rust_analyzer'] = {
            imports = {
                granularity = {
                    group = "module",
                },
                prefix = "self",
            },
            cargo = {
                buildScripts = {
                    enable = true,
                    invocationLocation = "root",
                    invocationStrategy = "once",
                    overrideCommand = "cargo check --message-format=json",
                },
            },
            procMacro = {
                enable = true,
                attributes = {
                    enable = true,
                },
                derive = true,
            },
            check = {
                command = "clippy",
            },
            checkOnSave = {
                command = "clippy",
            },
            diagnostics = {
                enable = true,
                experimental = {
                    enable = false,
                },
                disabled = { "unresolved-proc-macro" },
            },
        },
    },
}
