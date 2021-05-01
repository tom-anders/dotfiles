" Don't indent after C++ namespace start
set cino=N-s

" nnoremap <silent> gh :CocCommand clangd.switchSourceHeader<CR>

" Redefine rg to only search relevant files for c++ projects
command! -nargs=0 Rg :call fzf#vim#grep("rg -t cmake -t cpp -t qml -t qmake --column --line-number --no-heading --color=always --smart-case -- ".shellescape(<q-args>), 1, fzf#vim#with_preview(), <bang>0)<CR>

set textwidth=120
set colorcolumn=+1

" Highlighting {{{
function! s:highlightColor(key, color, ...)
    let gui = get(a:, 1, '') == '' ? '' : ' gui='.get(a:, 1, '')
    exe 'highlight '.a:key.' guifg='.a:color.gui
endfunction

call s:highlightColor('ClangdTemplateParameter', g:terminal_color_3, 'bold,italic')
call s:highlightColor('ClangdClass', g:terminal_color_3, 'bold')
call s:highlightColor('ClangdNamespace', g:terminal_color_8)

call s:highlightColor('ClangdFunction', g:terminal_color_15, 'italic')

call s:highlightColor('ClangdParameter', g:terminal_color_14)
call s:highlightColor('TSParameter', g:terminal_color_14)

call s:highlightColor('ClangdField', g:terminal_color_4)
call s:highlightColor('TSField', g:terminal_color_4)
call s:highlightColor('TSProperty', g:terminal_color_4)

call s:highlightColor('ClangdLocalVariable', g:terminal_color_15, 'italic')

call s:highlightColor('ClangdMemberFunction', g:terminal_color_12)
call s:highlightColor('TSMethod', g:terminal_color_12)
call s:highlightColor('TSFunction', g:terminal_color_12)

" Static -> orange
call s:highlightColor('ClangdStaticMemberFunction', '#fe8019', 'bold') 
call s:highlightColor('ClangdStaticField', '#fe8019')

call s:highlightColor('ClangdPreprocessor', g:terminal_color_5, 'bold')

call s:highlightColor('cStorageClass', g:terminal_color_9, 'italic')
call s:highlightColor('cppStorageClass', g:terminal_color_9, 'italic')
call s:highlightColor('cppModifier', g:terminal_color_9, 'bold')

call s:highlightColor('cString', g:terminal_color_2)

call s:highlightColor('cFloat', g:terminal_color_13, 'italic')

call s:highlightColor('cppStatement', g:terminal_color_1, 'italic')

let g:lsp_cxx_hl_use_text_props=1

map <leader>hi :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" }}}

let g:doxygen_javadoc_autobrief=0
let g:load_doxygen_syntax=1
set syntax=cpp.doxygen

set foldmethod=marker
set foldmarker=/*,*/
set foldtext=HeaderFoldText()
set foldlevel=0 " Fold everything by default

function CppFunctionFoldText()
    if getline(v:foldstart) == '{'
        return '{...}'
    endif
    return ''
endfunction

function HeaderFoldText()
    let text = LicenseFoldText()
    if text == ''
        let text = IncludeFoldText()
    endif
    if text == ''
        let text = DoxygenFoldText()
    endif
    return text
endfunction

function IncludeFoldText()
    if getline(v:foldstart) =~ "#include"
        return len(getline(v:foldstart, v:foldend)) . ' includes'
    endif
    return ''
endfunction

function LicenseFoldText()
    if v:foldstart == 1 && getline(v:foldstart) =~ '\v^/\*.*$'
        return '/********* (License) *********/'
    endif
    return ''
endfunction

" adapted from https://github.com/brobeson/Tools/blob/master/vim/vim/ftplugin/cpp_doxygen.vim
function DoxygenFoldText()
    " assume this isn't a Doxygen comment
    let fold_text = ''

    " get the first line. we need it to determine what type of fold text
    " to create.
    let first_line = getline(v:foldstart)

    let isCStyle = match(first_line, '^\s*\/\*[!\*]') == 0
    let isCppStyle = match(first_line, '\v\s*///') == 0

    " Doxygen comment blocks
    if isCStyle || isCppStyle
        if isCStyle
            " put a space between /** and the brief text. also, remove any
            " text after the /**.
            let fold_text = substitute(first_line, '\(\/\*[!\*]\).*', '\1 ', '')
        else
            " let fold_text = substitute(first_line, '\v///.*', '/// \1 ', '')
            let fold_text = first_line
        endif

        let comments = getline(v:foldstart, v:foldend)

        " remove leading *s and white space from subsequent lines in
        " the comments. note that we can't use
        " 'for comment in comments' here; the assignment in the loop
        " would assign to a copy, not the actual list item.
        let startRegex = isCStyle ? '^\s*\*\?\s*' : '\v^\s*///\s*'
        for i in range(1, len(comments) - 1)
            let comments[i] = substitute(comments[i], startRegex, '', '')
        endfor

        " locate the brief text in the comment. the brief text goes from
        " '@brief' (or '\brief') until the next '@' (or '\').  get all
        " the lines in the block comment, then find the line which
        " contains the 'brief' tag.
        let brief_start = match(comments, '[@|\\]\(\(copy\)\?brief\|copydoc\)')

        " if the brief tag was found...
        if 0 <= brief_start
            " find the end of the brief description. this occurs when:
            " 1 - the next Doxygen command is found,
            " 2 - a blank line occurs after the brief text
            " then crop the comments array, so we only have the brief text
            let comments = comments[brief_start : match(comments, '\([@|\\]\|^\s*$\)', brief_start + 1) - 1]

            if isCppStyle
                let fold_text = substitute(comments[0], '[@\\]brief\s*', '', '')
            else
                " from the first brief line, remove everything except the
                " actual text: ' * @brief blah' becomes 'blah'
                let comments[0] = substitute(comments[0], '^.*[@\\]brief\s*', '', '')

                let fold_text .= join(comments) . ' */'
            endif

            " if a brief command wasn't found, it's possible for a Javadoc
            " style comment to use the first sentence as the brief comment.
        else
            let brief_start = match(comments, '\w.*')
            if isCStyle
                if 0 <= brief_start
                    " this match is a bit tricky. the Javadoc auto brief ends
                    " with the first period. then, in case there are two
                    " periods on the end line, remove the extra words.
                    let comments = comments[brief_start : match(comments, '.', brief_start)]
                    let fold_text .= substitute(join(comments), '\..*$', '\. \*\/', '')
                else
                    let fold_text .= 'no brief description */'
                endif
            elseif isCppStyle
                " Don't really care here, just use the first line and be done
                " with it
                let comments = comments[brief_start : match(comments, '.', brief_start)]
                let fold_text = comments[0]

            " if no brief text was found, set the fold text to that fact
            else
                let fold_text .= 'no brief description */'
            endif
    endif

    return fold_text
