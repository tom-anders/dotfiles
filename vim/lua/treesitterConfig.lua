require'nvim-treesitter.configs'.setup {
    ensure_installed = "maintained", 
    highlight = {
        enable = true,              
        -- disable = { "c", "cpp" }, -- Using clangd semantic highlighting for those
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
