" Vim color file
"
" Creator: David Mertz <mertz@gnosis.cx>
" Credits: Based on 'golden' by Ryan Phillips <ryan@trolocsis.com>
"          http://www.trolocsis.com/vim/golden.vim
"          This color scheme originated from the idea of 
"          Jeffrey Bakker, the creator of webcpp (http://webcpp.sourceforge.net/).
"
" A color scheme meant to 'play nice' with old-school green-on-black terminals

hi clear
set background=dark
if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "greenscreen"
hi ColorColumn  ctermfg=white ctermbg=black
hi Comment      guifg=lightskyblue
hi Conceal      ctermfg=cyan
hi Constant     term=underline cterm=bold ctermfg=lightred
hi CursorLine   guifg=yellow guibg=gray10 term=bold
hi Directory    ctermfg=darkyellow term=bold cterm=bold  
hi Error        ctermbg=red ctermfg=white
hi ErrorMsg     term=standout cterm=bold ctermfg=white ctermbg=red  
hi Folded       ctermfg=yellow
hi Identifier   guifg=lightgoldenrod
hi Keyword      guifg=thistle 
hi LineNr       term=bold guifg=lawngreen
hi Menu         ctermfg=darkyellow 
hi ModeMsg      term=bold ctermfg=darkyellow cterm=bold
hi MoreMsg      term=bold cterm=bold ctermfg=yellow
hi NonText      ctermfg=lightblue term=bold cterm=bold  
hi Normal       guifg=white guibg=gray6
hi PreProc      term=underline ctermfg=brown
hi Question     term=standout cterm=bold ctermfg=brown
hi Scrollbar    ctermfg=yellow 
hi Search       term=bold guifg=white guibg=green  
hi SpecialKey   ctermfg=yellow term=bold cterm=bold  
hi Special      term=bold cterm=bold ctermfg=red 
hi Statement    term=bold ctermfg=white cterm=bold 
hi StatusLine   guibg=black guifg=lawngreen  " classic greenscreen terminal
hi StatusLineNC term=reverse ctermfg=white ctermbg=black 
hi Title        term=bold cterm=bold ctermfg=brown  
hi Todo         term=bold ctermfg=lightblue ctermbg=yellow 
hi Type         term=underline cterm=bold ctermfg=lightgreen 
hi VertSplit    ctermfg=black ctermbg=darkgrey
hi Visual       term=reverse cterm=reverse 
hi WarningMsg   term=standout cterm=bold ctermfg=darkblue 

" Suggestions from Copilot
hi FoldColumn   ctermfg=white ctermbg=darkgrey
hi IncSearch    ctermfg=white ctermbg=red
hi MatchParen   ctermfg=white ctermbg=red
hi Pmenu        ctermfg=white ctermbg=darkgrey
hi PmenuSbar    ctermfg=white ctermbg=darkgrey
hi PmenuSel     ctermfg=white ctermbg=darkblue
hi PmenuThumb   ctermfg=white ctermbg=darkblue
hi SignColumn   ctermfg=white ctermbg=darkgrey
hi SpellBad     ctermfg=white ctermbg=red
hi SpellCap     ctermfg=white ctermbg=red
hi SpellLocal   ctermfg=white ctermbg=red
hi SpellRare    ctermfg=white ctermbg=red
hi TabLine      ctermfg=white ctermbg=darkgrey
hi TabLineFill  ctermfg=white ctermbg=darkgrey
hi TabLineSel   ctermfg=white ctermbg=darkblue
hi WildMenu     ctermfg=white ctermbg=darkblue

" Syntax types by color element

hi link Boolean        Constant
hi link Character      Constant
hi link Conditional    Statement
hi link Debug          Special
hi link Define         PreProc
hi link Delimiter      Special
hi link Exception      Statement
hi link Float          Number
hi link Function       Identifier
hi link Include        PreProc
hi link IncSearch      Visual
hi link Label          Statement
hi link Macro          PreProc
hi link Number         Constant
hi link Operator       Statement
hi link PreCondit      PreProc
hi link Repeat         Statement
hi link SpecialChar    Special
hi link SpecialComment Special
hi link StorageClass   Type
hi link String         Constant
hi link Structure      Type
hi link Tag            Special
hi link Typedef        Type
