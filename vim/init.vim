set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

" lua require('lspConfig')
luafile ~/.config/nvim/lua/lspConfig.lua

luafile ~/.config/nvim/lua/telescopeConfig.lua

luafile ~/.config/nvim/lua/lualineConfig.lua

luafile ~/.config/nvim/lua/treesitterConfig.lua

luafile ~/.config/nvim/lua/compeConfig.lua
