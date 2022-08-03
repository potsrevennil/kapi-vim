vim.cmd([[
    augroup session_cmds
        autocmd!
        autocmd VimLeave * silent! mksession! ./.session.vim
    augroup end
]])
