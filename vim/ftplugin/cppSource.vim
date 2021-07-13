" Use Treesitter Syntax Highlighting
setlocal syntax=off

" hi link TSComment Comment

setlocal foldmethod=indent
setlocal foldnestmax=1
setlocal foldtext=

" Shortcut for QFETCH from the QTest framework {{{

function! s:getNameOfCurrentTest()
    for lnum in range(getpos('.')[1], 1, -1)
        let line = getline(lnum)
        if line =~ '\v^void [A-Za-z]+::[A-Za-z_]+()'
            return matchstr(line, '\v(::)@<=[A-Za-z_]+')
        endif
    endfor
    return ''
endfunction

function! s:findTestDataLnum(testName)
    for lnum in range(1, line('$'))
        let line = getline(lnum)
        if line =~ (a:testName . '_data()')
            return lnum
        endif
    endfor
    return -1
endfunction

function! s:parseColumns(dataLnum)
    let list = []
    let lnum = a:dataLnum + 1
    while getline(lnum) !~ '\v^}\s*$' && lnum != line('$') + 1
        let line = getline(lnum)
        if line =~ 'QTest::addColumn'
            let type = matchstr(line, '\v(addColumn\<)@<=.*(\>\()@=')
            let name = matchstr(line, '\v(")@<=.*(")@=')
            call add(list, [type, name])
        endif
        let lnum = lnum + 1
    endwhile

    return list
endfunction

function! s:makeTestDataPopup()
    let name = s:getNameOfCurrentTest()
    let dataLnum = s:findTestDataLnum(name)
    if dataLnum == -1
        echo "Did not find corresponding _data()"
    endif
    let popupTexts = []
    let columns = s:parseColumns(dataLnum)
    for pair in columns
        call add(popupTexts, 'QFETCH(' . pair[0] . ', ' . pair[1] . ');')
    endfor

    call popup_menu#open(popupTexts, {selected -> s:qfetchCallback(selected)})
endfunction

function! s:qfetchCallback(selected) abort
    execute "normal! i" . a:selected
    execute "normal! =="
    execute "normal! A"
endfunction

nnoremap <C-f> :call <SID>makeTestDataPopup()<cr>
inoremap <C-f> <esc>:call <SID>makeTestDataPopup()<cr>
"}}}
