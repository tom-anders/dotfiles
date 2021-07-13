" Additional doxygen syntax for headers, for cpp we use just treesitter
" TODO Doxygen highlighting is a bit ugly at the moment, clean that up!
" autocmd BufEnter,BufNew *.h set syntax=cpp.doxygen
autocmd BufEnter,BufNew *.h,*.hpp hi TSComment gui=NONE
autocmd BufLeave *.h,*.hpp silent! hi link TSComment Comment

" autocmd BufEnter,BufNew *.h,*.hpp set syntax=cpp.doxygen
setlocal syntax=cpp.doxygen

setlocal foldmethod=marker
setlocal foldmarker=/*,*/
setlocal foldtext=HeaderFoldText()
setlocal foldlevel=0 " Fold everything by default

function HeaderFoldText()
    let text = LicenseFoldText()
    if text == ''
        let text = DoxygenFoldText()
    endif
    return text
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

