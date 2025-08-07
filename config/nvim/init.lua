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

-- Update some devicons
require("devicons")

-- Share clipboard with system
vim.api.nvim_set_option("clipboard", "unnamed")

-- Visual chrome
vim.opt.winborder = "rounded"


