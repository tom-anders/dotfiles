" {{{ General config

let mapleader = ' '
let maplocalleader = ' '

set hidden
set backspace=indent,eol,start

set mouse=a

set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab

set ignorecase
set smartcase

set nowrap
set scrolloff=2

set number
set relativenumber
syntax on

"yank to system clipboard (hopefully)
set clipboard^=unnamed,unnamedplus 

" }}}

" {{{ remaps

"increment/decrement
noremap + <C-a>
noremap - <C-x>

"traverse jump list
nnoremap <tab> <C-o>
nnoremap <s-tab> <C-i>

"map j to gj except when there is a count
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

" Search for visual selection
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

nnoremap <silent> [[ [[zz
nnoremap <silent> ]] ]]zz

nnoremap { <Nop>
nnoremap } <Nop>

nnoremap <silent> {l :lprev<CR>
nnoremap <silent> }l :lnext<CR>
nnoremap <silent> {L :lfirst<CR>
nnoremap <silent> }L :llast<CR>

nnoremap <silent> [q :colder<CR>
nnoremap <silent> ]q :cnewer<CR>
nnoremap <silent> {q :cprev<CR>
nnoremap <silent> }q :cnext<CR>
nnoremap <silent> {Q :cfirst<CR>
nnoremap <silent> }Q :clast<CR>

" Next/prev error in quickfix
nnoremap <silent> {e <C-w>j/error:<CR>N<CR>
nnoremap <silent> }e <C-W>j/error:<CR>n<CR>

" nnoremap <silent> {c :CocPrev<CR>
" nnoremap <silent> }c :CocNext<CR>
" nnoremap <silent> {C :CocFirst<CR>
" nnoremap <silent> }C :CocLast<CR>

nnoremap <silent> {t :tabprev<CR>
nnoremap <silent> }t :tabnext<CR>
nnoremap <silent> {T :tabfirst<CR>
nnoremap <silent> }T :tablast<CR>

nmap <silent> <leader>tx :tabclose<cr>
nmap <silent> <leader>te :tabedit %<cr>

" Substitute word under cursor
nmap <leader>S :%s/\<<C-r><C-w>\>/

" Substitute word under cursor, use as backreference
nmap <leader><C-S> :%s/\(<C-r><C-w>\)/

" Substitute visual selection
vmap <leader>S y:%s/<C-r>0/

nnoremap {b :bprev<CR>
nnoremap }b :bnext<CR>

" Close buffer without closing split
nmap <expr> <silent> <leader>x len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1 ? ':bd<CR>' : ':bp<CR>:bd #<CR>'

" Close all buffers except the current one 
" https://stackoverflow.com/questions/4545275/vim-close-all-buffers-but-this-one#comment86214068_42071865
nmap <leader>o :%bd\|e#\|bd#<cr>

map <silent> <leader><leader>s :split<CR>
map <silent> <leader><leader>v :vsplit<CR>

"Clear search highlight
nnoremap <silent> <esc> :nohlsearch<CR>

" Normal gu is already taken by lsp
nnoremap <silent> <leader>gu gu
nnoremap <silent> <leader>gU gU

" }}}

call plug#begin('~/.vim/plugged')

" {{{ colorschemes
Plug 'altercation/vim-colors-solarized'
Plug 'morhetz/gruvbox'
Plug 'dylanaraps/wal'
" }}}

" {{{ vim-highlightedyank
Plug 'machakann/vim-highlightedyank'
map y <Plug>(highlightedyank)
" }}}

