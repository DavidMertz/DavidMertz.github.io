if did_filetype()	" filetype already set..
  finish		" ..don't do these checks
endif
if getline(1) =~ '^#!.*\<uvx\>'
  setfiletype python
elseif getline(1) =~? '\<something_else\>'
  setfiletype ignored
endif
