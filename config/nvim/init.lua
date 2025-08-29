local vim = vim
local Plug = vim.fn["plug#"]

-- Set the Leader key to comma
vim.g.mapleader = ","

-- Load keymaps from convenient (and prior) vim format
vim.cmd("source /home/dmertz/.config/nvim/keymap.vim")

-- Load plugings using vim-plug
vim.cmd("source /home/dmertz/.config/nvim/plugins.vim")

-- 'silent!' to ignore errors if not yet installed.
vim.cmd("silent! colorscheme greenscreen")

-- Pyright to check types (using LSP)
require("pyright")

-- Tabnine configuration
if os.getenv("NO_AI") == nil then
	require("tabnine-setup")
end

-- Treesitter configuration
require("treesitter")

-- Share clipboard with system
vim.api.nvim_set_option("clipboard", "unnamed")

--  Some elements of appearance and behavior
vim.opt.winborder = 'rounded'
vim.opt.autoindent = true    -- always set autoindenting on
vim.opt.autowrite = true     -- auto saves changes when quitting and swiching buffer
vim.opt.cindent = true       -- cindent
vim.opt.cursorline = true
vim.opt.expandtab = true      -- tabs are converted to spaces, use only when required
vim.opt.foldmethod = 'indent'
vim.opt.hlsearch = true        -- highlight searches
vim.opt.incsearch = true       -- do incremental searching
vim.opt.modeline = true        -- document can set vim mode
vim.opt.modelines = 3     -- number lines checked for modelines
vim.opt.mouse = 'a'        -- enable mouse movement
vim.opt.backup = false        -- do not keep aebackup file
vim.opt.ignorecase = false   -- don't ignore case
vim.opt.linebreak = false    -- Visual break at window width not tw setting
vim.opt.number = false        -- do not show line numbers
vim.opt.startofline = false   -- don't jump to first character when paging
vim.opt.ruler = true          -- show the cursor position all the time
vim.opt.scrolloff = 3     -- keep 3 lines when scrolling
vim.opt.shiftwidth = 4    -- numbers of spaces to (auto)indent
vim.opt.shortmess = 'atI'   -- Abbreviate messages
vim.opt.showbreak = '››› '  -- Continuation line indicator
vim.opt.showcmd = true        -- display incomplete commands
vim.opt.smartindent = true    -- smart indent
vim.opt.sm = true            -- show matching braces
vim.opt.synmaxcol = 0     -- highlight very long lines
vim.opt.tabstop = 4       -- numbers of spaces of tab character
vim.opt.visualbell = true      -- turn on visual bell
vim.opt.whichwrap = 'b,s,h,l,<,>,[,]'   -- move freely between files


-- TODO: this is an experiment (should go in some other file)
vim.diagnostic.config({
  virtual_text = {
    -- source = "always",  -- Or "if_many"
    prefix = '×', -- Could be '●', '■', '▎', 'x'
  },
  severity_sort = true,
  float = {
    source = "always",  -- Or "if_many"
  },
})
vim.keymap.set("n", "<leader>de", "<cmd>lua vim.diagnostic.enable()<cr>")
vim.keymap.set("n", "<leader>dd", "<cmd>lua vim.diagnostic.disable()<cr>")
vim.keymap.set("n", "<leader>dn", "<cmd>lua vim.diagnostic.jump({count = 1})<cr>")
vim.keymap.set("n", "<leader>dp", "<cmd>lua vim.diagnostic.jump({count = -1})<cr>")
