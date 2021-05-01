require'nvim-treesitter.configs'.setup {
    ensure_installed = "maintained", 
}

require'nvim-treesitter.configs'.setup {
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
      },
    },
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
