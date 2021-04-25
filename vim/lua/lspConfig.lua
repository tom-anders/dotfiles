local lspconfig = require('lspconfig')

function getClangd()
    local clients = vim.lsp.get_active_clients()
    for _, c in pairs(clients) do
        if c.name == 'clangd' then
            return c
        end
    end
end

function clangdRequest(req)
    getClangd().request(req, vim.lsp.util.make_position_params())
end

function attachCommon(client, bufnr)
    require'completion'.on_attach(client)
    setupLspMappings()
end

function setupLspMappings()
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    buf_set_keymap('n', 'gh', ':ClangdSwitchSourceHeader<CR>', { noremap = true, silent = true })
    buf_set_keymap('n', 'K', ':ClangdHover<CR>', { noremap = true, silent = true })

    buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', {noremap = true, silent = true})
    buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', {noremap = true, silent = true})

    buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', {noremap = true, silent = true})
    buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', {noremap = true, silent = true})
end


lspconfig.pyls.setup{
    on_attach=require'completion'.on_attach,
}

lspconfig.clangd.setup{
    on_attach=attachCommon,
    commands = {
        ClangdHover = { function() clangdRequest('textDocument/hover') end },
    },
    cmd = {                 
        "clangd", "--clang-tidy", 
        "--background-index", "-j=4", "--all-scopes-completion",                 
        "--completion-style=detailed", "--cross-file-rename",
        "--header-insertion=never",
    },
    capabilities = {
        textDocument = {
            completion = {
                completionItem = {
                    snippetSupport = false
                }
            }
        }
    }
}

-- lspconfig.ccls.setup {
--     init_options = {
--         highlight = {
--             lsRanges = true
--         }
--     },
--     -- Disable functionality that is already handled by clangd
--     on_init = function(client) 
--         local rc = client.resolved_capabilities         
--         rc.document_formatting = false         
--         rc.document_highlight = false         
--         rc.rename = false         
--         rc.hover = false         
--         rc.signature_help = false         
--         rc.completion = false
--     end,
--     -- No need for diagnostics, will be provided by clangd
--     handlers = {["textDocument/publishDiagnostics"] = function(...) return nil end}
-- }

