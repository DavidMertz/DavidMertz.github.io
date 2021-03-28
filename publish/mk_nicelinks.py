import os, string
all_files = os.popen("ls -1R")
print 'Nice Places to Look At:'
print 'Local Text Files to Examine Conversion On\n\n'
print '--  '
for line in all_files.readlines():
    line = string.strip(line)
    if len(line) == 0:
	pass
    elif line[-1] == ':':
	dir = line[:-1]
    elif string.lower(line[-4:]) == '.txt':
	print '    http://gnosis.cx/publish/'+dir+'/'+line+'\n'


