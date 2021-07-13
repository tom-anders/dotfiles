require'nvim-treesitter.configs'.setup {
    ensure_installed = "maintained", 
    highlight = {
        enable = true,              
        -- disable = { "c", "cpp" }, -- Using clangd semantic highlighting for those

        -- For doxygen highlighting (Set syntax cpp.doxygen. Only enabled in headers (see cpp.vim) for performance reasons)
        additional_vim_regex_highlighting = { "cpp" }
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
        goto_previous_end = {
            ["{F"] = "@function.outer",
        },
    }
  },
}
