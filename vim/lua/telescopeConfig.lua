local utils = require('telescope.utils')
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local conf = require('telescope.config').values
local make_entry = require('telescope.make_entry')

function telescopeLocationsOrQuickfix(server, command, title, params, opts)
    opts = opts or {openTelescope = true}

    params = params or vim.lsp.util.make_position_params()

    --FIXME This a workaround for initial_mode not working correctly (https://github.com/nvim-telescope/telescope.nvim/issues/750)
    opts.on_complete = { function() vim.cmd"stopinsert" end }

    getServer(server).request(command, params, function(err, _, result)
        if not result or #result == 0 then 
            print("No results!")
            return
        end

        if #result == 1 then
            vim.lsp.util.jump_to_location(result[1])
        else
            local items = vim.lsp.util.locations_to_items(result);
            vim.lsp.util.set_qflist(items);

            if opts.openTelescope then
                pickers.new(opts, {
                    prompt_title = title,
                    finder = finders.new_table {
                        results = items,
                        entry_maker = opts.entry_maker or make_entry.gen_from_quickfix(opts),
                    },
                    previewer = conf.qflist_previewer(opts),
                    sorter = conf.generic_sorter(opts),
                }):find()
            else
                vim.api.nvim_command("copen")
            end
        end
    end)
end

