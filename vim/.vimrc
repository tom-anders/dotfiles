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

" Add line above or below current line
nnoremap <silent>{<space> :set paste<CR>m`O<Esc>``:set nopaste<CR>
nnoremap <silent>}<space> :set paste<CR>m`o<Esc>``:set nopaste<CR>

" Next/prev error in quickfix
nnoremap <silent> {e <C-w>j/error:<CR>N<CR>
nnoremap <silent> }e <C-W>j/error:<CR>n<CR>

nnoremap <silent> {t :tabprev<CR>
nnoremap <silent> }t :tabnext<CR>
nnoremap <silent> {T :tabfirst<CR>
nnoremap <silent> }T :tablast<CR>

function! NextWithWrap()
    execute 'try | next | catch | first | echo("At end of arglist, wrapping around") | endtry'
endfunction
function! PrevWithWrap()
    execute 'try | prev | catch | last | echo("At start of arglist, wrapping around") | endtry'
endfunction

nnoremap <silent> }a :call NextWithWrap()<CR>
nnoremap <silent> {a :call PrevWithWrap()<CR>

nmap <silent> <leader>tx :tabclose<cr>
nmap <silent> <leader>te :tabedit %<cr>

" Substitute word under cursor
nmap <leader>S :%s/\<<C-r><C-w>\>/

" Substitute word under cursor, use as backreference
nmap <leader><C-S> :%s/\(<C-r><C-w>\)/

" Substitute visual selection
vmap <leader>S y:%s/<C-r>0/

map <silent> <leader><leader>s :split<CR>
map <silent> <leader><leader>v :vsplit<CR>

"Clear search highlight
nnoremap <silent> <esc> :nohlsearch<CR>

" Normal gu is already taken by lsp
nnoremap <silent> <leader>gu gu
nnoremap <silent> <leader>gU gU

" {{{ Add C-d and C-u to the jump list, but only if pressed the first time
" https://vi.stackexchange.com/a/31212/34922
function! SaveJump(motion)
  if exists('#SaveJump#CursorMoved')
    autocmd! SaveJump
  else
    normal! m'
  endif
  let m = a:motion
  if v:count
    let m = v:count.m
  endif
  execute 'normal!' m
endfunction

function! SetJump()
  augroup SaveJump
    autocmd!
    autocmd CursorMoved * autocmd! SaveJump
  augroup END
endfunction

nnoremap <silent> <C-u> :<C-u>call SaveJump("\<lt>C-u>")<CR>:call SetJump()<CR>
nnoremap <silent> <C-d> :<C-u>call SaveJump("\<lt>C-d>")<CR>:call SetJump()<CR>
" }}} 

" }}}

call plug#begin('~/.vim/plugged')

" {{{ colorschemes
Plug 'altercation/vim-colors-solarized'
Plug 'morhetz/gruvbox'
Plug 'folke/tokyonight.nvim'
Plug 'dylanaraps/wal'
" }}}

" {{{ vim-highlightedyank
Plug 'machakann/vim-highlightedyank'
map y <Plug>(highlightedyank)
" }}}

Plug 'hoob3rt/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'

Plug 'romgrk/barbar.nvim'
let bufferline = get(g:, 'bufferline', {})
let bufferline.semantic_letters = v:false
let bufferline.animation = v:false
let bufferline.letters = 'asdfjklghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP'

nnoremap <silent> {b :BufferPrevious<CR>
nnoremap <silent> }b :BufferNext<CR>

nnoremap <silent> <leader>x :BufferClose<CR>
nnoremap <silent> <leader>o :BufferCloseAllButCurrent<CR>
nnoremap <silent> <leader>p :BufferPick<CR>
autocmd FileType qf set nobuflisted
autocmd FileType fugitive set nobuflisted

" git {{{
Plug 'tpope/vim-fugitive'
Plug 'tommcdo/vim-fugitive-blame-ext'
nn <silent> <leader>gs :Gstatus<cr>))
nn <silent> <leader>gb :Gblame<cr> 
" nn <silent> <leader>gd :Gdiff<cr> 
nn <silent> <leader>gw :Gwrite<cr> 
nn <silent> <leader>gD :Git! diff<cr> 
nn <silent> <leader><leader>g :Git 
nn <leader>gp :Git push<CR>
nn <leader>gf :Git fetch<CR>
nn <leader>gl :Git pull<CR>
"Ignore whitespace changes in diff
set diffopt+=iwhite 