" {{{ vim-lightline
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
set laststatus=2
set showtabline=2
set noshowmode
let g:lightline = {
\ 'colorscheme': 'gruvbox',
\ 'separator': { 'left': '', 'right': '' },
\ 'subseparator': { 'left': '', 'right': '' },
\ 'active': {
\   'left': [ [ 'mode', 'paste' ],
\             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
\   'right' : [ ['lineinfo'], ['filetype'] ]
\ },
\ 'tabline': {
\    'left': [ [ 'buffers' ] ],
\    'right': [ [ 'tabs' ] ],
\ },
\ 'component_expand': {
\   'buffers': 'lightline#bufferline#buffers'
\ },
\ 'component_type': {
\   'buffers': 'tabsel'
\ },
\ 'component_function': {
\   'gitbranch': 'FugitiveHead'
\ },
\ }
" }}}

" git {{{
Plug 'tpope/vim-fugitive'
Plug 'tommcdo/vim-fugitive-blame-ext'
nn <silent> <leader>gs :Gstatus<cr> 
nn <silent> <leader>gb :Gblame<cr> 
nn <silent> <leader>gd :Gdiff<cr> 
nn <silent> <leader>gw :Gwrite<cr> 
nn <silent> <leader>gD :Git! diff<cr> 
nn <silent> <leader><leader>g :Git 

nnoremap <silent> <leader>dh :diffget //2 <CR> :diffup<CR>
nnoremap <silent> <leader>dl :diffget //3 <CR> :diffup<CR>

nnoremap <silent> {g [c
nnoremap <silent> }g ]c

Plug 'mhinz/vim-signify'
nmap {h <Plug>(signify-prev-hunk)
nmap }h <Plug>(signify-next-hunk)
nmap <silent> <leader>ghd :SignifyHunkDiff<cr>
nmap <silent> <leader>ghu :SignifyHunkUndo<cr>

Plug 'iberianpig/tig-explorer.vim'

nnoremap <silent> <leader>tt :Tig <CR>
nnoremap <silent> <leader>ta :Tig --all <CR>

" Tig for current file
nnoremap <silent> <leader>tf :call tig_explorer#open(expand("%:p") . "--all")<cr>
" Tig for current dir
nnoremap <silent> <leader>T :call tig_explorer#open(expand("%:p:h") . " --all")<cr>

" }}}

Plug 'Valloric/ListToggle'
set noshowmode
let g:lt_quickfix_list_toggle_map = '<leader>cc'
let g:lt_location_list_toggle_map = '<leader>ll'

" :Au to toggle autosave
Plug 'vim-scripts/vim-auto-save'

" {{{ vim-sandwhich
Plug 'machakann/vim-sandwich'
" See https://github.com/machakann/vim-sandwich/issues/71
" Normally, for something like "std::move(x)" "dsf" would result in 
" "std::x". With this fix, we correctly get just "x" (But only if the cursor
" is somewhere on "std")
let g:sandwich#magicchar#f#patterns = [
  \   {
  \     'header' : '\h\k*::\h\k*::\h\k*',
  \     'bra'    : '(',
  \     'ket'    : ')',
  \     'footer' : '',
  \   },
  \   {
  \     'header' : '\h\k*::\h\k*',
  \     'bra'    : '(',
  \     'ket'    : ')',
  \     'footer' : '',
  \   },
  \   {
  \     'header' : '\h\k*',
  \     'bra'    : '(',
  \     'ket'    : ')',
  \     'footer' : '',
  \   },
  \ ]
nmap s ys
" }}}

"{{{ vim-easymotion
Plug 'easymotion/vim-easymotion'
" Keep <leader><leader> as default prefix (e.g. since <leader>f is already
" :GFiles for me), but for letters that I have not yet remapped to something
" else use easymotion
map <leader><leader> <Plug>(easymotion-prefix)
map <leader>j <Plug>(easymotion-j)
map <leader>k <Plug>(easymotion-k)
map <leader>e <Plug>(easymotion-e)
map <leader>E <Plug>(easymotion-E)
map <leader>b <Plug>(easymotion-b)
map <leader>B <Plug>(easymotion-B)
map <leader>w <Plug>(easymotion-w)
map <leader>W <Plug>(easymotion-W)
map <leader>s <Plug>(easymotion-s)

let g:EasyMotion_keys = 'asdghklqwertyuiopzxcvbnmfj'

" autocmd User EasyMotionPromptBegin silent! CocDisable
" autocmd User EasyMotionPromptEnd silent! call timer_start(500, { tid -> execute('CocEnable')}) 
"}}}

Plug 'vim-scripts/ReplaceWithRegister'

" {{{ vim-bookmarks
Plug 'MattesGroeger/vim-bookmarks'
let g:bookmark_no_default_key_mappings = 1


" TODO these are broken somehow
" nn <silent> <C-m>m :BookmarkToggle<CR>
" nn <C-m>a :BookmarkAnnotate 
" nn <silent> <leader>cm :BookmarkShowAll<CR>
" nnoremap <silent> <C-m>c :BookmarkClearAll<CR>
" }}}

