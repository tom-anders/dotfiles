require('packer').startup(function()
    use "wbthomason/packer.nvim"

    -- {{{ tokyonight
    use {'folke/tokyonight.nvim', config = function() 
        vim.cmd [[set termguicolors]]
        vim.g.tokyonight_style = 'night'
        vim.g.tokyonight_italic_keywords = false
        vim.cmd [[color tokyonight]]
    end, opt=false}
    -- }}}

    -- {{{ Syntax files
    use 'peterhoeg/vim-qml'
    use 'arkbriar/vim-qmake'
    -- }}}

    -- {{{ vim-dispatch
    use {'tpope/vim-dispatch', config = function() 
        vim.cmd[[ map <leader>cd :Copen<CR>/error:<CR> ]]
        vim.cmd[[ map <leader>m :wa<CR>:Make<CR> ]]
        vim.cmd[[ map <leader>M :wa<CR>:Make!<CR> ]]
    end}
    -- }}}

    -- {{{ vim-easy-align
    use {'junegunn/vim-easy-align', config = function()
        -- Start interactive EasyAlign in visual mode (e.g. vipga)
        vim.cmd[[xmap ga <Plug>(EasyAlign)]]
        -- Start interactive EasyAlign for a motion/text object (e.g. gaip)
        vim.cmd[[nmap ga <Plug>(EasyAlign)]]

        vim.cmd[[let g:easy_align_delimiters = { '<': { 'pattern': '<<' } }]]
    end}
    -- }}}
    
    use 'mbbill/undotree'

    -- {{{ Text ojects
    use 'kana/vim-textobj-user'
    use 'bps/vim-textobj-python'
    use 'glts/vim-textobj-comment' -- ic and ac, this has to be loaded AFTER textobj-python, since that one also defines ic ac for python classes!
    use 'kana/vim-textobj-indent'
    -- }}}

    use 'Konfekt/FastFold'

    use {'famiu/nvim-reload', config = function()
        vim.cmd[[nnoremap <leader>rl :Restart<CR>]]
    end}

    -- {{{ ultisnips
    -- Put snippets into .vim/Ultisnips
    use {'SirVer/ultisnips', config = function() 
        vim.g.UltiSnipsExpandTrigger="<C-space>"
        vim.g.UltiSnipsJumpBackwardTrigger="<C-M-J>"

        vim.cmd[[autocmd BufEnter,BufNew *.snippets setlocal foldmethod=marker]]
    end}

    -- }}}

    use 'tpope/vim-commentary'

    -- {{{ lualine
    use {'hoob3rt/lualine.nvim', config = function() 
        function CurrentFunction() 
            return vim.fn['nvim_treesitter#statusline']()
        end

        require('lualine').setup{
            options = {
                theme = 'tokyonight',
            },
            sections = {lualine_c = {'filename', CurrentFunction}}
        }
    end}
    -- }}}

    use 'kyazdani42/nvim-web-devicons'

    use 'vim-scripts/vim-auto-save'
    use 'vim-scripts/ReplaceWithRegister'
    use 'tommcdo/vim-exchange'
    use 'tpope/vim-repeat'
    use 'triglav/vim-visual-increment'
    use 'inside/vim-search-pulse'

    -- {{{ hop.nvim
    use {'phaazon/hop.nvim', config = function()
        vim.cmd[[nn <leader>w :HopWord<CR>]]
        vim.cmd[[nn <leader>j :HopLine<CR>]]
    end}
    -- }}}
    -- {{{ lightspeed.nvim
    use {'ggandor/lightspeed.nvim', config = function()
        require'lightspeed'.setup {
            labels = {"j", "k", "h", "d", "s", "l", "a", "e", "i",
            "w", "o", "g", "v", "n", "c", "m", "z", "."},
            jump_to_first_match = false,
            cycle_group_fwd_key = ','
        }
        vim.cmd[[nmap <leader>s <Plug>Lightspeed_S]]
    end}
    -- }}}

    -- {{{ vim-bookmarks
    use {'MattesGroeger/vim-bookmarks', config = function()
        vim.g.bookmark_no_default_key_mappings = 1

        vim.cmd[[nn <silent> <C-b>b :BookmarkToggle<CR>]]
        vim.cmd[[nn <silent> <C-b>a :BookmarkAnnotate<CR>]]
        vim.cmd[[nn <silent> <leader>cm :BookmarkShowAll<cr> :cclose<CR> :LspTrouble quickfix<cr>]]
        vim.cmd[[nn <silent> <C-b>c :BookmarkClearAll<CR>]]

        vim.cmd[[nn <silent> {m :BookmarkNext<CR>]]
        vim.cmd[[nn <silent> }m :BookmarkPrev<CR>]]
    end}
    -- }}}

    use 'junegunn/vim-peekaboo'

    -- {{{ telescope
    use 'nvim-lua/popup.nvim'
    use 'nvim-lua/plenary.nvim'
    use 'nvim-telescope/telescope.nvim'
    use 'fhill2/telescope-ultisnips.nvim'
    use 'nvim-telescope/telescope-hop.nvim'
    use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    use { 'tom-anders/telescope-vim-bookmarks.nvim', config = function()
        require 'telescopeConfig'
        vim.api.nvim_set_keymap('n', '<leader>zf', ':Telescope find_files<cr>', {silent=true})
        vim.api.nvim_set_keymap('n', '<leader>b', ':Telescope buffers<cr>', {silent=true})
        vim.api.nvim_set_keymap('n', '<leader>zM', ':Telescope marks<cr>', {silent=true})
        vim.api.nvim_set_keymap('n', '<leader>zg', ':Telescope live_grep<cr>', {silent=true})
        vim.api.nvim_set_keymap('n', '<leader>zs', ':Telescope ultisnips ultisnips<cr>', {silent=true})
        vim.api.nvim_set_keymap('n', '<leader>zh', ':Telescope oldfiles<cr>', {silent=true})
        vim.api.nvim_set_keymap('n', '<leader>zc', ':Telescope quickfix<cr>', {silent=true})
        vim.api.nvim_set_keymap('n', '<leader>zl', ':Telescope current_buffer_fuzzy_find<cr>', {silent=true})
        vim.api.nvim_set_keymap('n', '<leader>zb', ':Telescope vim_bookmarks all<CR>', {silent=true})

        vim.api.nvim_set_keymap('n', '<leader>F', ':lua gitFilesProximitySort({})<CR>', {silent=true})
        vim.api.nvim_set_keymap('n', '<leader>f', ':lua gitFilesProximitySort(dropdownTheme{previewer=false, path_display={"shorten"}})<CR>', {silent=true})
        vim.api.nvim_set_keymap('n', '<leader>zt', ':lua findTestFile()<CR>', {silent=true})

        vim.api.nvim_set_keymap('n', '<leader>gc', ':lua telescope_git_branches()<CR>', {silent=true})
    end}
    -- }}}

    -- {{{ treesitter
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate', config = function()
        require'nvim-treesitter.configs'.setup {
            ensure_installed = "maintained", 
            highlight = {
                enable = true,              
            },
            textobjects = {
                move = {
                    enable = true,
                    set_jumps = true,
                    goto_next_start = {
                        ["}f"] = "@function.outer",
                    },
                    goto_next_end = {
                        ["}F"] = "@function.outer",
                    },
                    goto_previous_start = {
                        ["{f"] = "@function.outer",
                    },
                },

                select = {
                    enable = true,

                    -- Automatically jump forward to textobj, similar to targets.vim 
                    lookahead = true,

                    keymaps = {
                        -- You can use the capture groups defined in textobjects.scm
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",

                        ["ia"] = "@parameter.inner",
                        ["aa"] = "@parameter.outer",
                    },
                },
                
            },
        }
    end} 
    use 'nvim-treesitter/playground'
    use 'nvim-treesitter/nvim-treesitter-textobjects'
    -- }}}

    --- {{{ vim-sandwich
    use { 'machakann/vim-sandwich', config = function() 
        -- See https://github.com/machakann/vim-sandwich/issues/71
        -- Normally, for something like "std::move(x)" "dsf" would result in 
        -- "std::x". With this fix, we correctly get just "x" (But only if the cursor
        -- is somewhere on "std")
        -- 
        -- TODO convert this to lua  
        -- let g:sandwich#magicchar#f#patterns = [
        --   \   {
        --   \     'header' : '\h\k*::\h\k*::\h\k*',
        --   \     'bra'    : '(',
        --   \     'ket'    : ')',
        --   \     'footer' : '',
        --   \   },
        --   \   {
        --   \     'header' : '\h\k*::\h\k*',
        --   \     'bra'    : '(',
        --   \     'ket'    : ')',
        --   \     'footer' : '',
        --   \   },
        --   \   {
        --   \     'header' : '\h\k*',
        --   \     'bra'    : '(',
        --   \     'ket'    : ')',
        --   \     'footer' : '',
        --   \   },
        --   \ ]

        -- Use vim-surround keymappings for vim-sandwich
        vim.cmd [[runtime macros/sandwich/keymap/surround.vim]]

    end}
    --- }}}

    --- {{{ barbar
    use {'romgrk/barbar.nvim', config = function() 
        vim.cmd [[ let bufferline = get(g:, 'bufferline', {}) ]]
        vim.cmd [[ let bufferline.semantic_letters = v:false ]]
        vim.cmd [[ let bufferline.animation = v:false ]]
        vim.cmd [[ let bufferline.letters = 'asdfjklghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP' ]]

        vim.cmd [[ nnoremap <silent> {b :BufferPrevious<CR> ]]
        vim.cmd [[ nnoremap <silent> }b :BufferNext<CR> ]]

        vim.cmd [[ nnoremap <silent> <leader>x :BufferClose<CR> ]]
        vim.cmd [[ nnoremap <silent> <leader>o :BufferCloseAllButCurrent<CR> ]]
        vim.cmd [[ nnoremap <silent> <leader>p :BufferPick<CR>]]
        vim.cmd [[ autocmd FileType qf set nobuflisted ]]
        vim.cmd [[ autocmd FileType fugitive set nobuflisted ]]
    end}
    --- }}}

    --- {{{ vim-grepper
    use 'mhinz/vim-grepper'
    --- }}}

    --- {{{ git
    use {'tpope/vim-fugitive', config = function() vim.cmd [[ source ~/.config/nvim/gitConfig.vim ]] end}
    use 'tommcdo/vim-fugitive-blame-ext'
    use 'codeindulgence/vim-tig'
    use {'sindrets/diffview.nvim', config = function() 
        local cb = require'diffview.config'.diffview_callback
        require'diffview'.setup {
            key_bindings = {
                disable_defaults = false,                   
                file_panel = {
                    ["j"]             = cb("select_next_entry"),
                    ["k"]             = cb("select_prev_entry"),
                    ["q"]             = ":DiffviewClose<CR>",
                }
            }
        }
        vim.cmd [[ nn <silent> <leader>gd :DiffviewOpen<CR> ]]
    end}
    use 'airblade/vim-gitgutter'
    use 'rbong/vim-flog'
    --- }}}

    -- {{{ LSP
    use {'neovim/nvim-lspconfig', config = function() require 'lspConfig' end }
    use 'nvim-lua/lsp-status.nvim'

    use {'folke/lsp-trouble.nvim', 
        requires = "kyazdani42/nvim-web-devicons",
        config = function()
            function quickfixOpen() return vim.fn.empty(vim.fn.filter(vim.fn.getwininfo(), 'v:val.quickfix')) == 0 end
            function nextInTroubleOrQuickfix()
                if quickfixOpen() then
                    vim.api.nvim_command("cnext")
                else
                    require("trouble").next({skip_groups = true, jump = true});
                end
            end
            function prevInTroubleOrQuickfix()
                if quickfixOpen() then
                    vim.api.nvim_command("cprev")
                else
                    require("trouble").previous({skip_groups = true, jump = true});
                end
            end
            vim.cmd[[nn <silent> <leader>q :LspTroubleClose<CR> :cclose<CR>]]
            vim.cmd[[nn <silent> <leader>di :LspTroubleToggle lsp_document_diagnostics<CR>]]

            vim.cmd[[nn <silent> }q :lua nextInTroubleOrQuickfix()<CR>]]
            vim.cmd[[nn <silent> {q :lua prevInTroubleOrQuickfix()<CR>]]
    end}
    use 'ray-x/lsp_signature.nvim'
    use {'hrsh7th/vim-vsnip', config = function() -- For LSP Snippets
        vim.cmd[[imap <expr> <C-j>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>']]
        vim.cmd[[smap <expr> <C-j>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>']]
    end}
    -- }}}
    
    use 'windwp/nvim-autopairs' 

    use {'hrsh7th/nvim-compe', config = function() require 'compeConfig' end}

    -- Using this in ftplugin/cpp.vim for opening floating windows for QFETCH selection
    use 'kamykn/popup-menu.nvim'

end)

vim.cmd([[autocmd BufWritePost plugins.lua source <afile> | PackerCompile]])

-- vim: foldmarker={{{,}}} foldmethod=marker
