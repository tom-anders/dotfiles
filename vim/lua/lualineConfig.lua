function LspStatus() 
    if #vim.lsp.buf_get_clients() > 0 then
        return require('lsp-status').status()
    end

    return ''
end

require('lualine').setup{
    options = {
        theme = 'gruvbox',
    },
    sections = {lualine_c = {'filename', LspStatus}}
}
