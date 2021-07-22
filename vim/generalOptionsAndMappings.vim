" Options and mappings that don't rely on any plugins

" {{{ General options 

let mapleader = ' '
let maplocalleader = ' '

set hidden
set backspace=indent,eol,start

set splitright

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

augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=500 }
augroup END

" Some servers have issues with backup files, see #649. 
" TODO this is a relict from coc.nvim, do I still need this?
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

set signcolumn=yes

" For easy-i3-neovim-nav
if v:servername == ''
    call serverstart(tempname())
endif
let &titlestring="nvim %F -- [" . v:servername . "]"
set title

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

" vim: foldmarker={{{,}}} foldmethod=marker