" Quickly navigate hunks in status
autocmd FileType fugitive nmap J ]c
autocmd FileType fugitive nmap K [c

lua << EOF
function telescope_git_branches()
    require('telescope.builtin').git_branches {
        attach_mappings = function(_, map)
            map('i', '<CR>', require('telescope.actions').git_switch_branch)
            map('n', '<CR>', require('telescope.actions').git_switch_branch)

            return true
        end,
        previewer = false,
    }
end
EOF
nn <leader>gc :lua telescope_git_branches() <CR>

nnoremap <silent> <leader>dh :diffget //2 <CR> :diffup<CR>
nnoremap <silent> <leader>dl :diffget //3 <CR> :diffup<CR>

nnoremap <silent> {g [c
nnoremap <silent> }g ]c

Plug 'airblade/vim-gitgutter'
nmap <silent> <leader>hs :GitGutterStageHunk<CR>
nmap <silent> <leader>hu :GitGutterUndoHunk<CR>
nmap <silent> <leader>hp :GitGutterPreviewHunk<CR>

nnoremap {h :GitGutterPrevHunk<CR>
nnoremap }h :GitGutterNextHunk<CR>

" See diffviewConfig.lua
Plug 'sindrets/diffview.nvim'
nn <silent> <leader>gd :DiffviewOpen<CR>

" Needed since below we need to map J NON-recursively, but recursively to ]c and [c
nnoremap <Plug>(default-J) J
nnoremap <Plug>(default-K) K
nmap gK <Plug>(default-K)

" Use J and K to navigate hunks in diff
nmap <silent> <expr> J &diff ? ']c' : '<Plug>(default-J)'
nmap <silent> <expr> K &diff ? '[c' : ':lua vim.lsp.buf.hover()<CR>'

Plug 'codeindulgence/vim-tig'

let g:tig_default_command = ''

nnoremap <silent> <leader>tt :Tig <CR>
nnoremap <silent> <leader>ta :Tig --all <CR>

" Tig for current file
nnoremap <silent> <leader>tf :Tig!<CR>

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
" }}}

"{{{ hop.nvim
Plug 'phaazon/hop.nvim'
nn <leader>w :HopWord<CR>
nn <leader>j :HopLine<CR>
nn <leader>f :HopChar1<CR>
"}}}

"{{{ vim-sneak
Plug 'ggandor/lightspeed.nvim'
"}}}

Plug 'vim-scripts/ReplaceWithRegister'

" {{{ vim-bookmarks
Plug 'MattesGroeger/vim-bookmarks'
let g:bookmark_no_default_key_mappings = 1


nn <silent> <C-b>b :BookmarkToggle<CR>
nn <silent> <C-b>a :BookmarkAnnotate<CR>
nn <silent> <leader>cm :BookmarkShowAll<cr> :cclose<CR> :LspTrouble quickfix<cr>
nn <silent> <C-b>c :BookmarkClearAll<CR>

nn <silent> {m :BookmarkNext<CR>
nn <silent> }m :BookmarkPrev<CR>
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

Plug 'inside/vim-search-pulse'

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

" {{{ vim-grepper
Plug 'mhinz/vim-grepper'
let g:grepper = {}
let g:grepper.tools = ['rg']
let g:grepper.rg = {
        \ 'grepprg': 'rg -H --no-heading --vimgrep --smart-case',
        \ }

nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)

nnoremap <Leader>/ :Grepper<CR>
"}}}

Plug 'peterhoeg/vim-qml'
Plug 'arkbriar/vim-qmake'

" {{{ vim-lsp-cxx-highlight
Plug 'jackguo380/vim-lsp-cxx-highlight'
Plug 'tom-anders/clangd-nvim'
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
" }}}

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

