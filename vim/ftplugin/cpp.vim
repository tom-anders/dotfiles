" Don't indent after C++ namespace start
set cino=N-s

nnoremap gh :CocCommand clangd.switchSourceHeader<CR>

" Redefine rg to only search relevant files for c++ projects
command! -nargs=0 Rg :call fzf#vim#grep("rg -t cmake -t cpp -t qml -t qmake --column --line-number --no-heading --color=always --smart-case -- ".shellescape(<q-args>), 1, fzf#vim#with_preview(), <bang>0)<CR>

set textwidth=120
set colorcolumn=+1

" Highlighting {{{
highlight LspCxxHlSymParameter ctermfg=6 cterm=italic

highlight LspCxxHlSymField ctermfg=4

highlight LspCxxHlSymMethod ctermfg=7
highlight LspCxxHlSymFunction ctermfg=7 cterm=italic

highlight LspCxxHlSymNamespace ctermfg=136 
highlight LspCxxHlSymClass ctermfg=136 cterm=bold
highlight LspCxxHlSymEnum ctermfg=136 cterm=bold,italic

highlight cConditional ctermfg=64 cterm=bold
highlight cRepeat ctermfg=64 cterm=bold
highlight cStorageClass ctermfg=64 cterm=bold,italic
highlight cppConstant ctermfg=64 cterm=bold,italic
highlight cppStatement ctermfg=64 cterm=bold,italic
highlight cppBoolean ctermfg=64 cterm=bold,italic
highlight type ctermfg=64 cterm=bold

highlight cString ctermfg=9
highlight cppNumber ctermfg=9

highlight LspCxxHlSymVariable ctermfg=9
highlight LspCxxHlSymUnknownStaticField ctermfg=9
highlight LspCxxHlSymStaticMethod ctermfg=9 cterm=italic

let g:lsp_cxx_hl_use_text_props=1

map <leader>hi :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" }}}

let g:load_doxygen_syntax=1

set comments^=:///

" Folding stuff {{{
au BufEnter,BufNew *.cpp set foldmethod=expr
au BufEnter,BufNew *.cpp set foldexpr=FoldCppSource(v:lnum)
au BufEnter,BufNew *.cpp set foldtext=SourceFoldText()

au BufEnter,BufNew *.hpp,*.h set foldmethod=expr
au BufEnter,BufNew *.hpp,*.h set foldexpr=FoldCppHeader(v:lnum)
au BufEnter,BufNew *.hpp,*.h set foldtext=HeaderFoldText()

function CppFunctionFoldText()
    if getline(v:foldstart) == '{'
        return '{...}'
    endif
    return ''
endfunction

function SourceFoldText()
    let text = LicenseFoldText()
    if text == ''
        let text = IncludeFoldText()
    endif
    if text == ''
        let text = CppFunctionFoldText()
    endif
    
    return text
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

function! FoldInclude(line)
    if a:line =~ '#include'
        return '2'
    endif
endfunction

function! FoldCStyleComment(line)
    " start of c-style
    if a:line =~ '\v^\s*/\*[\*!].*$'
        return 'a1'
    endif
    " middle of c-style
    if a:line =~ '\v^\s*\*.*$'
        return '='
    endif
    " end of c-style
    if a:line =~ '\v^\s*\*/.*$'
        return 's1'
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

function! FoldCppSource(lnum)
    let line = getline(a:lnum)
    
    let level = FoldInclude(line)
    if level != ''
        return level
    endif
    " This line is not a include but the previous one was -> reset fold level
    if FoldInclude(getline(a:lnum -1)) != ''
        return '0'
    endif

    let level = FoldCppFunction(line)
    if level != ''
        return level
    endif

    let level = FoldLicense(a:lnum)
    if level != ''
        return level
    endif
    if line =~ '\v^\s*\*.*$'
        return '='
    endif
    if line =~ '\v^\s*\*/\s*$'
        return '<2'
    endif
    if getline(a:lnum-1) =~ '\v^\s*\*/\s*$'
        return '0'
    endif

    return '-1'
endfunction

function! FoldCppHeader(lnum)
    let line = getline(a:lnum)

    let foldlevel = FoldLicense(a:lnum)
    if foldlevel != ''
        return foldlevel
    endif

    let foldlevel = FoldInclude(line)
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
