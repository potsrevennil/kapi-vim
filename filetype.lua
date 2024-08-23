if vim.api.nvim_call_function("did_filetype", {}) then
    return
end

vim.filetype.add({
    pattern = {
        [".*"] = {
            function(path, bufnr)
                local content = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ""
                if vim.regex([[^#!.*\\<python\\>]]):match_str(content) ~= nil then
                    return "python"
                end
            end,
            { priority = -math.huge },
        },
    },
})
