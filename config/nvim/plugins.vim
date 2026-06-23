call plug#begin()

" A few "sensible" behaviors for vim
Plug 'tpope/vim-sensible'

" fzf-lua and some icons
Plug 'ibhagwan/fzf-lua', {'branch': 'main'}

" Tabnine AI code assistant
Plug 'codota/tabnine-nvim', { 'do': './dl_binaries.sh' }

" Generate tags in background
" Plug 'ludovicchabant/vim-gutentags'

call plug#end()