let g:easy_align_delimiters = {
\ '<': { 'pattern': '<<' },
\ }

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
Plug 'bps/vim-textobj-python'
Plug 'glts/vim-textobj-comment' "ic and ac, this has to be loaded AFTER textobj-python, since that one also defines ic ac for python classes!
Plug 'kana/vim-textobj-indent'
Plug 'vim-scripts/argtextobj.vim'
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
Plug 'tom-anders/telescope.nvim'
Plug 'fhill2/telescope-ultisnips.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'tom-anders/telescope-vim-bookmarks.nvim'

map <silent> <leader>zf :Telescope find_files<cr>
map <silent> <leader>b :Telescope buffers<cr>
map <silent> <leader>zM :Telescope marks<cr>
map <silent> <leader>zg :Telescope live_grep<cr>
map <silent> <leader>zs :Telescope ultisnips ultisnips<cr>
map <silent> <leader>zh :Telescope oldfiles<cr>
map <silent> <leader>zc :Telescope quickfix<cr>
map <silent> <leader>zl :Telescope current_buffer_fuzzy_find<cr>
map <silent> <leader>zb :Telescope vim_bookmarks all<CR>

nmap <silent> <leader>F :lua gitFilesProximitySort({})<CR>
nmap <silent> <leader>f :lua gitFilesProximitySort(dropdownTheme{previewer=false, shorten_path=true})<CR>
nmap <silent> <leader>zt :lua findTestFile()<CR>
" }}}

Plug 'famiu/nvim-reload'
nnoremap <leader>rl :Restart<CR>


Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} 
Plug 'nvim-treesitter/playground'
Plug 'nvim-treesitter/nvim-treesitter-textobjects'

Plug 'neovim/nvim-lspconfig' 
nn <silent> <leader>rs :LspRestart<CR> :lua require'clangd_nvim'.reload()<CR>
Plug 'nvim-lua/lsp-status.nvim'

Plug 'folke/lsp-trouble.nvim'
nn <silent> <leader>q :LspTroubleClose<CR> :cclose<CR>
nn <silent> <leader>di :LspTroubleToggle lsp_document_diagnostics<CR>

Plug 'hrsh7th/vim-vsnip' " For lsp snippets
imap <expr> <C-j>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-j>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

Plug 'windwp/nvim-autopairs' 
Plug 'hrsh7th/nvim-compe'

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

" Some servers have issues with backup files, see #649. 
" TODO this is a relict from coc.nvim, do I still need this?
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

set signcolumn=yes
" }}}

"TODO replace this with chadtree
" nnoremap <silent> <leader>n :CocCommand explorer<CR>

" Using this in ftplugin/cpp.vim for opening floating windows for QFETCH selection
Plug 'kamykn/popup-menu.nvim'

call plug#end()

" Use vim-surround keymappings for vim-sandwich
runtime macros/sandwich/keymap/surround.vim

" {{{ lightspeed setup
lua << EOF
require'lightspeed'.setup {
    labels = {"j", "k", "h", "d", "s", "l", "a", "e", "i",
               "w", "o", "g", "v", "n", "c", "m", "z", "."},
    jump_to_first_match = false,
    cycle_group_fwd_key = ','
}
EOF
nmap <leader>s <Plug>Lightspeed_S
" }}}

" {{{ gruvbox setup
set termguicolors
let g:gruvbox_italic=1
let g:gruvbox_contrast_dark='hard'
" color gruvbox
let g:tokyonight_style='night'
let g:tokyonight_italic_keywords=v:false
color tokyonight
highlight Search gui=underline,bold

" execute 'hi HopNextKey gui=underline,bold guifg=' . g:terminal_color_9

" execute 'hi HopNextKey1 gui=bold guifg=' . g:terminal_color_11
" execute 'hi HopNextKey2 gui=bold guifg=' . g:terminal_color_9
" hi! link HopUnmatched Comment

" execute 'hi LightspeedLabel gui=bold guifg=' . g:terminal_color_11
" execute 'hi LightspeedShortcut guibg=NONE guifg=' . g:terminal_color_9
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

function! RemoveQfItem()
    let idx = line('.') - 1
    let qflist = getqflist()
    call remove(qflist, idx)
    call setqflist(qflist, 'r')

    execute "copen"
    " Go back to the idx we started at
    execute "normal " . idx . "j"
endfunction
autocmd FileType qf nnoremap <silent> <buffer> dd :call RemoveQfItem()<CR>

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

