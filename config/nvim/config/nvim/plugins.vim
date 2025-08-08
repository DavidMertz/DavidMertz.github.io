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

" On-demand lazy load of vim-which-key
Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }

" To register the descriptions when using the on-demand load feature,
" use the autocmd hook to call which_key#register(), e.g., register for the Space key:
" autocmd! User vim-which-key call which_key#register('<Space>', 'g:which_key_map')
"
call plug#end()
