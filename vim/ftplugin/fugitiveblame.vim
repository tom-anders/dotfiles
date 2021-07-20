nmap <buffer> q gq

nmap <buffer> gd :execute 'DiffviewOpen' . ' ' . expand('<cword>') . '~1..' . expand('<cword>') <CR>