" {{{ vim-peekaboo
Plug 'junegunn/vim-peekaboo'
" See https://github.com/junegunn/vim-peekaboo/issues/68#issuecomment-622601779
function! CreateCenteredFloatingWindow()
    let width = float2nr(&columns * 0.8)
    let height = float2nr(&lines * 0.6)
    let top = ((&lines - height) / 2) - 1
    let left = (&columns - width) / 2
    let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal'}

    let top = "╭" . repeat("─", width - 2) . "╮"
    let mid = "│" . repeat(" ", width - 2) . "│"
    let bot = "╰" . repeat("─", width - 2) . "╯"
    let lines = [top] + repeat([mid], height - 2) + [bot]
    let s:buf = nvim_create_buf(v:false, v:true)
    call nvim_buf_set_lines(s:buf, 0, -1, v:true, lines)
    call nvim_open_win(s:buf, v:true, opts)
    set winhl=Normal:Floating
    let opts.row += 1
    let opts.height -= 2
    let opts.col += 2
    let opts.width -= 4
    call nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
    au BufWipeout <buffer> exe 'bw '.s:buf
endfunction
let g:peekaboo_window="call CreateCenteredFloatingWindow()"
" }}}

Plug 'tommcdo/vim-exchange'
Plug 'tpope/vim-repeat'
Plug 'triglav/vim-visual-increment'

if v:servername == ''
    call serverstart(tempname())
endif
let &titlestring="nvim %F -- [" . v:servername . "]"
set title

" {{{ i3wm integration
" Plug 'termhn/i3-vim-nav'
" nmap <silent> <C-M-l> <C-l>
" nmap <silent> <C-M-h> <C-h>
" nmap <silent> <C-M-k> <C-k>
" nmap <silent> <C-M-j> <C-j>
" nnoremap <silent> <C-l> :call Focus('right', 'l')<CR>
" nnoremap <silent> <C-h> :call Focus('left', 'h')<CR>
" nnoremap <silent> <C-k> :call Focus('up', 'k')<CR>
" nnoremap <silent> <C-j> :call Focus('down', 'j')<CR>
" }}}

" {{{ ack.vim (Configured to use rg)
Plug 'mileszs/ack.vim'
" Use ripgrep with ack.vim
let g:ackprg = 'rg --vimgrep --type-not sql --smart-case'
" Any empty ack search will search for the work the cursor is on
let g:ack_use_cword_for_empty_search = 1
let g:ackhighlight = 1
" The exclamation mark means don't jump to first match
nnoremap <Leader>/ :Ack!<Space>
"}}}

Plug 'peterhoeg/vim-qml'
Plug 'arkbriar/vim-qmake'

" {{{ vim-lsp-cxx-highlight
Plug 'jackguo380/vim-lsp-cxx-highlight'
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
" }}}

Plug 'ryanoasis/vim-devicons'

" {{{ vim-commentary
Plug 'tpope/vim-commentary'
"Matlab comments
autocmd FileType matlab setlocal commentstring=%\ %s
"Gnuplot comments
autocmd FileType gnuplot setlocal commentstring=#\ %s
"C++ comments
autocmd FileType cpp setlocal commentstring=//\ %s
" }}}


" {{{ vim-dispatch
Plug 'tpope/vim-dispatch'
map <leader>cd :Copen<CR>/error:<CR>
map <leader>m :wa<CR>:Make<CR>
map <leader>M :wa<CR>:Make!<CR>
" }}}

" {{{ ultisnips
" Put snippets into .vim/Ultisnips
Plug 'SirVer/ultisnips'
let g:UltiSnipsExpandTrigger="<C-space>"
let g:UltiSnipsJumpForwardTrigger="<C-j>"
let g:UltiSnipsJumpBackwardTrigger="<C-M-J>"

autocmd BufEnter,BufNew *.snippets setlocal foldmethod=marker

" }}}

" {{{ vim-easy-align
Plug 'junegunn/vim-easy-align'
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
" }}}

" {{{ fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'tom-anders/fzf.vim'

Plug 'yuki-yano/fzf-preview.vim', { 'branch': 'release/rpc' }
let $FZF_PREVIEW_PREVIEW_BAT_THEME = 'gruvbox-dark'

