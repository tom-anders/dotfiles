set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

nnoremap <leader>so :so $MYVIMRC<CR>

lua << EOF
vim.g.completion_chain_complete_list = {
  default = {
    { complete_items = { 'lsp' } },
    { complete_items = { 'buffers' } },
    { mode = { '<c-p>' } },
    { mode = { '<c-n>' } }
  },
}



vim.g.completion_items_priority = {
    Method = 10,
    Field = 9,
    Property = 9,
    Variables = 6,
    Function = 7,
    Interfaces = 6,
    Constant = 6,
    Class = 6,
    Struct = 6,
    Keyword = 5,
    Treesitter = 4,
    Buffers  = 0,
    TabNine  = 1,
    File  = 2,
}
EOF


" lua require('lspConfig')
luafile ~/.config/nvim/lua/lspConfig.lua

luafile ~/.config/nvim/lua/telescopeConfig.lua

luafile ~/.config/nvim/lua/lualineConfig.lua

luafile ~/.config/nvim/lua/treesitterConfig.lua
