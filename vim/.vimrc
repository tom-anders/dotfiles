call plug#begin('~/.vim/plugged')
Plug 'altercation/vim-colors-solarized'
Plug 'morhetz/gruvbox'

Plug 'machakann/vim-highlightedyank'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'tommcdo/vim-fugitive-blame-ext'
Plug 'vim-scripts/vim-auto-save'
Plug 'tpope/vim-surround'
Plug 'vim-scripts/ReplaceWithRegister'

Plug 'termhn/i3-vim-nav'

Plug 'junegunn/vim-peekaboo'

" Coc plugins:
" - coc-pairs
" - coc-clangd
" - coc-lists
" - coc-ultisnips
" - coc-explorer

Plug 'mileszs/ack.vim'

Plug 'peterhoeg/vim-qml'
Plug 'arkbriar/vim-qmake'

Plug 'jackguo380/vim-lsp-cxx-highlight'
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1

Plug 'ryanoasis/vim-devicons'

Plug 'dylanaraps/wal'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'airblade/vim-gitgutter'
Plug 'justinmk/vim-sneak'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'tommcdo/vim-exchange'
Plug 'junegunn/vim-easy-align'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'liuchengxu/vista.vim'

Plug 'mbbill/undotree'

Plug 'habamax/vim-asciidoctor'
Plug 'aklt/plantuml-syntax'

"Text ojects
Plug 'kana/vim-textobj-user'
Plug 'https://github.com/vim-scripts/argtextobj.vim'
Plug 'bps/vim-textobj-python'
Plug 'glts/vim-textobj-comment' "ic and ac, this has to be loaded AFTER textobj-python, since that one also defines ic ac for python classes!

Plug 'triglav/vim-visual-increment'

" :XtermColorTable
Plug 'guns/xterm-color-table.vim'

" Disable duplicate linters
let g:ale_linters_ignore = {
      \   'cpp': ['ccls', 'clangcheck'],
      \}
let g:ale_cpp_clangtidy_checks=["-clang-diagnostic-*,modernize*,-modernize-use-trailing-return-type,bugprone*,performance*,readability*,cppcoreguidelines*,misc*"]
let g:ale_disable_lsp = 1
let g:ale_set_highlights=0

let g:ale_virtualtext_cursor=1

Plug 'dense-analysis/ale'

Plug 'neoclide/coc.nvim', { 'branch': 'release' }
set completeopt=noinsert,menuone,noselect

let hostname=hostname()

call plug#end()

"Colorscheme depending on computer 
if hostname == "arch-laptop" || hostname == "tom-linux"
    color wal
else
    color solarized
    " color gruvbox
endif

let mapleader = ' '
let maplocalleader = ' '

set nowrap
set scrolloff=2

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
  inoremap <silent><expr> <c-c> coc#refresh()
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

nnoremap <leader>ad :ALEDetail<cr>

" Explicitly call ccls here (instead of just coc-definition),
" because otherwise we'd also get duplicate results from clangd
nmap <silent> gd :call CocLocations('ccls','textDocument/definition')<cr>
" And same for find references
nmap <silent> gu :call CocLocations('ccls','textDocument/references')<cr>
" Go to base class definitions
nmap <silent> gb :call CocLocations('ccls','$ccls/inheritance',{'levels':5})<cr>
" Go to derived class definitions
nmap <silent> gi :call CocLocations('ccls','$ccls/inheritance',{'derived':v:true, 'levels':5})<cr>

nmap <silent> <leader>sy :CocList --interactive --auto-preview symbols<CR>
nmap <silent> <leader>. :CocList --auto-preview outline<CR>

nmap <silent> <leader>di :CocList --auto-preview --normal diagnostics<CR>

" Not s
nmap <silent> gy <Plug>(coc-type-definition)

" grep word under cursor
command! -nargs=+ -complete=custom,s:GrepArgs Rg exe 'CocList grep '.<q-args>
function! s:GrepArgs(...)
  let list = ['-S', '-smartcase', '-i', '-ignorecase', '-w', '-word',
        \ '-e', '-regex', '-u', '-skip-vcs-ignores', '-t', '-extension']
  return join(list, "\n")