map <silent> <leader>zf :Files<cr>
map <silent> <leader><leader>b :Buffers<cr>
map <silent> <leader>zM :Marks<cr>
map <silent> <leader>zl :Lines<cr>
map <silent> <leader>zg :Rg<cr>
map <silent> <leader>zs :Snippets<cr>
map <silent> <leader>zh :History<cr>
map <silent> <leader>zc :FzfPreviewQuickFixRpc<cr>
map <silent> <leader>zm :FzfPreviewBookmarksRpc<cr>

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
let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all --bind ctrl-s:select'

" fzf with git ls-files, but only display file name instead of full path
" This works by piping both the filename and the fullpath to fzf and then
" using --with-nth=1 to only display the filename. The sink function then
" extracts the full path so that we can open it as usual
function! s:gitFilesBasename()
    let base = fnamemodify(expand('%'), ':h:.:S')
    let sortCmd = '|'
    if base == '.'
        let sortCmd = '| ~/.cargo/bin/proximity-sort ' . base . ' | '
    endif

    call fzf#run(fzf#wrap({'options': ['--with-nth=1', '--preview', '~/.dotfiles/vim/previewSecondArg.sh {}'], 'source': 'git ls-files --recurse-submodules $(git rev-parse --show-toplevel)' . sortCmd . 'while read -r line ; do printf "%s %s\n" $(basename $line) $line; done', 'sink': function('s:gitFilesBasenameSink')}))
endfunction
function! s:gitFilesBasenameSink(file)
    execute "edit ".split(a:file)[1]
endfunction
nmap <silent> <leader>f :call <SID>gitFilesBasename()<cr> 

nmap <silent> <leader><M-f> :GFiles --recurse-submodules <cr> 

" }}}

" {{{ undotree
Plug 'mbbill/undotree'
"toggle undotree
map <leader>uu :UndotreeToggle<cr>
map <leader>uf :UndotreeFocus<cr>
" }}}

" asciidoctor {{{
Plug 'habamax/vim-asciidoctor'
Plug 'aklt/plantuml-syntax'
let g:asciidoctor_pdf_extensions = ['asciidoctor-diagram']

let g:asciidoctor_folding = 1
let g:asciidoctor_fold_options = 1
autocmd FileType asciidoctor set foldlevel=99 "Open all folds by default

let g:asciidoctor_fenced_languages = ['python', 'c', 'cpp', 'json', 'plantuml']
let g:asciidoctor_syntax_conceal = 1
autocmd FileType asciidoctor set conceallevel=2 

autocmd FileType asciidoctor set textwidth=120
autocmd FileType asciidoctor set colorcolumn=121
autocmd FileType asciidoctor set wrap
" Add indent for labeled lists (XY:: etc.)
autocmd FileType asciidoctor set formatlistpat+=\\\|^.*::\\+\\s\\+
"}}}

" {{{ Text ojects
Plug 'kana/vim-textobj-user'
Plug 'https://github.com/vim-scripts/argtextobj.vim'
Plug 'bps/vim-textobj-python'
Plug 'glts/vim-textobj-comment' "ic and ac, this has to be loaded AFTER textobj-python, since that one also defines ic ac for python classes!
" }}}

" {{{ Folding
Plug 'Konfekt/FastFold'
"toggle folds
map <C-a> zA

autocmd Filetype vim set foldmethod=marker
" }}}

" {{{ telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
" }}}

Plug 'neovim/nvim-lspconfig' 

Plug 'hrsh7th/vim-vsnip' " For lsp snippets
imap <expr> <C-j>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-j>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

Plug 'cohama/lexima.vim' " Autoclose braces etc.
Plug 'tom-anders/nvim-compe'

Plug 'ray-x/lsp_signature.nvim'

" set completeopt=noinsert,menuone
set completeopt=menuone,noselect
" set completeopt=menuone
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')

" :XtermColorTable
Plug 'guns/xterm-color-table.vim'


" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? "\<C-n>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" function! s:check_back_space() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~# '\s'
" endfunction

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
" inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              " \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
" nmap <silent> {d <Plug>(coc-diagnostic-prev)
" nmap <silent> }d <Plug>(coc-diagnostic-next)

" nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gu <Plug>(coc-references)
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)

" nmap <silent> <C-k> :CocList --interactive --auto-preview symbols<CR>
" nmap <silent> <leader>. :CocList --auto-preview outline<CR>

" nmap <silent> <leader>di :CocList --auto-preview --normal diagnostics<CR>

