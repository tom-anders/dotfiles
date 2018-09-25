so $VIMRUNTIME/syntax/tex.vim

" adapt to match your system wide variable in $VIMRUNTIME/syntax/tex.vim
let s:tex_fast= "bcmMprsSvV"

if !exists("g:tex_no_math")
 call TexNewMathZone("E","eqbox",1)
endif

if s:tex_fast =~# 'r'
  syn region texRefZone     matchgroup=texStatement start="\\autoref{"  end="}\|%stopzone\>"    contains=@texRefGroup
endif
