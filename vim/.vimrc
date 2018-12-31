call plug#begin('~/.vim/plugged')
Plug 'jiangmiao/auto-pairs'
Plug 'dracula/vim'
Plug 'machakann/vim-highlightedyank'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'vim-scripts/vim-auto-save'
Plug 'tpope/vim-surround'
Plug 'lervag/vimtex'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'dylanaraps/wal'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'airblade/vim-gitgutter'
Plug 'wellle/targets.vim'
Plug 'lazywei/vim-matlab'
Plug 'justinmk/vim-sneak'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'tommcdo/vim-exchange'
Plug 'rafaqz/ranger.vim'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/fzf.vim'
Plug 'ludovicchabant/vim-gutentags'

"ncm2 config
Plug 'roxma/nvim-yarp'
Plug 'ncm2/ncm2'
Plug 'ncm2/ncm2-jedi'
Plug 'ncm2/ncm2-pyclang'
let g:ncm2_pyclang#library_path = '/usr/lib'
Plug 'ncm2/ncm2-ultisnips'
"Parameter mit ultisnips vervollstaendigen
inoremap <silent> <expr> <CR> ncm2_ultisnips#expand_or((pumvisible() ? "\<c-y>" : "\<CR>"), 'n')
autocmd filetype tex inoremap <expr> <CR> (pumvisible() ? "\<c-y>" : "\<CR>")
" Use <TAB> to select the popup menu:
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
set completeopt=noinsert,menuone

let hostname=hostname()
if hostname == "cmspool06"
    Plug 'dracula/vim'
    Plug 'wincent/terminus'
endif
if hostname != "Amaa.uni-paderborn.de" 
    " Plug 'ervandew/supertab' 
endif

call plug#end()

let mapleader = ' '
let maplocalleader = ' '

map <leader><leader> za
map <leader>a za

"Mappings for switiching buffers
map <leader>bn :bn<cr>
map <leader>bv :bp<cr>
map <leader>bd :bd<cr>

"Mappings for fzf.vim
map <leader>ff :GFiles<cr> 
map <leader>fg :Files<cr>
map <leader>fb :Buffers<cr>
map <leader>fm :Marks<cr>
map <leader>fl :Lines<cr>

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

"Go to definition using tags
xmap gd <C-]>
nmap gd <C-]>

if hostname == "Amaa.uni-paderborn.de"
    let g:UltiSnipsExpandTrigger="<tab>"
    let g:UltiSnipsJumpForwardTrigger="<tab>"
else 
    let g:UltiSnipsExpandTrigger="<F16>"
    let g:UltiSnipsJumpForwardTrigger="<F16>"
endif
let g:UltiSnipsJumpBackwardTrigger="<c-y>"

" For ranger.vim
let g:ranger_terminal = 'urxvt -e'
map <leader>rr :RangerEdit<cr>
map <leader>rv :RangerVSplit<cr>
map <leader>rs :RangerSplit<cr>
map <leader>rt :RangerTab<cr>
map <leader>ri :RangerInsert<cr>
map <leader>ra :RangerAppend<cr>
map <leader>rc :set operatorfunc=RangerChangeOperator<cr>g@
map <leader>rd :RangerCD<cr>
map <leader>rld :RangerLCD<cr>

"Move vertically with f and t using the sneak plugin
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T

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

"On a German keyboard @ is altgr+q, so when executing a macro with @ i may
"accidentally press only q and thus overwrite the macro, so simply swap @ and
"q in normal mode:

nnoremap @ q
nnoremap q @

"map j to gj except when there is a count!
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

"source gnuplot syntax file
so ~/.vim/syntax/gnuplot.vim

"yank to system clipboard (hopefully)
set clipboard=unnamedplus 