endfunction
nnoremap <silent> <Leader>cgw :exe 'CocList --auto-preview --normal --input='.expand('<cword>').' grep'<CR>

" General grep
nnoremap  <Leader>cgr :CocList --auto-preview --normal grep 

" Use ripgrep with ack.vim
let g:ackprg = 'rg --vimgrep --type-not sql --smart-case'
" Any empty ack search will search for the work the cursor is on
let g:ack_use_cword_for_empty_search = 1
let g:ackhighlight = 1
" Don't jump to first match
nnoremap <Leader>/ :Ack!<Space>

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
" Show signature help in insert mode on cursor hold
autocmd CursorHoldI * silent call CocActionAsync('showSignatureHelp')
" And also show it immediately when entering insert mode, very useful when editing parameters
autocmd InsertEnter * silent call CocActionAsync('showSignatureHelp')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

autocmd FileType cpp nmap gh :CocCommand clangd.switchSourceHeader<CR>

autocmd FileType cpp,c set textwidth=120
autocmd FileType cpp,c set colorcolumn=+1

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

let g:coc_snippet_next="<tab>"
let g:coc_snippet_prev="<S-tab>"

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

"--------------------------------------------------------------

" Vista.vim config
let g:vista_fzf_preview = ['right:50%']
let g:vista_sidebar_width = 50

function! NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction
set statusline+=%{NearestMethodOrFunction()}
autocmd VimEnter * call vista#RunForNearestMethodOrFunction()

let g:vista_executive_for = {
  \ 'cpp': 'coc',
  \ }

map <leader>v :Vista!!<CR>
"--------------------------------------------------------------

" Quickfix mappings
map <C-n> :cnext<CR>
map <C-b> :cprev<CR>
function! ToggleQuickFix()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
        copen
    else
        cclose
    endif
endfunction
nnoremap <silent> <leader>cc :call ToggleQuickFix()<cr>

map <C-M-n> :CocNext<CR>
map <C-M-b> :CocPrev<CR>
nnoremap <silent> <leader>co :CocListResume<CR>

" Go up/down in quickfix and keep it focused
autocmd FileType qf nnoremap <buffer> <Down> :cnext<CR><C-W><C-P>
autocmd FileType qf nnoremap <buffer> <Up> :cprev<CR><C-W><C-P>

"toggle folds
map <leader><leader> za

"toggle undotree
map <leader>uu :UndotreeToggle<cr>
map <leader>uf :UndotreeFocus<cr>

"Mappings for switching buffers
map <leader>bn :bn<cr>
map <leader>bv :bp<cr>
map <leader>bd :bd<cr>
nnoremap <leader>wq :w\|bd<cr>

" i3 integration
set title titlestring=nvim
nmap <silent> <C-M-l> <C-l>
nmap <silent> <C-M-h> <C-h>
nmap <silent> <C-M-k> <C-k>
nmap <silent> <C-M-j> <C-j>
nnoremap <silent> <C-l> :call Focus('right', 'l')<CR>
nnoremap <silent> <C-h> :call Focus('left', 'h')<CR>
nnoremap <silent> <C-k> :call Focus('up', 'k')<CR>
nnoremap <silent> <C-j> :call Focus('down', 'j')<CR>

" CTRL-a CTRL-q to select all and build quickfix list (https://github.com/junegunn/fzf.vim/issues/185)
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

"Mappings for fzf.vim
map <silent> <leader>f :GFiles --recurse-submodules <cr> 
map <silent> <leader>zf :Files<cr>
map <silent> <leader>zb :Buffers<cr>
map <silent> <leader>zm :Marks<cr>
map <silent> <leader>zl :Lines<cr>
map <silent> <leader>zg :Rg<cr>

" Fugitive mappings
map <silent> <leader>gs :Gstatus<cr> 
map <silent> <leader>gb :Gblame<cr> 

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

if hostname == "stefan-schumacher11.uni-paderborn.de" 
    let g:UltiSnipsExpandTrigger="<tab>"
    let g:UltiSnipsJumpForwardTrigger="<tab>"
