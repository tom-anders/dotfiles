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

function telescopeWorkspaceSymbols(server, opts)
  opts = opts or {}
  local params = {query = opts.query or ''}

  getServer(server).request("workspace/symbol", params, function(err, _, result)
      if not result or #result == 0 then
          print("No results from textDocument/workspaceSymbol")
      end

      local items = vim.lsp.util.symbols_to_items(result, 0)

      opts = opts or {}
      opts.ignore_filename = opts.ignore_filename or true
      pickers.new(opts, {
          prompt_title = 'LSP Workspace Symbols',
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

  end)
end

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

  end)
end
