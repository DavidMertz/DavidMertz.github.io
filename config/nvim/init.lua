local vim = vim
-- Add packages using built-in manager
vim.pack.add({
    "https://github.com/neovim/nvim-lspconfig",
    "http://github.com/tpope/vim-sensible",
    "https://github.com/ibhagwan/fzf-lua",
    "https://github.com/catgoose/nvim-colorizer.lua",
    "https://github.com/ibhagwan/fzf-lua",
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/mikavilpas/yazi.nvim",
})

-- Ty LSP settings, if we want them
vim.lsp.config("ty", {settings = {ty = {}}}) -- ty lsp settings
vim.lsp.enable("ty")

-- Fzf-lua setup
require("fzf-lua").setup({file_icons = false, winopts = {backdrop = 30}})

-- Nvim-colorizer setup
vim.o.termguicolors = true
require("colorizer").setup()

-- Treesitter installer and configuration
require("nvim-treesitter").setup({
    config = {
        ensure_installed = {
            "c", "cpp", "go", "haskell", "javascript", "julia", "lua",
            "markdown", "markdown_inline", "perl", "php", "python", "query",
            "rust", "sql", "typescript", "vim", "vimdoc"
        },
        highlight = {enable = true, additional_vim_regex_highlighting = false},
        indent = {enable = true},
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<C-n>",
                node_incremental = "<C-n>",
                scope_incremental = "<C-s>"
            }
        }
    }
})

--  Some elements of appearance and behavior
vim.opt.autoindent = true -- always set autoindenting on
vim.opt.autowrite = true -- auto saves changes when quitting and swiching buffer
vim.opt.cindent = true -- cindent
vim.opt.cursorline = true
vim.opt.expandtab = true -- tabs are converted to spaces
vim.opt.foldmethod = "indent"
vim.opt.foldenable = false -- start in unfolded view
vim.opt.hlsearch = true -- highlight searches
vim.opt.incsearch = true -- do incremental searching
vim.opt.modeline = true -- document can set vim mode
vim.opt.modelines = 3 -- number lines checked for modelines
vim.opt.mouse = "a" -- enable mouse movement
vim.opt.backup = false -- do not keep aebackup file
vim.opt.ignorecase = false -- don't ignore case
vim.opt.linebreak = false -- Visual break at window width not tw setting
vim.opt.number = false -- do not show line numbers
vim.opt.startofline = false -- don't jump to first character when paging
vim.opt.ruler = true -- show the cursor position all the time
vim.opt.scrolloff = 3 -- keep 3 lines when scrolling
vim.opt.shiftwidth = 4 -- numbers of spaces to (auto)indent
vim.opt.shortmess = "atI" -- Abbreviate messages
vim.opt.showbreak = "››› " -- Continuation line indicator
vim.opt.showcmd = true -- display incomplete commands
vim.opt.smartindent = true -- smart indent
vim.opt.sm = true -- show matching braces
vim.opt.synmaxcol = 0 -- highlight very long lines
vim.opt.tabstop = 4 -- numbers of spaces of tab character
vim.opt.visualbell = true -- turn on visual bell
vim.opt.whichwrap = "b,s,h,l,<,>,[,]" -- move freely between files

-- Configure the diagnostics display and add keybindings
vim.diagnostic.config({
    virtual_text = {
        -- source = "always",  -- Or "if_many"
        prefix = "×" -- Could be '●', '■', '▎', 'x'
    },
    severity_sort = true,
    float = {
        source = "always" -- Or "if_many"
    }
})

-- Set the Leader key to comma
vim.g.mapleader = ","

-- Load keymaps from convenient (and prior) vim format
vim.cmd("source /home/dmertz/.config/nvim/keymap.vim")

-- 'silent!' to ignore errors if not yet installed.
vim.cmd("silent! colorscheme lucider")

-- Most keybindings are in keymap.vim, but we'll transition to lua
vim.keymap.set("n", "<leader>dv", "<cmd>lua vim.diagnostic.show()<cr>")
vim.keymap.set("n", "<leader>dh", "<cmd>lua vim.diagnostic.hide()<cr>")
vim.keymap.set("n", "<leader>dn",
               "<cmd>lua vim.diagnostic.jump({count = 1})<cr>")
vim.keymap.set("n", "<leader>dp",
               "<cmd>lua vim.diagnostic.jump({count = -1})<cr>")
