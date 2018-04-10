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
Plug 'ervandew/supertab'

call plug#end()

"Appeareance
set number
set relativenumber
syntax on

"Colorscheme depending on computer (default: dracula)
let hostname = substitute(system('hostname'), '\n', '', '')
if hostname == "arch-laptop"
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


"source gnuplot syntax file
so ~/.vim/syntax/gnuplot.vim

"yank to system clipboard (hopefully)
set clipboard=unnamedplus 

if hostname == "arch-laptop"

    "Insert environment
    imap <F8> \begin{}<cr><cr>\end{}<Esc>ki<tab><Esc>cse

    "Referencing with autocompletion
    imap ,rf \autoref{fig:<C-X><C-O>
    imap ,re \autoref{eq:<C-X><C-O>
    imap ,rk \autoref{kap:<C-X><C-O>

    "Folding
    let g:Tex_FoldedMisc='preamble'

    " "context" menu key on windows keyboard to jump to placeholder
    imap <F16> <Plug>IMAP_JumpForward
    noremap <F16> /<++><Cr>c4l

    au VimEnter * call IMAP('ue', 'ü', 'tex')
    au VimEnter * call IMAP('ae', 'ä', 'tex')
    au VimEnter * call IMAP('oe', 'ö', 'tex')
    au VimEnter * call IMAP('Ue', 'Ü', 'tex')
    au VimEnter * call IMAP('Ae', 'Ä', 'tex')
    au VimEnter * call IMAP('Oe', 'Ö', 'tex')

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

    "make vimtex work with neocomplete
    if !exists('g:neocomplete#sources#omni#input_patterns')
        let g:neocomplete#sources#omni#input_patterns = {}
    endif
    let g:neocomplete#sources#omni#input_patterns.tex =
                \ '\v\\%('
                \ . '\a*cite\a*%(\s*\[[^]]*\]){0,2}\s*\{[^}]*'
                \ . '|\a*ref%(\s*\{[^}]*|range\s*\{[^,}]*%(}\{)?)'
                \ . '|hyperref\s*\[[^]]*'
                \ . '|includegraphics\*?%(\s*\[[^]]*\]){0,2}\s*\{[^}]*'
                \ . '|%(include%(only)?|input)\s*\{[^}]*'
                \ . '|\a*(gls|Gls|GLS)(pl)?\a*%(\s*\[[^]]*\]){0,2}\s*\{[^}]*'
                \ . '|includepdf%(\s*\[[^]]*\])?\s*\{[^}]*'
                \ . '|includestandalone%(\s*\[[^]]*\])?\s*\{[^}]*'
                \ . '|usepackage%(\s*\[[^]]*\])?\s*\{[^}]*'
                \ . '|documentclass%(\s*\[[^]]*\])?\s*\{[^}]*'
                \ . '|\a*'
                \ . ')'

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
    au VimEnter * call IMAP('#SI', '\SI{<++>}{<++>}<++>', 'tex')
    au VimEnter * call IMAP('#f', '\frac{<++>}{<++>}<++>', 'tex')
    au VimEnter * call IMAP('#i', "\\item ", 'tex')
    au VimEnter * call IMAP('#I', "\\begin{itemize}\<cr>\\item<++>\<cr>\\end{itemize}\<cr><++>", 'tex')
    au VimEnter * call IMAP('#q', "\\qq{<++>}<++>", 'tex')
    au VimEnter * call IMAP('#P', "\\dv{<++>}{<++>}<++>", 'tex')
    au VimEnter * call IMAP('#pd', "\\pdv{<++>}{<++>}<++>", 'tex')
    au VimEnter * call IMAP('#l', "\\limes{<++>}{<++>}<++>", 'tex')
    au VimEnter * call IMAP('#t', "\\text{<++>}<++>", 'tex')
    au VimEnter * call IMAP('#R', "\\Rightarrow", 'tex')
    au VimEnter * call IMAP('#r', "\\rightarrow", 'tex')
    au VimEnter * call IMAP('#E', "\\Leftrightarrow", 'tex')
    au VimEnter * call IMAP('#e', "\\ev{<++>}<++>", 'tex')
    au VimEnter * call IMAP('#pa', "\\qty(<++>)<++>", 'tex')
    au VimEnter * call IMAP('#pb', "\\qty[<++>]<++>", 'tex')
    au VimEnter * call IMAP('#v', "\\vec{<++>}<++>", 'tex')
    au VimEnter * call IMAP('#s', "\\sum_{<++>}<++>", 'tex')
    au VimEnter * call IMAP('#w', "\\sqrt{<++>}<++>", 'tex')
    au VimEnter * call IMAP('#d', "$<++>$ <++>", 'tex')
    au VimEnter * call IMAP('#D', "$<++>$<++>", 'tex')
    au VimEnter * call IMAP('#u', "\\underbrace{<++>}_{\\mathclap{\\substack{\\text{<++>}}}}<++>", 'tex')
    au VimEnter * call IMAP('#U', "\\underbrace{<++>}_{\\mathclap{<++>}}<++>", 'tex')
    au VimEnter * call IMAP('#O', "\\overbrace{<++>}^{\\mathclap{<++>}}<++>", 'tex')
    au VimEnter * call IMAP('#o', "\\overbrace{<++>}^{\\mathclap{\\substack{\\text{<++>}}}}<++>", 'tex')
    au VimEnter * call IMAP('#pb', "\\qty[<++>]<++>", 'tex')
    au VimEnter * call IMAP(',i', "\\int_{<++>}^{<++>}<++>\\dd{<++>}<++>", 'tex')
    au VimEnter * call IMAP('#c', "\\adj{<++>}<++>", 'tex')
    au VimEnter * call IMAP('#b', "\\bra{<++>}<++>", 'tex')
    au VimEnter * call IMAP('#k', "\\ket{<++>}<++>", 'tex')
    au VimEnter * call IMAP('#K', "\\commutator{<++>}{<++>}<++>", 'tex')
    au VimEnter * call IMAP('#h', "\\hat{<++>}<++>", 'tex')
    au VimEnter * call IMAP(',c', "\\cite{<++>}<++>", 'tex')
    au VimEnter * call IMAP(',C', "\\cite[vgl.][<++>]{<++>}<++>", 'tex')
    au VimEnter * call IMAP('__', "_{<++>}<++>", 'tex')
    au VimEnter * call IMAP('^^', "^{<++>}<++>", 'tex')
    au VimEnter * call IMAP('<=', "\\leq ", 'tex')
    au VimEnter * call IMAP('>=', "\\geq ", 'tex')


    "Special environments
    au VimEnter * call IMAP('EFI',"\\begin{figure}[H]\<cr>\\centering\<cr>\\includegraphics[width=0.6\\textwidth]{<++>}\<cr>\\caption{<++>}\<cr>\\label{fig:<++>}\<cr>\\end{figure}", 'tex')
    au VimEnter * call IMAP('EWF',"\\begin{wrapfigure}[5]{l}{0.4\\textwidth}\<cr>\\vspace{-1.2em}\<cr>\\includegraphics[width=0.4\\textwidth]{<++>}\<cr>\\caption{<++>}\<cr>\\label{fig:<++>}\<cr>\\end{wrapfigure}", 'tex')
    au VimEnter * call IMAP('#a', "\\begin{align*}\<cr><++> &= <++>\<cr>\\end{align*}\<cr><++>", 'tex')
    au VimEnter * call IMAP('#A', "\\begin{align}\<cr><++> &= <++>\<cr>\\end{align}\<cr><++>", 'tex')

endif
