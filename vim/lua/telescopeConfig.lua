local utils = require('telescope.utils')
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local conf = require('telescope.config').values
local make_entry = require('telescope.make_entry')
local async_lib = require('plenary.async_lib')
local async, await = async_lib.async, async_lib.await
local channel = async_lib.util.channel

-- {{{ lsp locations
-- If there's only one result, directly jump to it. Otherwise open in telescope and set quickfix list
function telescopeLocationsOrQuickfix(command, title, opts)
    opts = opts or {openTelescope = true}

    params = vim.lsp.util.make_position_params()
    params.context = { includeDeclaration = false }

    --FIXME This a workaround for initial_mode not working correctly (https://github.com/nvim-telescope/telescope.nvim/issues/750)
    opts.on_complete = { function() vim.cmd"stopinsert" end }

    local results_lsp = vim.lsp.buf_request_sync(0, command, params, opts.timeout or 1000)
    local locations = {}
    for _, server_results in pairs(results_lsp) do
        if server_results.result then
            vim.list_extend(locations, server_results.result or {})
        end
    end

    if #locations == 0 then
        print("No results for", command)
        return
    elseif #locations == 1 then
        vim.lsp.util.jump_to_location(locations[1])
    else
        local items = vim.lsp.util.locations_to_items(locations)
        vim.lsp.util.set_qflist(items);

        pickers.new(opts, {
            prompt_title = title,
            finder = finders.new_table {
                results = items,
                entry_maker = opts.entry_maker or make_entry.gen_from_quickfix(opts),
            },
            previewer = conf.qflist_previewer(opts),
            sorter = conf.generic_sorter(opts),
        }):find()
    end
end
--- }}}

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

-- {{{ Document symbols
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
-- }}}

-- {{{ Custom dropdown theme
function dropdownTheme(opts)
  opts = opts or {}

  local theme_opts = {
    theme = "dropdown",

    sorting_strategy = "ascending",
    layout_strategy = "center",
    results_title = false,
    preview_title = "Preview",
    layout_config = {
        width = 180,
        height = 30,
        preview_cutoff = 1, -- Preview should always show (unless previewer = false)
    },
  }

  return vim.tbl_deep_extend("force", theme_opts, opts)
end
-- }}}

-- {{{ git files
-- Adapted from builtin.git_files
function gitFilesProximitySort(opts)
  local show_untracked = utils.get_default(opts.show_untracked, true)
  local recurse_submodules = utils.get_default(opts.recurse_submodules, false)
  if show_untracked and recurse_submodules then
    error("Git does not support both --others and --recurse-submodules")
  end

  -- By creating the entry maker after the cwd options,
  -- we ensure the maker uses the cwd options when being created.
  opts.entry_maker = opts.entry_maker or make_entry.gen_from_file(opts)

  local home = vim.api.nvim_eval("expand('$HOME')")
  local base = vim.api.nvim_eval("fnamemodify(expand('%'), ':h:.:S')")

  pickers.new(opts, {
    prompt_title = 'Git Files',
    finder = finders.new_oneshot_job(
      vim.tbl_flatten( {
        home .. "/.dotfiles/scripts/gitLsProximitySort.sh", base
      } ),
      opts
    ),
    previewer = conf.file_previewer(opts),
    sorter = conf.file_sorter(opts),
  }):find()
end
-- }}}

-- {{{ git branches
function telescope_git_branches()
    require('telescope.builtin').git_branches {
        attach_mappings = function(_, map)
            map('i', '<CR>', require('telescope.actions').git_switch_branch)
            map('n', '<CR>', require('telescope.actions').git_switch_branch)

            return true
        end,
        previewer = false,
    }
end
-- }}}

function findTestFile()
    local file = vim.api.nvim_eval("expand('%:t')")
    require('telescope.builtin').find_files({default_text = 'Test' .. file})
end

if pcall(require, "plenary") then
    R = function(name)
        require("plenary.reload").reload_module(name)
        return require(name)
    end
end

local actions = require('telescope.actions')
require('telescope').setup {
    defaults = {
        mappings = {
            i = {
                ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                ['<Esc>'] = function(prompt_bufnr)
                    require'telescope'.extensions.hop._hop(prompt_bufnr, {callback = actions.select_default})
                end
            },
            n = {
                ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
            }
        }
    },
    extensions = {
        fzf = {
            override_generic_sorter = false, 
            override_file_sorter = true,    
            case_mode = "smart_case",      
        },
        hop = {
            keys = {"h", "j", "k", "l", "b", "u", "f", "H", "J", "K", "L"}
        }
    }
}
require('telescope').load_extension('fzf')
require('telescope').load_extension('ultisnips')

require('telescope').load_extension('vim_bookmarks')

require('telescope').load_extension('hop')

-- vim: foldmarker={{{,}}} foldmethod=marker
