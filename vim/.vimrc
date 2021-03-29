call plug#begin('~/.vim/plugged')
Plug 'dracula/vim'
Plug 'machakann/vim-highlightedyank'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'vim-scripts/vim-auto-save'
Plug 'tpope/vim-surround'
Plug 'vim-scripts/ReplaceWithRegister'

Plug 'lervag/vimtex'
let g:tex_flavor='latex'
set conceallevel=2
let g:tex_conceal='abdmg'
Plug 'KeitaNakamura/tex-conceal.vim'

" Plug 'tmsvg/pear-tree' <- Use coc-pairs instead to not break autocomplete

" Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'jackguo380/vim-lsp-cxx-highlight'
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1

Plug 'dylanaraps/wal'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'airblade/vim-gitgutter'
" Plug 'wellle/targets.vim'
Plug 'lazywei/vim-matlab'
Plug 'justinmk/vim-sneak'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'tommcdo/vim-exchange'
Plug 'rafaqz/ranger.vim'
Plug 'junegunn/vim-easy-align'

Plug 'tommcdo/vim-express' "For g= to apply an expression onto a motion
"Convert to title case inside a motion, needs pip install titlecase
autocmd VimEnter * MapExpress gt system('titlecase ' . v:val)

Plug 'junegunn/fzf.vim'
set rtp+=/usr/local/opt/fzf "for mac
Plug 'antoinemadec/coc-fzf'

Plug 'liuchengxu/vista.vim'

Plug 'mbbill/undotree'

"Text ojects
Plug 'kana/vim-textobj-user'
" Plug 'sgur/vim-textobj-parameter' "i, and a, for function parameters
Plug 'https://github.com/vim-scripts/argtextobj.vim'
Plug 'bps/vim-textobj-python'
Plug 'glts/vim-textobj-comment' "ic and ac, this has to be loaded AFTER textobj-python, since that one also defines ic ac for python classes!

Plug 'neoclide/coc.nvim', { 'branch': 'release' }
set completeopt=noinsert,menuone,noselect

let hostname=hostname()

Plug 'jacoborus/tender.vim'
Plug 'drewtempelmeyer/palenight.vim'

call plug#end()

"Colorscheme depending on computer 
if hostname == "arch-laptop" || hostname == "tom-linux"
    color wal
else
    color elflord
endif

let mapleader = ' '
let maplocalleader = ' '

