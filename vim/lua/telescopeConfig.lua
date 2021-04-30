local utils = require('telescope.utils')
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local conf = require('telescope.config').values
local make_entry = require('telescope.make_entry')
local async_lib = require('plenary.async_lib')
local async, await = async_lib.async, async_lib.await
local channel = async_lib.util.channel

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
    end, 0)
end

-- {{{ Dynamic workspace symbols, adapted from telescope code to only use a single server
local function get_workspace_symbols_requester(serverName)
    local id = nil

    local server = getServer(serverName)

    return async(function(prompt)
        local tx, rx = channel.oneshot()
        if id then
            server.cancel_request(id)
        end

        -- If there's more than one word, the first one is assumend to be the filter for symbol_type
        words = {}
        for word in prompt:gmatch("%w+") do table.insert(words, word) end

        _, id = server.request("workspace/symbol", {query = words[2] or words[1]}, tx, 0)

        local err, _, results_lsp = await(rx())
        assert(not err, err)

        local locations = vim.lsp.util.symbols_to_items(results_lsp or {}, 0) or {}
        return locations
    end)
end

function telescopeWorkspaceSymbols(server, opts)
    local curr_bufnr = vim.api.nvim_get_current_buf()
    opts = opts or {}

    pickers.new(opts, {
        prompt_title = 'LSP Dynamic Workspace Symbols',
        finder    = finders.new_dynamic {
            entry_maker = opts.entry_maker or make_entry.gen_from_lsp_symbols(opts),
            fn = get_workspace_symbols_requester(server),
        },
        previewer = conf.qflist_previewer(opts),
        sorter = conf.prefilter_sorter{
            tag = "symbol_type",
            sorter = conf.generic_sorter(opts)
        }
    }):find()
end
-- }}}

function telescopeDocumentSymbols(server, opts)
  local params = vim.lsp.util.make_position_params()

  getServer(server).request("textDocument/documentSymbol", params, function(err, _, result)
      if not result or #result == 0 then
          print("No results from textDocument/documentSymbol!")
      end

      local items = vim.lsp.util.symbols_to_items(result, 0)

      opts = opts or {}
      opts.ignore_filename = opts.ignore_filename or true
      pickers.new(opts, {
          prompt_title = 'LSP Document Symbols',
          finder    = finders.new_table {
              results = items,
              -- TODO modified gen_from_lsp_symbols() to make width customizable
              entry_maker = opts.entry_maker or make_entry.gen_from_lsp_symbols(opts)
          },
          previewer = conf.qflist_previewer(opts),
          sorter = conf.prefilter_sorter{
              tag = "symbol_type",
              sorter = conf.generic_sorter(opts)
          }
      }):find()

  end, 0)
end