else 
    let g:UltiSnipsExpandTrigger="<C-space>"
    let g:UltiSnipsJumpForwardTrigger="<tab>"
    let g:UltiSnipsJumpBackwardTrigger="<S-tab>"
endif

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

"Matlab comments
autocmd FileType matlab setlocal commentstring=%\ %s
"Gnuplot comments
autocmd FileType gnuplot setlocal commentstring=#\ %s
"C++ comments
autocmd FileType cpp setlocal commentstring=//\ %s

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

" Set this. Airline will handle the rest.
let g:airline#extensions#ale#enabled = 1

"map j to gj except when there is a count!
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

"yank to system clipboard (hopefully)
set clipboard^=unnamed,unnamedplus 

" asciidoctor ---------------------------------------------------------
let g:asciidoctor_pdf_extensions = ['asciidoctor-diagram']

let g:asciidoctor_folding = 1
let g:asciidoctor_fold_options = 1
autocmd FileType asciidoctor set foldlevel=99 "Open all folds by default

let g:asciidoctor_fenced_languages = ['python', 'c', 'cpp', 'json', 'plantuml']
let g:asciidoctor_syntax_conceal = 1
autocmd FileType asciidoctor set conceallevel=2 

autocmd FileType asciidoctor set textwidth=120
autocmd FileType asciidoctor set wrap
" Add indent for labeled lists (XY:: etc.)
autocmd FileType asciidoctor set formatlistpat+=\\\|^.*::\\+\\s\\+
" ---------------------------------------------------------------------------

" Don't indent after C++ namespace start
set cino=N-s

highlight LspCxxHlSymParameter ctermfg=6 cterm=italic
highlight LspCxxHlSymField ctermfg=4

highlight LspCxxHlSymMethod ctermfg=7
highlight LspCxxHlSymFunction ctermfg=7 cterm=italic

highlight LspCxxHlSymNamespace ctermfg=136 
highlight LspCxxHlSymClass ctermfg=136 cterm=bold
highlight LspCxxHlSymEnum ctermfg=136 cterm=bold,italic

highlight cConditional ctermfg=64 cterm=bold
highlight cRepeat ctermfg=64 cterm=bold
highlight cStorageClass ctermfg=64 cterm=bold,italic
highlight cppConstant ctermfg=64 cterm=bold,italic
highlight cppStatement ctermfg=64 cterm=bold,italic
highlight cppBoolean ctermfg=64 cterm=bold,italic
highlight type ctermfg=64 cterm=bold

highlight cString ctermfg=9
highlight cppNumber ctermfg=9

highlight LspCxxHlSymVariable ctermfg=9
highlight LspCxxHlSymUnknownStaticField ctermfg=9
highlight LspCxxHlSymStaticMethod ctermfg=9 cterm=italic

let g:lsp_cxx_hl_use_text_props=1

map <leader>hi :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Triger `autoread` when files changes on disk
" https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
" https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
    autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
            \ if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif

" Notification after file change
" https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
set autoread
autocmd FileChangedShellPost *
  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

" vim-dispatch
map <leader>cd :Copen<CR>/error:<CR>
map <leader>m :wa<CR>:Make<CR>
map <leader>M :wa<CR>:Make!<CR>

" Toggle coc-explorer. <leader>n is a relict from my memonic for NERDTree
nnoremap <silent> <leader>n :CocCommand explorer<CR>

nnoremap <leader>so :so $MYVIMRC<CR>

" Search for visual selection
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

if !empty(glob("~/.work.vim"))
    source ~/.work.vim
endif

nnoremap [[ [[zz
nnoremap ]] ]]zz


" In cpp files, use coc-nvim's folding to only fold methods
au BufEnter,BufNew *.cpp set foldmethod=manual

" Close folds
nnoremap <leader>cf zM
au BufEnter,BufNew *.cpp nnoremap <silent> <leader>cf :Fold<CR>zM
" Open folds
nnoremap <silent> <leader>of zR

autocmd Filetype cpp set comments^=:///
let g:load_doxygen_syntax=1