"coc.nvim config, mainly copied from https://github.com/neoclide/coc.nvim#example-vim-configuration
"-----------------------------------------------------------------------------------------------

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gu <Plug>(coc-references)
nmap <silent> gs :CocFzfList symbols<CR>

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocActionAsync('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

autocmd FileType cpp nmap gh :CocCommand clangd.switchSourceHeader<CR>

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

"--------------------------------------------------------------

" Vista.vim config
let g:vista_fzf_preview = ['right:50%']

function! NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction
set statusline+=%{NearestMethodOrFunction()}
autocmd VimEnter * call vista#RunForNearestMethodOrFunction()

let g:vista_executive_for = {
  \ 'cpp': 'coc',
  \ }

map <leader>v :Vista!!<CR>
map <leader>. :Vista finder<CR>
"--------------------------------------------------------------

" Quickfix mappings
map <leader>cn :cnext<CR>
map <leader>cp :cprev<CR>
function! ToggleQuickFix()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
        copen
    else
        cclose
    endif
endfunction
nnoremap <silent> <leader>cc :call ToggleQuickFix()<cr>

" Go up/down in quickfix and keep it focused
autocmd FileType qf nnoremap <buffer> <Down> :cnext<CR><C-W><C-P>
autocmd FileType qf nnoremap <buffer> <Up> :cprev<CR><C-W><C-P>

"toggle folds
map <leader><leader> za
map <leader>a za

"toggle undotree
map <leader>uu :UndotreeToggle<cr>
map <leader>uf :UndotreeFocus<cr>

"Mappings for switiching buffers
map <leader>bn :bn<cr>
map <leader>bv :bp<cr>
map <leader>bd :bd<cr>
nnoremap <leader>wq :w\|bd<cr>

map <C-l> :bn<cr>
map <C-h> :bp<cr>

"Mappings for fzf.vim
map <leader>f :GFiles<cr> 
map <leader>zf :Files<cr>
map <leader>zb :Buffers<cr>
map <leader>zm :Marks<cr>
map <leader>zl :Lines<cr>
map <leader>zg :Rg<cr>

nnoremap <silent> <Leader>tt :call vimtex#fzf#run('c')<CR>
nnoremap <silent> <Leader>to :call vimtex#fzf#run('t')<CR>
nnoremap <silent> <Leader>ta :call vimtex#fzf#run('ctl')<CR>

" Fugitive mappings
map <leader>gs :Gstatus<cr> 
map <leader>gr :Gread<cr> 

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

if hostname == "stefan-schumacher11.uni-paderborn.de" 
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
"vim-express also defines this, so we have to override it after the plugins are sourced
autocmd VimEnter * nnoremap g= gg=G``zz 

"Make sure gnuplot syntax works
source ~/.vim/syntax/gnuplot.vim
au BufNewFile,BufRead *.plt set filetype=gnuplot

"Matlab comments
autocmd FileType matlab setlocal commentstring=%\ %s
"Gnuplot comments
autocmd FileType gnuplot setlocal commentstring=#\ %s
"C++ comments
autocmd FileType cpp setlocal commentstring=//\ %s

"Insert comment divider
map <leader>d o<Esc>99A=<Esc>gcc
"Comment box
map <leader>bb O<Esc>O<Esc>100A=<Esc><CR>ix<CR><Esc>i<Esc>100a=<Esc>gc2kjcl

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

"map j to gj except when there is a count!
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

"source gnuplot syntax file
so ~/.vim/syntax/gnuplot.vim

"yank to system clipboard (hopefully)
set clipboard=unnamedplus 

if hostname == "arch-laptop" || hostname == "tom-linux" 

    let g:surround_{char2nr('c')} = "\\\1command\1{\r}" "Surround with latex cmd

    if hostname == "stefan-schumacher11.uni-paderborn.de" 
    	set shell=/bin/zsh
    else
    	set shell=/usr/bin/zsh
    endif

    "Referencing with autocompletion
    inoremap ,rf \autoref{fig:}<Esc>i<C-X><C-O>
    inoremap ,re \autoref{eq:}<Esc>i<C-X><C-O>
    inoremap ,rk \autoref{kap:}<Esc>i<C-X><C-O>

    "Folding
    let g:Tex_FoldedMisc='preamble'

    "Text object for LaTeX math $$
    call textobj#user#plugin('latex', {
                \  'dollar-math-a': {
                \     '*pattern*': '[$][^$]*[$]',
                \     'select': 'am',
                \   },
                \  'dollar-math-i': {
                \     '*pattern*': '[$]\zs[^$]*\ze[$]',
                \     'select': 'im',
                \   },
                \ })

    "Enable transparency
    autocmd FileType tex highlight Nontext ctermbg=none
    autocmd FileType tex highlight Normal ctermbg=none
    highlight Normal ctermbg=none
    autocmd FileType tex highlight LineNr ctermbg=none
    highlight LineNr ctermbg=none
    autocmd FileType tex highlight Conceal cterm=none ctermbg=none 

    "vimtex
    if hostname != "stefan-schumacher11.uni-paderborn.de" 
        let g:vimtex_view_method = 'zathura'
    else 
        let g:vimtex_view_method = 'skim'
    endif
    let g:vimtex_fold_enabled=1
    let g:vimtex_fold_manual=1 "should give better performance
    let g:vimtex_imaps_leader='´'

    let  g:vimtex_fold_types = {
           \ 'preamble' : {'enabled' : 0},
           \ 'env_options' : {'enabled' : 1},
           \ 'cmd_single_opt' : {'enabled' : 1},
           \ 'envs' : {
           \   'blacklist' : ['equation', 'eqbox', 'axis', 'groupplot'],
           \ },
           \}

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

    " ===================================================================================================
    " fzf-bibtex integration 
    " ===================================================================================================
    function! s:bibtex_cite_sink(lines)
        execute ':normal! a\cite{' . split(a:lines[0])[-1] . '}'
        call feedkeys('a') "Back to insert mode
    endfunction
    function! s:bibtex_cite_sink_single(lines)
        execute ':normal!i' . trim(split(a:lines[0])[-1])
        " execute ':normal!i'
    endfunction

    " autocmd FileType tex inoremap <C-c> <Esc> :call fzf#run({
    "                         \ 'source': './bibtexToFzf.py',
    "                         \ 'sink*': function('<sid>bibtex_cite_sink'),
    "                         \ 'down': '40%',
    "                         \ 'options': '--ansi --color hl+:255 --prompt "Cite> "'})<CR>
    imap ,c \cite{}<Esc>i<C-c>
    autocmd FileType tex inoremap <C-c> <Esc> :call fzf#run({
                            \ 'source': './bibtexToFzf.py',
                            \ 'sink*': function('<sid>bibtex_cite_sink_single'),
                            \ 'down': '40%',
                            \ 'options': '--ansi --color hl+:255 --prompt "Cite> "'})<CR><CR>

    " ===================================================================================================

endif
