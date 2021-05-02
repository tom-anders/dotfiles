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
        vim.api.nvim_command("normal m\'") 
    end
    --TODO go back when definition not found? Can we detect this somehow?
    vim.lsp.buf.definition() 
end

function setupLspMappings(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    local opts = { noremap=true, silent=true }

    buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)

    buf_set_keymap('n', 'xi','<cmd>lua telescopeLocationsOrQuickfix("textDocument/implementation", {openTelescope = true})<CR>', opts)
    buf_set_keymap('n', 'xI','<cmd>lua telescopeLocationsOrQuickfix("textDocument/implementation", {openTelescope = false})<CR>', opts)
    -- For clangd, textDocument/definition when the cursor is placed over the override keyword goes to the base class definition 
    buf_set_keymap('n', 'xb','<cmd>call search("override", "", line(".")) | lua vim.lsp.buf.definition() <CR>', opts)

    buf_set_keymap('n', 'gd', '<cmd>lua goToDefinition(false)<CR>', opts)
    buf_set_keymap('n', 'gD', '<cmd>lua goToDefinition(true)<CR>', opts)

    buf_set_keymap('n', 'gu','<cmd>lua telescopeLocationsOrQuickfix("textDocument/references", {openTelescope = true})<CR>', opts)
    buf_set_keymap('n', 'gU','<cmd>lua telescopeLocationsOrQuickfix("textDocument/references", {openTelescope = false})<CR>', opts)

    buf_set_keymap('n', 'K', string.format('<cmd>call luaeval("getServer(_A[1]).request(_A[2], vim.lsp.util.make_position_params())", ["%s", "%s"])<CR>', client.name, "textDocument/hover"), opts)
    buf_set_keymap('n', '<leader>.', string.format('<cmd>call luaeval("telescopeDocumentSymbols(_A)", "%s")<CR>', client.name), opts)
    buf_set_keymap('n', '<C-k>', string.format('<cmd>call luaeval("telescopeWorkspaceSymbols(_A)", "%s")<CR>', client.name), opts)

    buf_set_keymap('n', '{d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', '}d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>di', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
end
-- }}}

-- {{{ clangd setup
function attachClangd(client, bufnr)
    attachCommon(client, bufnr)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gh', ':ClangdSwitchSourceHeader<CR>', { noremap=true, silent=true })
end

lspconfig.clangd.setup{
    on_attach=attachClangd,
    on_init = require'clangd_nvim'.on_init, -- Sets up semantic highlighting
    handlers = lsp_status.extensions.clangd.setup(),
    init_options = {
        clangdFileStatus = true
    },
    cmd = {                 
        "clangd", "--clang-tidy", 
        "--background-index", "-j=6", "--all-scopes-completion",                 
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

-- vim: foldmarker={{{,}}} foldmethod=marker
