local lspconfig = require('lspconfig')

require'lsp_signature'.on_attach()

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'always';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 60;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
  };
}

function getServer(name)
    local clients = vim.lsp.get_active_clients()
    for _, c in pairs(clients) do
        if c.name == name then
            return c
        end
    end
end

function getClangd()
    getServer('clangd')
end

function clangdRequest(req)
    getClangd().request(req, vim.lsp.util.make_position_params())
end

function attachClangd(client, bufnr)
    attachCommon(client, bufnr)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gh', ':ClangdSwitchSourceHeader<CR>', { noremap=true, silent=true })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', ':ClangdHover<CR>', { noremap=true, silent=true })
end

function attachCommon(client, bufnr)
    -- require'completion'.on_attach(client)
    setupLspMappings(bufnr)

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

function setupLspMappings(bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    local opts = { noremap=true, silent=true }

    buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)

    buf_set_keymap('n', 'gu', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)

    buf_set_keymap('n', '{d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', '}d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>di', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
end

lspconfig.clangd.setup{
    on_attach=attachClangd,
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
                    snippetSupport = true,
                }
            }
        }
    }
}

function test()
for k, v in pairs() do
    print("k", k, "v", v)
end
end

-- -- Disable functionality that is already handled by clangd
local cclsCapabilities = vim.lsp.protocol.make_client_capabilities()
-- cclsCapabilities.textDocument.completion = nil

function cclsInheritance(derived, levels)
    local params = vim.lsp.util.make_position_params()
    params.derived = derived;
    params.levels = levels;
    getServer('ccls').request('$ccls/inheritance', params, function(err, _, result)
        if not result or #result == 0 then return end
        vim.lsp.util.set_qflist(vim.lsp.util.locations_to_items(result))
        vim.api.nvim_command("copen")
    end)
end

function attachCcls(client, bufnr)
    attachCommon(client, bufnr)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'xi', ":lua cclsInheritance(true, 1)<CR>", { noremap=true, silent=true })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'xI', ":lua cclsInheritance(true, 5)<CR>", { noremap=true, silent=true })

    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'xb', ":lua cclsInheritance(false, 1)<CR>", { noremap=true, silent=true })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'xB', ":lua cclsInheritance(false, 5)<CR>", { noremap=true, silent=true })

end

lspconfig.ccls.setup {
    on_attach=attachCcls,
    capabilities = cclsCapabilities,
    init_options = {
        highlight = {
            lsRanges = true
        }
    },
    -- No need for diagnostics, will be provided by clangd
    handlers = {["completionItem/resolve"] = function(...) return nil end}
}

