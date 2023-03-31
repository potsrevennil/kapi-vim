local status_ok, filetype = pcall(require, "filetype")
if not status_ok then
    return
end

vim.g.did_load_filetypes = 1

filetype.setup({
    overrides = {
        extensions = {
            sol = "solidity",
            jsonnet = "jsonnet",
            sqlite3 = "sql",
        },
    },
})
