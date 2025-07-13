call plug#begin()

" A few "sensible" behaviors for vim
Plug 'tpope/vim-sensible'

" fzf-lua and some icons
Plug 'ibhagwan/fzf-lua', {'branch': 'main'}
Plug 'nvim-tree/nvim-web-devicons'

" Tabnine AI code assistant
Plug 'codota/tabnine-nvim', { 'do': './dl_binaries.sh' }

" Add treesitter for prettier highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

call plug#end()
