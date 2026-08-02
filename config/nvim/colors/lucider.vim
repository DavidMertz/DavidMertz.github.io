" Vim color scheme Lucider
" ----------------------------------------------------------------------
"
" Based on:   https://github.com/cseelus/vim-colors-lucid
" Author:     Chris Seelus (@cseelus)
" Modified:   David Mertz
"
" very saturated grays
:let _jet_black   = '#000000'
:let _coal        = '#060606'
:let _rock_dark   = '#0b0b0b'
:let _rock        = '#181320'
:let _rock_medium = '#36323d'

" normal grays
" --------------------------
:let _gray_dark   = '#534d5e'
:let _gray        = '#847d91'
:let _gray_medium = '#beb8cc'
:let _gray_light  = '#d2c3ef'
:let _cloud       = '#e4e0ed'

" colors
" --------------------------
:let _turquoise   = '#3fc997'
:let _fluoric     = '#d0ffc3'
:let _cyan        = '#99feff'
:let _steel       = '#83a8d1'
:let _powder      = '#8fc7db'
:let _magenta     = '#CC66CC'
:let _sky         = '#b3e4eb'
:let _pink        = '#db0088'
:let _sap         = '#fde9a2'
:let _greenest    = '#00ff00'
:let _purple      = '#550055'
:let _darksteel   = '#4368a1'

" Light/inverted colors (darkrock-cloud, rock-lightgrey switched)
if &background == "light"
    ":let ... same names with different colors
endif

set background=dark
highlight clear

if exists("syntax_on")
  syntax reset
endif

"set t_Co=256
let colors_name = "lucider"
let colorgroup = {}

" Interface
" ----------------------------------------------------------------------
let colorgroup['Normal']       = {"GUIFG": _cloud,     "GUIBG":  _rock_dark}
let colorgroup['Darker']       = {"GUIFG": _gray,      "GUIBG":  _rock_dark}
let colorgroup['ColorColumn']  = {"GUIFG": _rock_dark, "GUIBG":  _steel}
let colorgroup['Conceal']      = {"GUIFG": _sap,       "GUI": "bold"}
let colorgroup['Cursor']       = {"GUIFG": _rock_dark, "GUIBG":  _turquoise}
let colorgroup['CursorLine']   = {"GUIFG": _greenest,  "GUIBG":  _jet_black}
let colorgroup['CursorLineNr'] = {"GUIFG": _gray_dark, "GUIBG":  _rock_dark}
let colorgroup['Directory']    = {"GUIFG": _fluoric,   "GUIBG":  _rock_dark}
let colorgroup['Error']        = {"GUIFG": _rock_dark, "GUIBG":  _pink}
let colorgroup['ErrorMsg']     = {"GUIFG": _rock_dark, "GUIBG":  _pink}
let colorgroup['FoldColumn']   = {                     "GUIBG":  _rock_dark}
let colorgroup['Folded']       = {"GUIFG": _cloud,     "GUIBG":  _rock}
let colorgroup['LineNr']       = {"GUIFG": _gray_dark, "GUIBG":  _rock_dark}
let colorgroup['MatchParen']   = {"GUIFG": _rock_dark, "GUIBG":  _greenest}
let colorgroup['ModeMsg']      = {"GUIFG": _rock_dark, "GUIBG":  _turquoise}
let colorgroup['NormalFloat']  = {"GUIFG": _cloud,     "GUIBG":  _darksteel}
let colorgroup['Pmenu']        = {"GUIFG": _cloud,     "GUIBG":  _rock_medium}
let colorgroup['PmenuSbar']    = {                     "GUIBG":  _rock_dark}
let colorgroup['PmenuSel']     = {"GUIFG": _rock_dark, "GUIBG":  _turquoise}
let colorgroup['Search']       = {"GUIFG": _greenest,  "GUIBG":  _rock_dark, "GUI": "underline"}
let colorgroup['SignColumn']   = {                     "GUIBG":  _rock_dark}
let colorgroup['StatusLine']   = {"GUIFG": _greenest,  "GUIBG":  _coal}
let colorgroup['StatusLineNC'] = {"GUIFG": _gray_dark, "GUIBG":  _rock}
let colorgroup['Title']        = {"GUIFG": _pink,      "GUI": "bold"}
let colorgroup['Todo']         = {"GUIFG": _rock_dark, "GUIBG":  _powder}
let colorgroup['VertSplit']    = {"GUIFG": _rock,      "GUIBG":  _rock}
let colorgroup['Visual']       = {"GUIFG": _rock_dark, "GUIBG":  _sap}
if &background == "light"
  let colorgroup['Visual']       = {"GUIFG": _cloud,     "GUIBG":  _sap}