endfunction

function! FoldLicense(lnum)
    let line = getline(a:lnum)
    if a:lnum == 1 && line =~ '\v^/\*.*$' 
        return '>2'
    endif
    return ''
endfunction

function! FoldCStyleComment(line)
    " start of c-style
    if a:line =~ '\v^\s*/\*[\*!].*$'
        return '>1'
    endif
    " middle of c-style
    if a:line =~ '\v^\s*\*.*$'
        return '='
    endif
    " end of c-style
    if a:line =~ '\v^\s*\*/.*$'
        return '<1'
    endif
    return ''
endfunction

function! FoldCppFunction(line)
    if a:line == '{'
        return '>1'
    endif

    if a:line == '}'
        return '<1'
    endif
    return ''
endfunction

function! FoldCppHeader(lnum)
    let line = getline(a:lnum)

    let foldlevel = FoldLicense(a:lnum)
    if foldlevel != ''
        return foldlevel
    endif

    let foldlevel = FoldCStyleComment(line)
    if foldlevel != ''
        return foldlevel
    endif

    " cpp-style
    if line =~ '\v^\s*//[!/].*$'
        return '1'
    endif
endfunction
" }}}

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

" coc-nvim config {{{
" Explicitly call ccls here (instead of just coc-definition),
" because otherwise we'd also get duplicate results from clangd
" nmap <silent> gd :call CocLocations('ccls','textDocument/definition')<cr>
" " And same for find references
" nmap <silent> gu :call CocLocations('ccls','textDocument/references')<cr>

" " Mnemonic: x -> "cross reference"
" " bases
" nn <silent> xb :call CocLocations('ccls','$ccls/inheritance')<cr>
" " bases of up to 5 levels
" nn <silent> xB :call CocLocations('ccls','$ccls/inheritance',{'levels':5})<cr>
" " derived (mnemonic: i -> "implementation")
" nn <silent> xi :call CocLocations('ccls','$ccls/inheritance',{'derived':v:true})<cr>
" " derived of up to 3 levels
" nn <silent> xI :call CocLocations('ccls','$ccls/inheritance',{'derived':v:true,'levels':3})<cr>

" " caller
" nn <silent> xc :call CocLocations('ccls','$ccls/call')<cr>
" " callee
" nn <silent> xC :call CocLocations('ccls','$ccls/call',{'callee':v:true})<cr>

" " member variables / variables in a namespace
" nn <silent> xm :call CocLocations('ccls','$ccls/member')<cr>
" " member functions / functions in a namespace
" nn <silent> xf :call CocLocations('ccls','$ccls/member',{'kind':3})<cr>
" " nested classes / types in a namespace
" nn <silent> xs :call CocLocations('ccls','$ccls/member',{'kind':2})<cr>

" nmap <silent> xt <Plug>(coc-type-definition)<cr>
" nn <silent> xv :call CocLocations('ccls','$ccls/vars')<cr>
" nn <silent> xV :call CocLocations('ccls','$ccls/vars',{'kind':1})<cr>

" nn xx x

" " Show signature help when entering insert mode, very useful when editing parameters
" autocmd InsertEnter * silent! call CocActionAsync('showSignatureHelp')

" nn <silent><buffer> <C-M-l> :call CocLocations('ccls','$ccls/navigate',{'direction':'D'})<cr>
" nn <silent><buffer> <C-M-k> :call CocLocations('ccls','$ccls/navigate',{'direction':'L'})<cr>zz
" nn <silent><buffer> <C-M-j> :call CocLocations('ccls','$ccls/navigate',{'direction':'R'})<cr>zz
" nn <silent><buffer> <C-M-h> :call CocLocations('ccls','$ccls/navigate',{'direction':'U'})<cr>

" }}}
