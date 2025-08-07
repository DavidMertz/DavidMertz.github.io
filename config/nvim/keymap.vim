function Config()
    edit ~/.config/nvim/init.lua
    edit ~/.config/nvim/keymap.vim
    edit ~/.config/nvim/lua/devicons.lua
    edit ~/.config/nvim/lua/pyright.lua
    edit ~/.config/nvim/lua/tabnine-setup.lua
    edit ~/.config/nvim/lua/treesitter.lua
    edit ~/.config/nvim/plugins.vim
    edit ~/.config/nvim/scripts.vim
endfunction

" Keyboard mappings
" allow unshifted colon
nmap ; :
map <Leader>b :FzfLua buffers<CR>
map <Leader>c +y                                  " copy to system clipboard
map <Leader>e :call Config()<CR>                  " edit initialization files
map <Leader>f :FzfLua files<CR>
" Shortcut to force treesitter folding
map <Leader>F :set foldmethod=expr<CR>:set foldexpr=nvim_treesitter#foldexpr()<CR>
map <Leader>g :FzfLua git_blame<CR>
" Warning popup
map <Leader>i <C-w>d
map <F10> <C-w>d
map <Leader>I :set invlist<CR>                    " toggle visible tabs
map <Leader>j gqip                                " format current paragraph
map <Leader>k :!ruff format %<CR>:e<CR>           " format current Python file
map <Leader>K :!prettier -w %<CR>:e<CR>           " format current JS file
map <Leader>l :set invnumber<CR>                  " toggle line number
map <Leader>n :bn<CR>                             " next buffer
map <Leader>N :bp<CR>                             " previous buffer
map <Leader>p :set syntax=python<CR>              " hack when Python syntax not recognized
map <Leader>r :FzfLua live_grep<CR>
map <Leader>u :source ~/.config/nvim/init.lua<CR> " update the settings from init.lua
map <Leader>w :wa!<CR>                            " write all buffers (force)

" text width for current wrap
map <C-j> :set tw=

imap <BS> <Left><C-O>x
map <BS> <Left>x

digraph in 8712
digraph ni 8713
digraph ^l 8968
digraph ^r 8969
digraph _l 8970
digraph _r 8971

" Some elements of appearance and behavior to someday implement in Lua
set autoindent     " always set autoindenting on
set autowrite      " auto saves changes when quitting and swiching buffer
set cindent        " cindent
set cursorline
set expandtab      " tabs are converted to spaces, use only when required
set foldmethod=indent
set hlsearch        " highlight searches
set incsearch       " do incremental searching
set listchars=tab:\ \ ·,nbsp:¦,eol:↲,space:␣
set modeline        " document can set vim mode
set modelines=3     " number lines checked for modelines
set mouse=a        " enable mouse movement
set nobackup        " do not keep a backup file
set noignorecase    " don't ignore case
set nolinebreak     " Visual break at window width not tw setting
set nonumber        " do not show line numbers
set nostartofline   " don't jump to first character when paging
set ruler           " show the cursor position all the time
set scrolloff=3     " keep 3 lines when scrolling
set shiftwidth=4    " numbers of spaces to (auto)indent
set shortmess=atI   " Abbreviate messages
set showbreak=›››\  " Continuation line indicator
set showcmd         " display incomplete commands
set smartindent    " smart indent
set sm             " show matching braces
set statusline=[%n:%Y]\ %f%m%r%h%w%=(%v:0x%02.2B)\ %l/%L
set synmaxcol=0     " highlight very long lines
set tabstop=4       " numbers of spaces of tab character
set visualbell      " turn on visual bell
set whichwrap=b,s,h,l,<,>,[,]   " move freely between files