au BufEnter,BufNew *.hpp,*.h set foldmethod=expr
au BufEnter,BufNew *.hpp,*.h set foldexpr=FoldDoxygen(v:lnum)
au BufEnter,BufNew *.hpp,*.h set foldtext=DoxygenFoldText()

" adapted from https://github.com/brobeson/Tools/blob/master/vim/vim/ftplugin/cpp_doxygen.vim
function DoxygenFoldText()
    " assume this isn't a Doxygen comment
    let fold_text = ''

    " get the first line. we need it to determine what type of fold text
    " to create.
    let first_line = getline(v:foldstart)

    let isCStyle = match(first_line, '^\s*\/\*[!\*]') == 0
    let isCppStyle = match(first_line, '\v\s*///') == 0

    " Doxygen comment blocks
    if isCStyle || isCppStyle
        if isCStyle
            " put a space between /** and the brief text. also, remove any
            " text after the /**.
            let fold_text = substitute(first_line, '\(\/\*[!\*]\).*', '\1 ', '')
        else
            " let fold_text = substitute(first_line, '\v///.*', '/// \1 ', '')
            let fold_text = first_line
        endif

        let comments = getline(v:foldstart, v:foldend)

        " remove leading *s and white space from subsequent lines in
        " the comments. note that we can't use
        " 'for comment in comments' here; the assignment in the loop
        " would assign to a copy, not the actual list item.
        let startRegex = isCStyle ? '^\s*\*\?\s*' : '\v^\s*///\s*'
        for i in range(1, len(comments) - 1)
            let comments[i] = substitute(comments[i], startRegex, '', '')
        endfor

        " locate the brief text in the comment. the brief text goes from
        " '@brief' (or '\brief') until the next '@' (or '\').  get all
        " the lines in the block comment, then find the line which
        " contains the 'brief' tag.
        let brief_start = match(comments, '[@|\\]\(\(copy\)\?brief\|copydoc\)')

        " if the brief tag was found...
        if 0 <= brief_start
            " find the end of the brief description. this occurs when:
            " 1 - the next Doxygen command is found,
            " 2 - a blank line occurs after the brief text
            " then crop the comments array, so we only have the brief text
            let comments = comments[brief_start : match(comments, '\([@|\\]\|^\s*$\)', brief_start + 1) - 1]

            if isCppStyle
                let fold_text = substitute(comments[0], '[@\\]brief\s*', '', '')
            else
                " from the first brief line, remove everything except the
                " actual text: ' * @brief blah' becomes 'blah'
                let comments[0] = substitute(comments[0], '^.*[@\\]brief\s*', '', '')

                let fold_text .= join(comments) . ' */'
            endif

            " if a brief command wasn't found, it's possible for a Javadoc
            " style comment to use the first sentence as the brief comment.
        else
            let brief_start = match(comments, '\w.*')
            if isCStyle
                if 0 <= brief_start
                    " this match is a bit tricky. the Javadoc auto brief ends
                    " with the first period. then, in case there are two
                    " periods on the end line, remove the extra words.
                    let comments = comments[brief_start : match(comments, '.', brief_start)]
                    let fold_text .= substitute(join(comments), '\..*$', '\. \*\/', '')
                else
                    let fold_text .= 'no brief description */'
                endif
            elseif isCppStyle
                " Don't really care here, just use the first line and be done
                " with it
                let comments = comments[brief_start : match(comments, '.', brief_start)]
                let fold_text = comments[0]

            " if no brief text was found, set the fold text to that fact
            else
                let fold_text .= 'no brief description */'
            endif
    endif

    return fold_text
endfunction

function! FoldDoxygen(lnum)
    let line = getline(a:lnum)

    " cpp-style
    if line =~ '\v^\s*//[!/].*$'
        return '1'
    endif
    
    " c-style
    if line =~ '\v^\s*/\*[\*!].*$'
        return '1'
    endif
    if line =~ '\v^\s*\*/.*$'
        return '1'
    endif
    if line =~ '\v^\s*\*.*$'
        return '-1'
    endif

    return '0'
endfunction
