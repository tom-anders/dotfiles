""symlink this to ~/.vim/syntax/tex.vim
"so $VIMRUNTIME/syntax/tex.vim

"" adapt to match your system wide variable in $VIMRUNTIME/syntax/tex.vim
"let s:tex_fast= "bcmMprsSvV"

"if !exists("g:tex_no_math")
" call TexNewMathZone("E","eqbox",1)
" call TexNewMathZone("E","albox",1)
"endif

"if s:tex_fast =~# 'r'
"  syn region texRefZone     matchgroup=texStatement start="\\autoref{"  end="}\|%stopzone\>"    contains=@texRefGroup
"endif

syn match texMathSymbol '\\Q\(=\| \|\n\|{\|}\|\[\|\]\|\^\|_\|+\|-\|\\\|(\|)\)\@=' contained conceal cchar=Θ
syn match texMathSymbol '\\O\(=\| \|\n\|{\|}\|\[\|\]\|\^\|_\|+\|-\|\\\|(\|)\)\@=' contained conceal cchar=Ω
syn match texMathSymbol '\\Y\(=\| \|\n\|{\|}\|\[\|\]\|\^\|_\|+\|-\|\\\|(\|)\)\@=' contained conceal cchar=Ψ
syn match texMathSymbol '\\P\(=\| \|\n\|{\|}\|\[\|\]\|\^\|_\|+\|-\|\\\|(\|)\)\@=' contained conceal cchar=Π
syn match texMathSymbol '\\L\(=\| \|\n\|{\|}\|\[\|\]\|\^\|_\|+\|-\|\\\|(\|)\)\@=' contained conceal cchar=Λ
syn match texMathSymbol '\\G\(=\| \|\n\|{\|}\|\[\|\]\|\^\|_\|+\|-\|\\\|(\|)\)\@=' contained conceal cchar=Γ
syn match texMathSymbol '\\F\(=\| \|\n\|{\|}\|\[\|\]\|\^\|_\|+\|-\|\\\|(\|)\)\@=' contained conceal cchar=Φ
syn match texMathSymbol '\\D\(=\| \|\n\|{\|}\|\[\|\]\|\^\|_\|+\|-\|\\\|(\|)\)\@=' contained conceal cchar=Δ
syn match texMathSymbol '\\S\(=\| \|\n\|{\|}\|\[\|\]\|\^\|_\|+\|-\|\\\|(\|)\)\@=' contained conceal cchar=Σ
syn match texMathSymbol '\\q\(=\| \|\n\|{\|}\|\[\|\]\|\^\|_\|+\|-\|\\\|(\|)\)\@=' contained conceal cchar=θ
syn match texMathSymbol '\\o\(=\| \|\n\|{\|}\|\[\|\]\|\^\|_\|+\|-\|\\\|(\|)\)\@=' contained conceal cchar=ω
syn match texMathSymbol '\\e\(=\| \|\n\|{\|}\|\[\|\]\|\^\|_\|+\|-\|\\\|(\|)\)\@=' contained conceal cchar=ε
syn match texMathSymbol '\\r\(=\| \|\n\|{\|}\|\[\|\]\|\^\|_\|+\|-\|\\\|(\|)\)\@=' contained conceal cchar=ρ
syn match texMathSymbol '\\t\(=\| \|\n\|{\|}\|\[\|\]\|\^\|_\|+\|-\|\\\|(\|)\)\@=' contained conceal cchar=τ
syn match texMathSymbol '\\y\(=\| \|\n\|{\|}\|\[\|\]\|\^\|_\|+\|-\|\\\|(\|)\)\@=' contained conceal cchar=ψ
syn match texMathSymbol '\\p\(=\| \|\n\|{\|}\|\[\|\]\|\^\|_\|+\|-\|\\\|(\|)\)\@=' contained conceal cchar=π
syn match texMathSymbol '\\l\(=\| \|\n\|{\|}\|\[\|\]\|\^\|_\|+\|-\|\\\|(\|)\)\@=' contained conceal cchar=λ
syn match texMathSymbol '\\k\(=\| \|\n\|{\|}\|\[\|\]\|\^\|_\|+\|-\|\\\|(\|)\)\@=' contained conceal cchar=κ
syn match texMathSymbol '\\n\(=\| \|\n\|{\|}\|\[\|\]\|\^\|_\|+\|-\|\\\|(\|)\)\@=' contained conceal cchar=η
syn match texMathSymbol '\\g\(=\| \|\n\|{\|}\|\[\|\]\|\^\|_\|+\|-\|\\\|(\|)\)\@=' contained conceal cchar=γ
syn match texMathSymbol '\\f\(=\| \|\n\|{\|}\|\[\|\]\|\^\|_\|+\|-\|\\\|(\|)\)\@=' contained conceal cchar=φ
syn match texMathSymbol '\\d\(=\| \|\n\|{\|}\|\[\|\]\|\^\|_\|+\|-\|\\\|(\|)\)\@=' contained conceal cchar=δ
syn match texMathSymbol '\\s\(=\| \|\n\|{\|}\|\[\|\]\|\^\|_\|+\|-\|\\\|(\|)\)\@=' contained conceal cchar=σ
syn match texMathSymbol '\\a\(=\| \|\n\|{\|}\|\[\|\]\|\^\|_\|+\|-\|\\\|(\|)\)\@=' contained conceal cchar=α
syn match texMathSymbol '\\c\(=\| \|\n\|{\|}\|\[\|\]\|\^\|_\|+\|-\|\\\|(\|)\)\@=' contained conceal cchar=χ
syn match texMathSymbol '\\b\(=\| \|\n\|{\|}\|\[\|\]\|\^\|_\|+\|-\|\\\|(\|)\)\@=' contained conceal cchar=β
syn match texMathSymbol '\\v\(=\| \|\n\|{\|}\|\[\|\]\|\^\|_\|+\|-\|\\\|(\|)\)\@=' contained conceal cchar=ν
syn match texMathSymbol '\\m\(=\| \|\n\|{\|}\|\[\|\]\|\^\|_\|+\|-\|\\\|(\|)\)\@=' contained conceal cchar=μ
syn match texMathSymbol '\\h\(=\| \|\n\|{\|}\|\[\|\]\|\^\|_\|+\|-\|\\\|(\|)\)\@=' contained conceal cchar=ħ
syn match texMathSymbol '\\hbar\(=\| \|\n\|{\|}\|\[\|\]\|\^\|_\|+\|-\|\\\|(\|)\)\@=' contained conceal cchar=ħ

syn match texMathSymbol '\\qty' contained conceal

syn region texBoldMathText matchgroup=texStatement start='\\\(label\){' end='}' concealends contains=@texMathZoneGroup containedin=texMathMatcher

