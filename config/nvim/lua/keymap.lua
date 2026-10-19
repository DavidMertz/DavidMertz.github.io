-- Keybindings, converted from keymap.vim. The ":map"-style bindings use
-- mode "" (normal + visual + select + operator-pending); none of the
-- right-hand sides refer to other mappings, so non-recursive is fine.

-- Edit the initialization files
function _G.Config()
	vim.cmd("edit ~/.config/nvim/init.lua")
	vim.cmd("edit ~/.config/nvim/lua/keymap.lua")
	vim.cmd("edit ~/.config/nvim/scripts.vim")
	vim.cmd("edit ~/.config/nvim/lua/utils.lua")
end

-- Fast 'jk' or 'kj' as homekey version of escape
vim.keymap.set("i", "jk", "<Esc>")
vim.keymap.set("i", "kj", "<Esc>")

-- Keyboard mappings
vim.keymap.set("", "<leader>b", ":FzfLua buffers<CR>")
vim.keymap.set("", "<leader>e", "<cmd>lua Config()<cr>") -- edit initialization files
vim.keymap.set("", "<leader>f", ":FzfLua files<CR>")
-- Shortcut to force treesitter folding
vim.keymap.set("", "<leader>F", ":set foldmethod=expr<CR>:set foldexpr=v:lua.vim.treesitter.foldexpr()<CR>")
vim.keymap.set("", "<leader>g", ":FzfLua git_blame<CR>")
-- Warning popup (linter, etc.)
vim.keymap.set("", "<leader>i", "<C-w>d")
vim.keymap.set("", "<F10>", "<C-w>d")
vim.keymap.set("", "<leader>I", ":set invlist<CR>") -- toggle visible tabs
vim.keymap.set("", "<leader>j", "gqip") -- format current paragraph
vim.keymap.set("", "<leader>k", ":!ruff format %<CR>:e<CR>") -- format current Python file (after delay)
vim.keymap.set("", "<leader>kk", ":!ruff format %<CR>:e<CR>") -- format current Python file
vim.keymap.set("", "<leader>kj", ":!prettier -w %<CR>:e<CR>") -- format current JS file
vim.keymap.set("", "<leader>kl", ":!stylua %<CR>:e<CR>") -- format current Lua file
vim.keymap.set("", "<leader>l", ":set invnumber<CR>") -- toggle line number
vim.keymap.set("", "<leader>n", ":bn<CR>") -- next buffer
vim.keymap.set("", "<leader>N", ":bp<CR>") -- previous buffer
vim.keymap.set("", "<leader>p", ":set syntax=python<CR>") -- hack when Python syntax not recognized
vim.keymap.set("", "<leader>r", ":FzfLua live_grep<CR>")
vim.keymap.set("", "<leader>u", ":source ~/.config/nvim/init.lua<CR>") -- update the settings from init.lua
vim.keymap.set("", "<leader>w", ":wa!<CR>") -- write all buffers (force)
vim.keymap.set("", "<leader>y", ":Yazi<CR>") -- launch yazi plugin

-- text width for current wrap (leaves the command line open to type a width)
vim.keymap.set("", "<C-j>", ":set tw=")

vim.keymap.set("i", "<BS>", "<Left><C-O>x")
vim.keymap.set("", "<BS>", "<Left>x")

-- Diagnostics keybindings (moved from init.lua)
vim.keymap.set("n", "<leader>dv", "<cmd>lua vim.diagnostic.show()<cr>")
vim.keymap.set("n", "<leader>dh", "<cmd>lua vim.diagnostic.hide()<cr>")
vim.keymap.set("n", "<leader>dn", "<cmd>lua vim.diagnostic.jump({count = 1})<cr>")
vim.keymap.set("n", "<leader>dp", "<cmd>lua vim.diagnostic.jump({count = -1})<cr>")

-- Registers popup (:reg in a floating window)
vim.keymap.set("n", "<leader>c", function() require("utils").registers_popup() end)

-- A few math digraphs
vim.cmd("digraph in 8712") -- ∈
vim.cmd("digraph ni 8713") -- ∉
vim.cmd("digraph ^l 8968") -- ⌈
vim.cmd("digraph ^r 8969") -- ⌉
vim.cmd("digraph _l 8970") -- ⌊
vim.cmd("digraph _r 8971") -- ⌋

vim.cmd("set listchars=tab:\\ \\ ·,nbsp:¦,eol:↲,space:␣")
vim.cmd("set statusline=[%n:%Y]\\ %f%m%r%h%w%=(%v:0x%02.2B)\\ %l/%L")
