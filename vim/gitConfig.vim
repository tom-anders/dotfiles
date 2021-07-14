nn <silent> <leader>gs :Gstatus<cr>))
nn <silent> <leader>gb :Gblame<cr> 

nn <silent> <leader>gw :Gwrite<cr> 
nn <silent> <leader>gD :Git! diff<cr> 
nn <silent> <leader><leader>g :Git 
nn <leader>gp :Git push<CR>
nn <leader>gf :Git fetch<CR>
nn <leader>gl :Git pull<CR>

"Ignore whitespace changes in diff
set diffopt+=iwhite 

nn <leader>gF :Flog -max-count=2000 -format=%as\ {%an}\ [%h]\ %d\ %s <CR>
" Quickly open Flog from fugitive status
autocmd FileType fugitive nmap <buffer> f <leader>gF

nnoremap <silent> <leader>dh :diffget //2 <CR> :diffup<CR>
nnoremap <silent> <leader>dl :diffget //3 <CR> :diffup<CR>

" Needed since below we need to map J NON-recursively, but recursively to ]c and [c
nnoremap <Plug>(default-J) J
nnoremap <Plug>(default-K) K
nmap gK <Plug>(default-K)

" Use J and K to navigate hunks in diff
autocmd BufEnter,BufNew * nmap <buffer> <silent> <expr> J &diff ? ']c' : '<Plug>(default-J)'
autocmd BufEnter,BufNew * nmap <buffer> <silent> <expr> K &diff ? '[c' : ':lua vim.lsp.buf.hover()<CR>'

" Same but in Fugitive
autocmd FileType fugitive nmap <buffer> <Plug>(default-J) ]c
autocmd FileType fugitive nmap <buffer> <Plug>(default-K) [c

let g:tig_default_command = ''

nnoremap <silent> <leader>tt :Tig <CR>
nnoremap <silent> <leader>ta :Tig --all <CR>

" Tig for current file
nnoremap <silent> <leader>tf :Tig!<CR>
