nmap <buffer> SS :Git submodule update<CR>

nmap <buffer> cc :tab Git commit<CR>
nmap <buffer> ca :tab Git commit --amend<CR>
nmap <buffer> C :tab Git commit -a<CR>
nmap <buffer> cn :Git commit -a --amend --no-edit<CR>

nmap <buffer> gp :Git push<CR>
nmap <buffer> gP :Git push -f<CR>
nmap <buffer> gf :Git fetch<CR>
nmap <buffer> gl :Git pull<CR>

" Fetch and rebase onto origin branches
nmap <buffer> rod :Git pull --rebase=interactive origin develop<CR>
nmap <buffer> rom :Git pull --rebase=interactive origin master<CR>

nmap <buffer> q gq

nmap <buffer> D :DiffviewOpen<CR>
