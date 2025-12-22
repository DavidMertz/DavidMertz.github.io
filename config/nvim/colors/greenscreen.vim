" vim: tw=0 ts=4 sw=4
" Vim color file
"
" Creator: David Mertz <mertz@gnosis.cx>
" A color scheme meant to 'play nice' with old-school green-on-black terminals

hi clear
set background=dark
if exists("syntax_on")
  syntax reset
endif

let g:colors_name = 'greenscreen' " Simple and limited colors
hi Normal        guifg=green guibg=gray1
hi Comment       guifg=Violet
hi Constant      gui=italic
hi Cursor        guifg=black guibg=white
hi CursorLine    guifg=white guibg=darkgreen 
hi Identifier    guifg=SkyBlue
hi Keyword       guifg=LightBlue gui=italic 
hi LineNr        guifg=lightgreen guibg=gray6
hi StatusLine    guifg=white guibg=darkcyan 

hi link Number   Constant
hi link Boolean  Constant
hi link Float    Constant

" Maybe add these back in later (2025-11-04)
"hi ColorColumn   ctermfg=white ctermbg=black
"hi Conceal       ctermfg=cyan
"hi Directory     ctermfg=DarkYellow term=bold  cterm=bold  
"hi Error         ctermbg=red ctermfg=white
"hi ErrorMsg      cterm=bold  ctermfg=White  ctermbg=Red  
"hi Folded        ctermfg=yellow
"hi Menu          ctermfg=darkyellow 
"hi ModeMsg       term=bold  ctermfg=DarkYellow cterm=bold
"hi MoreMsg       cterm=bold  ctermfg=Yellow
"hi NonText       ctermfg=LightBlue term=bold  cterm=bold  
"hi PreProc       term=underline  ctermfg=brown
"hi Question      term=standout  cterm=bold  ctermfg=Brown
"hi Scrollbar     ctermfg=Yellow 
"hi Search        ctermfg=white  ctermbg=red
"hi Special       term=bold  cterm=bold ctermfg=red 
"hi SpecialKey    ctermfg=yellow term=bold  cterm=bold  
"hi Statement     term=bold ctermfg=white cterm=bold 
"hi Title         cterm=bold  ctermfg=brown
"hi Todo          term=bold  ctermfg=lightblue ctermbg=yellow 
"hi Type          term=underline  cterm=bold ctermfg=lightgreen 
"hi VertSplit     ctermfg=black ctermbg=grey
"hi Visual        cterm=underline ctermfg=lightblue ctermbg=black
"hi WarningMsg    cterm=bold  ctermfg=darkblue 

" Maybe add these back in later (2025-11-04)
"hi link IncSearch      Visual
"hi link String         Constant
"hi link Character      Constant
"hi link Function       Identifier
"hi link Conditional    Statement
"hi link Repeat         Statement
"hi link Label          Statement
"hi link Operator       Statement
"hi link Exception      Statement
"hi link Include        PreProc
"hi link Define         PreProc
"hi link Macro          PreProc
"hi link PreCondit      PreProc
"hi link StorageClass   Type
"hi link Structure      Type
"hi link Typedef        Type
"hi link Tag            Special
"hi link SpecialChar    Special
"hi link Delimiter      Special
"hi link SpecialComment Special
"hi link Debug          Special

