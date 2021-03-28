" Syntax file for:  
" "Text processing in Python" by David Mertz <mertz@gnosis.cx>  
" http://gnosis.cx/TPiP  
" Maintainer:	Mikolaj Machowski <mikmach@wp.pl> 
" Last Change:	2003 Jul 13 
 
" For version 5.x: Clear all syntax items 
" For version 6.x: Quit when a syntax file was already loaded 
if version < 600 
  syntax clear 
elseif exists("b:current_syntax") 
  finish 
endif 
 
" Section titles 
syn match pybHeadline		"^\(FRONTMATTER\|CHAPTER\|SECTION\|APPENDIX\).*" 
syn match pybHeadline		"^  \(TOPIC\|PROBLEM\|EXERCISE\).*" 
syn match pybHeadline		"^  [-A-Z 0-9]\+:$" 
" Ignore 
syn match pybIgnore             "^  THIS IS [A-Z]\+$" 
" Delimiters 
syn match pybSectionDelim	"\s\{,2}[-=]*$" 
" Examples 
syn region pybExample		start="^ \+#[*]\?[-=]\+" end="\n\n\(A\|  \S\)"me=e-3 
syn region pybExample		start="^ \+>>>" end="\n\n" 
syn match pybExample		"-->+\?" 
syn match pybExample		"<--" 
" 'functions' 
syn match pybCommand		"'[_A-Za-z0-9()]\+'" 
" Lesser delimiters 
syn match pybLesserDelim	"+++" 
" `backtick commands` 
syn match pybBacktick		"`\S\+`" 
" mails 
syn match pybMail		"<[-a-zA-Z0-9_@/:\.]\+>" 
" See also 
syn match pybSeeAlso		"SEE ALSO" 
" Module names 
syn match pybModules		"\s\[[-a-z^A-Z0-9_\.]\+]"ms=s+1 
" Titles of books 
syn region pybBookTitle		start="\W_[A-Z]"ms=s+1 end="_\(\A\|$\)"me=e-1 
" Underscore 
syn region pybUnderline		start="\s-[^-0-9¯l*][^yd]"ms=s+1 end="-\(\W\|$\)"me=e-1 
syn match pybUnderline		"-F-" 
 
syn sync minlines=40 
 
" Define the default highlighting. 
" For version 5.7 and earlier: only when not done already 
" For version 5.8 and later: only when an item doesn't have highlighting yet 
if version >= 508 || !exists("did_help_syntax_inits") 
  if version < 508 
    let did_help_syntax_inits = 1 
    command -nargs=+ HiLink hi link <args> 
  else 
    command -nargs=+ HiLink hi def link <args> 
  endif 
 
  HiLink pybHeadline		Statement 
  HiLink pybIgnore		Ignore 
  HiLink pybSectionDelim	PreProc 
  HiLink pybExample		Comment 
  HiLink pybCommand		Type 
  HiLink pybLesserDelim		Type 
  HiLink pybBacktick		Comment 
  HiLink pybModules		Special 
  HiLink pybMail		Special 
  HiLink pybSeeAlso		Todo 
  HiLink pybBookTitle		Identifier 
  HiLink pybUnderline           String 
 
  delcommand HiLink 
endif 
 
let b:current_syntax = "pyb" 
 
" vim: ts=8 sw=2 