" " Not s
" nmap <silent> gy <Plug>(coc-type-definition)

" " grep word under cursor
" nnoremap <silent> <Leader>cgw :exe 'CocList --auto-preview --normal --input='.expand('<cword>').' grep'<CR>

" " General grep
" nnoremap  <Leader>cgr :CocList --auto-preview --normal grep 

" " Use K to show documentation in preview window.
" nnoremap <silent> K :call <SID>show_documentation()<CR>

" function! s:show_documentation()
"   if (index(['vim','help'], &filetype) >= 0)
"     execute 'h '.expand('<cword>')
"   else
"     call CocActionAsync('doHover')
"   endif
" endfunction

" " Highlight the symbol and its references when holding the cursor.
" autocmd CursorHold * silent call CocActionAsync('highlight')
" " Show signature help in insert mode on cursor hold
" autocmd CursorHoldI * silent call CocActionAsync('showSignatureHelp')

" " Update signature help on jump placeholder.
" autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
" let g:coc_snippet_next="<tab>"
" let g:coc_snippet_prev="<S-tab>"

" " Symbol renaming.
" nmap <leader>rn <Plug>(coc-rename)

" nmap <silent> <leader>rs :CocRestart<cr>

" " Applying codeAction to the selected region.
" " Example: `<leader>aap` for current paragraph
" xmap <leader>ca  <Plug>(coc-codeaction-selected)
" nmap <leader>ca  <Plug>(coc-codeaction-selected)

" " Remap keys for applying codeAction to the current buffer.
" nmap <leader>ac  <Plug>(coc-codeaction)
" " Apply AutoFix to problem on the current line.
" nmap <leader>qf  <Plug>(coc-fix-current)

" " Map function and class text objects
" " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
" xmap if <Plug>(coc-funcobj-i)
" omap if <Plug>(coc-funcobj-i)
" xmap af <Plug>(coc-funcobj-a)
" omap af <Plug>(coc-funcobj-a)
" xmap ic <Plug>(coc-classobj-i)
" omap ic <Plug>(coc-classobj-i)
" xmap ac <Plug>(coc-classobj-a)
" omap ac <Plug>(coc-classobj-a)

" " Add `:Format` command to format current buffer.
" command! -nargs=0 Format :call CocAction('format')

" " Add `:Fold` command to fold current buffer.
" command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" " Add `:OR` command for organize imports of the current buffer.
" command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" " Add (Neo)Vim's native statusline support.
" " NOTE: Please see `:h coc-status` for integrations with external plugins that
" " provide custom statusline: lightline.vim, vim-airline.
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" " Toggle coc-explorer. <leader>n is a relict from my memonic for NERDTree
" nnoremap <silent> <leader>n :CocCommand explorer<CR>

" }}}

" Using this in ftplugin/cpp.vim for opening floating windows for QFETCH selection
Plug 'kamykn/popup-menu.nvim'

call plug#end()

" Use vim-surround keymappings for vim-sandwich
runtime macros/sandwich/keymap/surround.vim

" {{{ gruvbox setup
set termguicolors
let g:gruvbox_italic=1
let g:gruvbox_contrast_dark='hard'
color gruvbox
" }}}

" {{{ Quickfix/CocList mappings
nnoremap <silent> <leader>co :CocListResume<CR>

" Go up/down in quickfix and keep it focused
autocmd FileType qf nnoremap <silent> <buffer> J :cnext<CR><C-W><C-P>
autocmd FileType qf nnoremap <silent> <buffer> K :cprev<CR><C-W><C-P>

autocmd FileType qf nnoremap <silent> <buffer> q :cclose<CR>

autocmd FileType qf nnoremap <silent> <buffer> <leader>n /error:<CR>

" Open result in new split
autocmd FileType qf nnoremap <silent> <buffer> <leader><CR> <C-w><Enter><C-w>L

" }}}

" For some reason, putting this into ftplugin/cpp.vim does not work
autocmd FileType cpp set comments^=:///

" {{{ Handling external file changes
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
" }}}

" {{{ Source work config
if !empty(glob("~/.work.vim"))
    source ~/.work.vim
endif
" }}}

" {{{ Expanding autocomplete
let g:lexima_no_default_rules = v:true
call lexima#set_default_rules()
inoremap <silent><expr> <CR>      compe#confirm(lexima#expand('<LT>CR>', 'i'))
" }}}
