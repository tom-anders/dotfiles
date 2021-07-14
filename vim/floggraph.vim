nmap <buffer> q gq

" Move between refs
nmap <buffer> {r [r
nmap <buffer> }r ]r

function! GetCommitAtCurrentFlogLine()
    return flog#get_commit_at_line(line('.'))['short_commit_hash']
endfunction

function! FixupCommitViaFugitive()
    return ':Git commit --fixup=' . GetCommitAtCurrentFlogLine() . ' '
endfunction
nmap <buffer> <expr> cf FixupCommitViaFugitive()