if hostname == "arch-laptop" || hostname == "tom-linux" || hostname == "Amaa.uni-paderborn.de"
    set shell=/usr/bin/zsh

    "Setup deoplete to use vimtex completion
    if hostname == "tom-linux"
        if !exists('g:deoplete#omni#input_patterns')
            let g:deoplete#omni#input_patterns = {}
        endif
        let g:deoplete#omni#input_patterns.tex = g:vimtex#re#deoplete
    endif

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
    if hostname != "Amaa.uni-paderborn.de"
        let g:vimtex_view_general_viewer = 'okular'
    endif
    let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'
    let g:vimtex_view_general_options_latexmk = '--unique'
    let g:vimtex_fold_enabled=1
    let g:vimtex_fold_manual=1 "should give better performance
    let g:vimtex_imaps_leader='´'

    "Disable some warnings
    let g:vimtex_quickfix_latexlog = {
                \ 'overfull' : 0,
                \ 'underfull' : 0,
                \ 'Draft' : 0,
                \ 'font' : 0,
                \ 'packages' : {
                \   'default' : 0,
                \ },
                \}


    let g:vimtex_matchparen_enabled=0 "better performance
    autocmd FileType tex set lazyredraw "Better scrolling performance in latex,
    if hostname == "arch-laptop" 
        let g:vimtex_compiler_progname='~/.local/bin/nvr' "make vimtex work with nvim
    else 
        let g:vimtex_compiler_progname='/usr/bin/nvr' "make vimtex work with nvim
    endif

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
                \   '-lualatex',
                \ ],
                \}

    "Macros
    let g:Tex_Leader='´'

    "Completion setup for ncm2
    augroup my_cm_setup
        autocmd!
        autocmd BufEnter * call ncm2#enable_for_buffer()
        autocmd Filetype tex call ncm2#register_source({
                    \ 'name' : 'vimtex-cmds',
                    \ 'priority': 8, 
                    \ 'complete_length': -1,
                    \ 'scope': ['tex'],
                    \ 'matcher': {'name': 'prefix', 'key': 'word'},
                    \ 'word_pattern': '\w+',
                    \ 'complete_pattern': g:vimtex#re#ncm2#cmds,
                    \ 'on_complete': ['ncm2#on_complete#omni', 'vimtex#complete#omnifunc'],
                    \ })
        autocmd Filetype tex call ncm2#register_source({
                    \ 'name' : 'vimtex-labels',
                    \ 'priority': 8, 
                    \ 'complete_length': -1,
                    \ 'scope': ['tex'],
                    \ 'matcher': {'name': 'combine',
                    \             'matchers': [
                    \               {'name': 'substr', 'key': 'word'},
                    \               {'name': 'substr', 'key': 'menu'},
                    \             ]},
                    \ 'word_pattern': '\w+',
                    \ 'complete_pattern': g:vimtex#re#ncm2#labels,
                    \ 'on_complete': ['ncm2#on_complete#omni', 'vimtex#complete#omnifunc'],
                    \ })
        autocmd Filetype tex call ncm2#register_source({
                    \ 'name' : 'vimtex-files',
                    \ 'priority': 8, 
                    \ 'complete_length': -1,
                    \ 'scope': ['tex'],
                    \ 'matcher': {'name': 'combine',
                    \             'matchers': [
                    \               {'name': 'abbrfuzzy', 'key': 'word'},
                    \               {'name': 'abbrfuzzy', 'key': 'abbr'},
                    \             ]},
                    \ 'word_pattern': '\w+',
                    \ 'complete_pattern': g:vimtex#re#ncm2#files,
                    \ 'on_complete': ['ncm2#on_complete#omni', 'vimtex#complete#omnifunc'],
                    \ })
        autocmd Filetype tex call ncm2#register_source({
                    \ 'name' : 'bibtex',
                    \ 'priority': 8, 
                    \ 'complete_length': -1,
                    \ 'scope': ['tex'],
                    \ 'matcher': {'name': 'combine',
                    \             'matchers': [
                    \               {'name': 'prefix', 'key': 'word'},
                    \               {'name': 'abbrfuzzy', 'key': 'abbr'},
                    \               {'name': 'abbrfuzzy', 'key': 'menu'},
                    \             ]},
                    \ 'word_pattern': '\w+',
                    \ 'complete_pattern': g:vimtex#re#ncm2#bibtex,
                    \ 'on_complete': ['ncm2#on_complete#omni', 'vimtex#complete#omnifunc'],
                    \ })
    augroup END

endif