endif
let colorgroup['WarningMsg']   = {"GUIFG": _rock_dark, "GUIBG":  _steel}

" Syntax
" ----------------------------------------------------------------------
let colorgroup['Access']       = {"GUIFG": _steel,    "GUI": "bold"}
let colorgroup['Comment']      = {"GUIFG": _magenta,   "GUI": "italic"}
let colorgroup['Class']        = {"GUIFG": _pink,      "GUI": "italic"}
let colorgroup['Conditional']  = {"GUIFG": _cyan}
let colorgroup['Constant']     = {"GUIFG": _turquoise, "GUI": "bold"}
let colorgroup['Delimiter']    = {"GUIFG": _sky}
let colorgroup['Function']     = {"GUIFG": _steel}
let colorgroup['Identifier']   = {"GUIFG": _sky}
let colorgroup['Module']       = {"GUIFG": _pink,      "GUI": "underline"}
let colorgroup['NonText']      = {"GUIFG": _gray_dark}
let colorgroup['Number']       = {"GUIFG": _turquoise}
let colorgroup['PreProc']      = {"GUIFG": _pink}
let colorgroup['Statement']    = {"GUIFG": _turquoise}
let colorgroup['Special']      = {"GUIFG": _pink}
let colorgroup['SpecialKey']   = {"GUIFG": _gray_light}
let colorgroup['String']       = {"GUIFG": _fluoric}
let colorgroup['StorageClass'] = {"GUIFG": _cloud,     "GUI": "bold"}
let colorgroup['Structure']    = {"GUIFG": _gray_medium}
let colorgroup['Symbol']       = {"GUIFG": _sky}
let colorgroup['Type']         = {"GUIFG": _steel}
let colorgroup['Underlined']   = {"GUIFG": _turquoise, "GUI": "underline"}
let colorgroup['Userdef']      = {"GUIFG": _sap}
" ------------------------
hi link Boolean               Number
hi link Character             Function
hi link ErrorMsg              Error
hi link Debug                 Special
hi link Define                PreProc
hi link Exception             PreProc
hi link Float                 Number
hi link Include               Function
hi link Label                 Statement
hi link Macro                 PreProc
hi link Operator              PreProc
hi link PreCondit             PreProc
hi link Repeat                Statement
hi link SpecialChar           Special
hi link SpecialComment        Special
hi link Typedef               Type
hi link Tag                   Special


" Plugins
" ----------------------------------------------------------------------

" CtrlP
hi link CtrlPMatch            Function

" Git commit
hi link gitcommitBranch        Constant
hi link gitcommitSelectedFile  Statement
hi link gitcommitDiscardedFile Structure
hi link gitcommitUntrackedFile Structure
hi link gitcommitSummary       String

" GitGutter
hi link GitGutterAdd          Darker
hi link GitGutterChange       Darker
hi link GitGutterDelete       Darker
hi link GitGutterChangeDelete Darker

" NERDtree
hi link NerdTreeCWD           Statement
hi link NerdTreeHelpKey       Function
hi link NerdTreeHelpTitle     Statement
hi link NerdTreeOpenable      Statement
hi link NerdTreeClosable      Statement
hi link NerdTreeDir           Normal
hi link NerdTreeDirSlash      Statement

" PlainTasks (.todo)
hi link ptCompleteTask        Number
hi link ptContext             Type
hi link ptSection             Title
hi link ptTask                Normal

" Startify
hi link StartifyNumber        Statement
hi link StartifyBracket       Statement
hi link StartifySection       Title
hi link StartifyPath          Comment
hi link StartifySlash         Comment
hi link StartifyFile          StorageClass


" Language
" ----------------------------------------------------------------------

" Apache
hi link apacheDeclaration     PreProc

" CoffeeScript
hi link coffeeExtendedOp      Function
hi link coffeeObject          Statement
hi link coffeeObjAssign       Function
hi link coffeeParen           Function

" CSS
hi link cssAttr               String
hi link cssClass              Type
hi link cssProp               Identifier
hi link cssSelectorOp         Identifier

" HAML
hi link hamlTag               Function

" HTML
" hi link htmlArg               Symbol
" hi link htmlTag               Constant
hi link htmlTagName           Constant
" hi link htmlEndTag            Function

" JavaScript
hi link javascriptFuncArg     Function
hi link javascriptFuncComma   Function
hi link javascriptFuncDef     Statement
hi link javascriptFuncKeyword Statement
hi link javascriptOpSymbols   Type
hi link javascriptParens      Function
hi link javascriptEndcolons   Function

" Javascript (pangloss/vim-javascript)
hi link jsBraces              Delimiter
hi link jsClassDefinition     Constant
hi link jsClassKeyword        PreProc
hi link jsExtendsKeyword      Function
hi link jsFuncCall            Function
hi link jsModuleKeyword       Identifier
hi link jsNull                Identifier
hi link jsObjectKey           Identifier
hi link jsStorageClass        Structure
hi link jsTemplateBraces      PreProc

