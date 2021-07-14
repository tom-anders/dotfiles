nnoremap <silent> <buffer> J :cnext<CR><C-W><C-P>
nnoremap <silent> <buffer> K :cprev<CR><C-W><C-P>

nnoremap <silent> <buffer> q :cclose<CR>

nnoremap <silent> <buffer> <leader>n /error:<CR>

" Open result in new split
nnoremap <silent> <buffer> <leader><CR> <C-w><Enter><C-w>L

function! RemoveQfItem()
    let idx = line('.') - 1
    let qflist = getqflist()
    call remove(qflist, idx)
    call setqflist(qflist, 'r')

    execute "copen"
    " Go back to the idx we started at
    execute "normal " . idx . "j"
endfunction
nnoremap <silent> <buffer> dd :call RemoveQfItem()<CR>
