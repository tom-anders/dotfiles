let g:asciidoctor_pdf_extensions = ['asciidoctor-diagram']

let g:asciidoctor_folding = 1
let g:asciidoctor_fold_options = 1
autocmd FileType asciidoctor set foldlevel=99 "Open all folds by default

let g:asciidoctor_fenced_languages = ['python', 'c', 'cpp', 'json', 'plantuml']
let g:asciidoctor_syntax_conceal = 1
autocmd FileType asciidoctor set conceallevel=2 

autocmd FileType asciidoctor set textwidth=120
autocmd FileType asciidoctor set wrap
" Add indent for labeled lists (XY:: etc.)
autocmd FileType asciidoctor set formatlistpat+=\\\|^.*::\\+\\s\\+
