" Don't indent after C++ namespace start
setlocal cino=N-s

setlocal textwidth=120
setlocal colorcolumn=+1

" Highlighting {{{
let g:lsp_cxx_hl_use_text_props=1

map <leader>hi :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" }}}

let g:doxygen_javadoc_autobrief=0
let g:load_doxygen_syntax=1

autocmd BufEnter,BufNew *.h,*.hpp source ~/.config/nvim/ftplugin/cppHeader.vim
autocmd BufEnter,BufNew *.cpp source ~/.config/nvim/ftplugin/cppSource.vim

" vim: foldmarker={{{,}}} foldmethod=marker