" JSON
hi link jsonKeyword           Function

" LaTeX
hi link texInputFile          PreProc
hi link texDocType            Constant
hi link texDocTypeArgs        Function
hi link texInputFile          Symbol
hi link texInputFileOpt       String
hi link texMathMatcher        Statement
hi link texMathSymbol         Symbol
hi link texMathZoneA          Symbol
hi link texMathZoneAS         Symbol
hi link texSection            Title
hi link texStatement          Function
hi link texTypeSize           Symbol
hi link texTypeStyle          Symbol
" hi link texSpecialChar        Userdef

" Markdown
hi link mkdBlockquote         Symbol
hi link mkdCode               Identifier
hi link mkdIndentCode         Identifier
hi link mkdLink               Normal

" MatchTagAlways
hi link MatchTag              Identifier

" PHP
hi link phpParent             Normal
hi link phpRegion             Comment
hi link phpVarSelector        Identifier

" Ruby
hi link rubyAccess            Access
hi link rubyCallback          Function
hi link rubyClass             Class
hi link rubyControl           Statement
hi link rubyConstant          Constant
hi link rubyEntity            Function
hi link rubyFunction          StorageClass
hi link rubyInclude           Include
hi link rubyInterpolation     Include
hi link rubyMacro             Function
hi link rubyModule            Module
" hi link RubyPseudoVariable    Type
hi link rubyStringDelimiter   rubyString
hi link rubySymbol            Symbol

" SASS
hi link sassClassChar         Type
" " hi link sassExtend            Symbol
" " hi link sassMixing            Symbol
hi link sassIdChar            Identifier
" hi link sassVariable          Function

" Slim
" hi link slimDocType           Function
" hi link slimDocTypeKeyword    Statement
hi link rubyKeyword              PreProc
" hi link slimRubyChar          PreProc
" hi link slimRubyOutputChar    PreProc
" hi link slimText              Normal

" VimL
hi link vimCmdSep             Function

" YAML
hi link yamlBlockMappingKey   Function
hi link yamlDocumentStart     Comment

" XML
hi link xmlEndTag             Function


" Expand colorgroups
" ----------------------------------------------------------------------
let s:colors = {}
" http://choorucode.com/2011/07/29/vim-chart-of-color-names/
let valid_cterm_colors =
      \ [
      \     'Black', 'DarkBlue', 'DarkGreen', 'DarkCyan',
      \     'DarkRed', 'DarkMagenta', 'Brown', 'DarkYellow',
      \     'LightGray', 'LightGrey', 'Gray', 'Grey',
      \     'DarkGray', 'DarkGrey', 'Blue', 'LightBlue',
      \     'Green', 'LightGreen', 'Cyan', 'LightCyan',
      \     'Red', 'LightRed', 'Magenta', 'LightMagenta',
      \     'Yellow', 'LightYellow', 'White',
      \ ]
for key in keys(colorgroup)
  let s:colors = colorgroup[key]
  if has_key(s:colors, 'TERM')
    let term = s:colors['TERM']
  else
    let term = 'NONE'
  endif
  if has_key(s:colors, 'GUI')
    let gui = s:colors['GUI']
  else
    let gui='NONE'
  endif
  if has_key(s:colors, 'GUIFG')
    let guifg = s:colors['GUIFG']
  else
    let guifg='NONE'
  endif
  if has_key(s:colors, 'GUIBG')
    let guibg = s:colors['GUIBG']
  else
    let guibg='NONE'
  endif
  if has_key(s:colors, 'CTERM')
    let cterm = s:colors['CTERM']
  else
    let cterm=gui
  endif
  if has_key(s:colors, 'CTERMFG')
    let ctermfg = s:colors['CTERMFG']
  else
    if index(valid_cterm_colors, guifg) != -1
      let ctermfg=guifg
    else
      let ctermfg='Blue'
    endif
  endif
  if has_key(s:colors, 'CTERMBG')
    let ctermbg = s:colors['CTERMBG']
  else
    if index(valid_cterm_colors, guibg) != -1
      let ctermbg=guibg
    else
      let ctermbg='NONE'
    endif
  endif
  if has_key(s:colors, 'GUISP')
    let guisp = s:colors['GUISP']
  else
    let guisp='NONE'
  endif

  if key =~ '^\k*$'
    execute "hi ".key." term=".term." cterm=".cterm." gui=".gui." ctermfg=".ctermfg." guifg=".guifg." ctermbg=".ctermbg." guibg=".guibg." guisp=".guisp
  endif
endfor
