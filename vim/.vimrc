call plug#begin('~/.vim/plugged')
Plug 'jiangmiao/auto-pairs'
Plug 'dracula/vim'
Plug 'machakann/vim-highlightedyank'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'yuttie/comfortable-motion.vim'
Plug 'vim-scripts/vim-auto-save'
Plug 'tpope/vim-surround'
Plug 'lervag/vimtex'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'dylanaraps/wal'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'airblade/vim-gitgutter'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-jedi' "Python completion
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
Plug 'ervandew/supertab' "for now disabled in favor of neocomplete
Plug 'wellle/targets.vim'
Plug 'lazywei/vim-matlab'

let hostname = substitute(system('hostname'), '\n', '', '')
if hostname == "cmspool06"
    Plug 'dracula/vim'
    Plug 'wincent/terminus'
endif

call plug#end()


"Use deoplete
if hostname == "tom-linux"
    let g:deoplete#enable_at_startup = 1
endif
let g:SuperTabDefaultCompletionType = "<c-x><c-o>"

"neosnippet shortcuts
imap <F16>     <Plug>(neosnippet_expand_or_jump)
smap <F16>     <Plug>(neosnippet_expand_or_jump)
xmap <F16>     <Plug>(neosnippet_expand_target)

"Appeareance
set number
set relativenumber
syntax on

"increment/decrement
noremap + <C-a>
noremap - <C-x>

"traverse jump list
nnoremap <tab> <C-o>
nnoremap <s-tab> <C-i>

"indent file
nnoremap g= gg=G``

"Make sure gnuplot syntax works
source ~/.vim/syntax/gnuplot.vim
au BufNewFile,BufRead *.plt set filetype=gnuplot

"Matlab comments
autocmd FileType matlab setlocal commentstring=%\ %s
"Gnuplot comments
autocmd FileType gnuplot setlocal commentstring=#\ %s


"Colorscheme depending on computer (default: dracula)
if hostname == "arch-laptop" || hostname == "tom-linux"
    color wal
elseif hostname == "Amaa.uni-paderborn.de"
    color base16-solarflare
else
    color = dracula
endif
set hidden
set backspace=indent,eol,start

set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab

"Ignore case when searching
set ignorecase
set smartcase

"for vim-highlightedyank
map y <Plug>(highlightedyank)

"vim-comfortable-motion
nnoremap <silent> <C-d> :call comfortable_motion#flick(100)<CR>
nnoremap <silent> <C-u> :call comfortable_motion#flick(-100)<CR>

"Remap H and L
noremap H 0
noremap L g_

"for vim-airline
set laststatus=2
set noshowmode
let g:airline_powerline_fonts=1
let g:ariline_symbols_ascii=1
set ttimeoutlen=10
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"
let g:airline#extensions#tabline#enabled=1

