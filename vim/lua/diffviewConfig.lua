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
