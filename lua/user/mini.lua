-- colorscheme
local base16_status_ok, base16 = pcall(require, "mini.base16")
if not base16_status_ok then
    return
end

local palette = base16.mini_palette("#33374c", "#c6c8d1", 30)
base16.setup({ palette = palette })

local comment_status_ok, comment = pcall(require, "mini.comment")
if not comment_status_ok then
    return
end

comment.setup()
