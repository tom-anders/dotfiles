local lsp_status = require('lsp-status')
lsp_status.config {
    current_function = false
}
lsp_status.register_progress()

local lspconfig = require('lspconfig')

require'lsp_signature'.on_attach()

function getServer(name)
    local clients = vim.lsp.get_active_clients()
    for _, c in pairs(clients) do
        if c.name == name then
            return c
        end
    end
end

--- {{{ mappings
function attachCommon(client, bufnr)
    lsp_status.on_attach(client, bufnr)

    -- require'completion'.on_attach(client)
    setupLspMappings(client, bufnr)

    -- Set autocommands conditional on server_capabilities
    if client.resolved_capabilities.document_highlight then
        vim.api.nvim_exec([[
        hi LspReferenceRead cterm=bold guibg=#3c3836
        hi LspReferenceText cterm=bold guibg=#3c3836
        hi LspReferenceWrite cterm=bold guibg=#3c3836
        augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
        ]], false)
    end
end

function goToDefinition(split)
    if split then
        vim.api.nvim_command("vsplit")
        vim.api.nvim_command("wincmd l")
    else
        -- Set mark to add this to the jump list even if we didn't switch buffers
        vim.api.nvim_command("normal m\'") --TODO this actually a bug in nvim, see https://github.com/neovim/neovim/commit/993ca90c9b53033216d4973e2f995b995ed5740e
    end
    vim.lsp.buf.definition()
end

function peekDefinition()
    local params = vim.lsp.util.make_position_params()
    vim.lsp.buf_request(0, 'textDocument/definition', params, function(_, _, result)
        if not result or not result[1] then
            print("No result for textDocument/definition")
            return
        end

        -- Give some context
        result[1].range["start"].line = math.max(0, result[1].range["start"].line - 4)
        result[1].range["end"].line = result[1].range["end"].line + 20

        vim.lsp.util.preview_location(result[1])
    end)
end

function setupLspMappings(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    local opts = { noremap=true, silent=true }

    buf_set_keymap('n', '<leader>ca', '<cmd>Telescope lsp_code_actions<CR>', opts)
    buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)

    buf_set_keymap('n', 'xi','<cmd>LspTrouble lsp_implementations<CR>', opts)
    buf_set_keymap('n', 'xI','<cmd>lua telescopeLocationsOrQuickfix("textDocument/implementation", "LSP implementations", {})<CR>', opts)
    -- For clangd, textDocument/definition when the cursor is placed over the override keyword goes to the base class definition 
    buf_set_keymap('n', 'xb','<cmd>call search("override", "", line(".")) | lua vim.lsp.buf.definition() <CR>', opts)

    buf_set_keymap('n', 'gd', '<cmd>lua goToDefinition(false)<CR>', opts)
    buf_set_keymap('n', 'gD', '<cmd>lua goToDefinition(true)<CR>', opts)

    buf_set_keymap('n', 'gp', '<cmd>lua peekDefinition()<CR>', opts)

    buf_set_keymap('n', 'gu','<cmd>LspTrouble lsp_references<CR>', opts)
    buf_set_keymap('n', 'gU','<cmd>lua telescopeLocationsOrQuickfix("textDocument/references", "LSP References", {})<CR>', opts)

    buf_set_keymap('n', '<leader>.', string.format('<cmd>call luaeval("telescopeDocumentSymbols(_A)", "%s")<CR>', client.name), opts)
    buf_set_keymap('n', '<C-k>', string.format('<cmd>call luaeval("telescopeWorkspaceSymbols(_A)", "%s")<CR>', client.name), opts)

    buf_set_keymap('n', '<leader>.', '<cmd>lua require"telescope.builtin".lsp_document_symbols{symbol_width=40}<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua require"telescope.builtin".lsp_dynamic_workspace_symbols{symbol_width=40}<CR>', opts)

    buf_set_keymap('n', '{d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', '}d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
end
-- }}}

-- {{{ clangd setup
function attachClangd(client, bufnr)
    attachCommon(client, bufnr)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gh', ':ClangdSwitchSourceHeader<CR>', { noremap=true, silent=true })
end

lspconfig.clangd.setup{
    on_attach=attachClangd,
    handlers = lsp_status.extensions.clangd.setup(),
    init_options = {
        clangdFileStatus = true
    },
    cmd = {                 
        "clangd-12", "--clang-tidy", 
        "--background-index", "-j=8", "--all-scopes-completion",                 
        "--completion-style=detailed", "--cross-file-rename",
        "--header-insertion=never",
    },
    capabilities = {
        textDocument = {
            completion = {
                completionItem = {
                    snippetSupport = true,
                }
            },
        },
        window = {
            workDoneProgress = true
        }
    }
}
-- }}}

-- rust_analyzer {{{
lspconfig.rust_analyzer.setup{
    on_attach=attachCommon,
    capabilities = {
        textDocument = {
            completion = {
                completionItem = {
                    snippetSupport = true,
                }
            },
            semanticHighlightingCapabilities = {
                semanticHighlighting = true
            }
        },
        window = {
            workDoneProgress = true
        }
    }
}
-- }}}

lspconfig.pylsp.setup{
    capabilities = {
        textDocument = {
            completion = {
                completionItem = {
                    snippetSupport = true,
                }
            },
        },
        window = {
            workDoneProgress = true
        }
    }
}

-- vim: foldmarker={{{,}}} foldmethod=marker