"Make german keyboard layout better for programming
imap ü \
imap ä }
imap ö {
imap Ö [
imap Ä ]
nnoremap ä }
nnoremap ö {


"makes ci[ ci{ etc work again
onoremap iä i}<Esc>a
onoremap iö i}<Esc>a
onoremap iÄ i]<Esc>a
onoremap iÖ i[<Esc>a
onoremap aä a}
onoremap aö a}
onoremap aÄ a]
onoremap aÖ a[

onoremap tä t}
onoremap tö t}
onoremap tÄ t]
onoremap tÖ t[
onoremap fä f}
onoremap fö f}
onoremap fÄ f]
onoremap fÖ f[
onoremap fü f\
onoremap tü t\

autocmd FileType tex nnoremap j gj
autocmd FileType tex nnoremap k gk

"source gnuplot syntax file
so ~/.vim/syntax/gnuplot.vim

"yank to system clipboard (hopefully)
set clipboard=unnamedplus 

if hostname == "arch-laptop" || hostname == "tom-linux"

    "Setup deoplete to use vimtex completion
    if !exists('g:deoplete#omni#input_patterns')
        let g:deoplete#omni#input_patterns = {}
    endif
    let g:deoplete#omni#input_patterns.tex = g:vimtex#re#deoplete

    "Referencing with autocompletion
    inoremap ,rf \autoref{fig:}<Esc>i<C-X><C-O>
    inoremap ,re \autoref{eq:}<Esc>i<C-X><C-O>
    inoremap ,rk \autoref{kap:}<Esc>i<C-X><C-O>
    inoremap ,c \cite{}<Esc>i<C-X><C-O>

    "Folding
    let g:Tex_FoldedMisc='preamble'

    "Make Latex math a text object
    xnoremap i$ :<C-u>normal! T$vt$<CR>
    onoremap i$ :normal vi$<CR>

    "Enable transparency
    autocmd FileType tex highlight Nontext ctermbg=none
    autocmd FileType tex highlight Normal ctermbg=none
    highlight Normal ctermbg=none
    autocmd FileType tex highlight LineNr ctermbg=none
    highlight LineNr ctermbg=none

    "vimtex
    let g:vimtex_view_general_viewer = 'okular'
    let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'
    let g:vimtex_view_general_options_latexmk = '--unique'
    let g:vimtex_fold_enabled=1
    let g:vimtex_fold_manual=1 "should give better performance
    let g:vimtex_imaps_leader='´'

    "Disable some warnings
    let g:vimtex_quickfix_latexlog = {
                \ 'overfull' : 0,
                \ 'underfull' : 0,
                \ 'hyperref' : 0,
                \ 'Draft' : 0,
                \ 'packages' : {
                \   'default' : 0,
                \ },
                \}

    au VimEnter * call IMAP('#SI', '\SI{<++>}{<`0`>}<`0`>', 'tex')
    au VimEnter * call IMAP('#f', '\frac{<++>}{<`0`>}<`0`>', 'tex')
    au VimEnter * call IMAP('#i', "\\item ", 'tex')
    au VimEnter * call IMAP('#I', "\\begin{itemize}\<cr>\\item<++>\<cr>\\end{itemize}\<cr><`0`>", 'tex')
    au VimEnter * call IMAP('#Hb', "\\begin{hangbf}{<++>}\<cr><++>\<cr>\\end{hangbf}\<cr><`0`>", 'tex')
    au VimEnter * call IMAP('#Hi', "\\begin{hangit}{<++>}\<cr><`0`>\<cr>\\end{hangit}\<cr><`0`>", 'tex')
    au VimEnter * call IMAP('#Hh', "\\begin{hang}\<cr><++>\<cr>\\end{hang}\<cr><`0`>", 'tex')
    au VimEnter * call IMAP('#q', "\\qq{<++>}<`0`>", 'tex')
    au VimEnter * call IMAP('#P', "\\dv{<++>}{<`0`>}<`0`>", 'tex')
    au VimEnter * call IMAP('#pd', "\\pdv[<++>]{<`0`>}{<`0`>}<`0`>", 'tex')
    au VimEnter * call IMAP('#l', "\\limes{<++>}{<`0`>}<`0`>", 'tex')
    au VimEnter * call IMAP('#t', "\\text{<++>}<`0`>", 'tex')
    au VimEnter * call IMAP('#R', "\\Rightarrow", 'tex')
    au VimEnter * call IMAP('#r', "\\rightarrow", 'tex')
    au VimEnter * call IMAP('#E', "\\Leftrightarrow", 'tex')
    au VimEnter * call IMAP('#e', "\\ev{<++>}<`0`>", 'tex')
    au VimEnter * call IMAP('#pa', "\\qty(<++>)<`0`>", 'tex')
    au VimEnter * call IMAP('#pb', "\\qty[<++>]<`0`>", 'tex')
    au VimEnter * call IMAP('#v', "\\vec{<++>}<`0`>", 'tex')
    au VimEnter * call IMAP('#V', "\\vec{<++>}(<`0`>)<`0`>", 'tex')
    au VimEnter * call IMAP('#s', "\\sum_{<++>}<`0`>", 'tex')
    au VimEnter * call IMAP('#w', "\\sqrt{<++>}<`0`>", 'tex')
    au VimEnter * call IMAP('#d', "$<++>$ <`0`>", 'tex')
    au VimEnter * call IMAP('#D', "$<++>$<`0`>", 'tex')
    au VimEnter * call IMAP('#u', "\\underbrace{<++>}_{\\mathclap{\\substack{\\text{<`0`>}}}}<`0`>", 'tex')
    au VimEnter * call IMAP('#U', "\\underbrace{<++>}_{\\mathclap{<`0`>}}<`0`>", 'tex')
    au VimEnter * call IMAP('#O', "\\overbrace{<++>}^{\\mathclap{<`0`>}}<`0`>", 'tex')
    au VimEnter * call IMAP('#o', "\\overbrace{<++>}^{\\mathclap{\\substack{\\text{<`0`>}}}}<`0`>", 'tex')
    au VimEnter * call IMAP('#pb', "\\qty[<++>]<`0`>", 'tex')
    au VimEnter * call IMAP(',i', "\\int_{<++>}^{<`0`>}<`0`>\\dd{<`0`>}<`0`>", 'tex')
    au VimEnter * call IMAP('#c', "\\adj{<++>}<`0`>", 'tex')
    au VimEnter * call IMAP('#b', "\\bra{<++>}<`0`>", 'tex')
    au VimEnter * call IMAP('#k', "\\ket{<++>}<`0`>", 'tex')
    au VimEnter * call IMAP('#K', "\\commutator{<++>}{<`0`>}<`0`>", 'tex')
    au VimEnter * call IMAP('#m', "\\mem{<++>}{<`0`>}{<`0`>}<`0`>", 'tex')
    au VimEnter * call IMAP('#h', "\\hat{<++>}<`0`>", 'tex')

    au VimEnter * call IMAP('__', "_{<++>}<`0`>", 'tex')
    au VimEnter * call IMAP('^^', "^{<++>}<`0`>", 'tex')

    let g:vimtex_matchparen_enabled=0 "better performance
    autocmd FileType tex set lazyredraw "Better scrolling performance in latex,
    let g:vimtex_compiler_progname='~/.local/bin/nvr' "make vimtex work with nvim

    "TeX Settings
    autocmd FileType tex set encoding=utf-8
    autocmd FileType tex set wrap linebreak
    autocmd FileType tex set breakindent
    autocmd FileType tex set sw=2
    autocmd FileType tex set iskeyword+=:
    set grepprg=grep\ -nH\ $*
    let g:tex_flavor='latex'
    let g:Tex_DefaultTargetFormat='pdf'
    "Set okular as viewer and redirect output of stderr
    let g:Tex_ViewRule_pdf = 'okular --unique &> /dev/null'
    let g:Tex_CompileRule_pdf = 'latexmk -pv -pdf $* &> /dev/null'

    let g:vimtex_compiler_latexmk = {
                \ 'options' : [
                \   '-pdf',
                \   '-verbose',
                \   '-file-line-error',
                \   '-synctex=1',
                \   '-interaction=nonstopmode',
                \   '-shell-escape',
                \ ],
                \}

    "Macros
    let g:Tex_Leader='´'

    inoremap <silent><expr> __ neosnippet#anonymous('_{${0}}${0}')
    inoremap <silent><expr> ^^ neosnippet#anonymous('^{${0}}${0}')
    autocmd FileType tex inoremap <= \leq 
    autocmd FileType tex inoremap >= \geq 
    autocmd FileType tex inoremap != \neq 

endif
