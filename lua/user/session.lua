vim.cmd([[
    augroup session_cmds
        autocmd!
        autocmd VimLeave * silent! source ./.session.vim | mksession! ./.session.vim
    augroup end
]])
