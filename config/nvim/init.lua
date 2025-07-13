local vim = vim 
local Plug = vim.fn['plug#']

-- Load keymaps from convenient (and prior) vim format
vim.cmd('source /home/dmertz/.config/nvim/keymap.vim')

-- Load plugings using vim-plug
vim.cmd('source /home/dmertz/.config/nvim/plugins.vim')

-- We prepend it with 'silent!' to ignore errors when it's not yet installed.
vim.cmd('silent! colorscheme lucid-og')

-- Require the language server for Pyright
local pyright_opts = {
  single_file_support = false,
  settings = {
    pyright = {
      disableLanguageServices = true,
      -- Using Ruff's import organizer
      disableOrganizeImports = true
    },
    python = {
      analysis = {
        autoImportCompletions = true,
        autoSearchPaths = true,
        diagnosticMode = "workspace", -- openFilesOnly, workspace
        typeCheckingMode = "basic", -- off, basic, strict
        useLibraryCodeForTypes = true
      }
    }
  },
}
require('lspconfig').pyright.setup {
  settings = {
    pyright = pyright_opts
  }
}

-- Limit the messages from Pyright
function filter(arr, func)
	-- Filter in place
	-- https://stackoverflow.com/questions/49709998/how-to-filter-a-lua-array-inplace
	local new_index = 1
	local size_orig = #arr
	for old_index, v in ipairs(arr) do
		if func(v, old_index) then
			arr[new_index] = v
			new_index = new_index + 1
		end
	end
	for i = new_index, size_orig do arr[i] = nil end
end


function filter_diagnostics(diagnostic)
	-- Only filter out Pyright stuff for now
	if diagnostic.source ~= "Pyright" then
		return true
	end

    -- Special case for Pytests with *user_token args
    -- TODO: this is probably better all parameters to Pytests
	if string.match(diagnostic.message, '.*_token" is not accessed') then
		return false
	end

	-- Allow variables starting with an underscore
	if string.match(diagnostic.message, '"_.+" is not accessed') then
		return false
	end

	return true
end

function custom_on_publish_diagnostics(a, params, client_id, c, config)
	filter(params.diagnostics, filter_diagnostics)
	vim.lsp.diagnostic.on_publish_diagnostics(a, params, client_id, c, config)
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
	custom_on_publish_diagnostics, {})

-- Tabnine configuration
if os.getenv("NO_AI") == nil then
    require('tabnine').setup({
      disable_auto_comment=false,
      accept_keymap="<Tab>",
      dismiss_keymap = "<C-]>",
      debounce_ms = 800,
      suggestion_color = {gui = "#808080", cterm = 244},
      exclude_filetypes = {"TelescopePrompt", "NvimTree"},
      log_file_path = nil, -- absolute path to Tabnine log file
      ignore_certificate_errors = false,
    })
end

-- Treesitter configuration
require("nvim-treesitter.configs").setup({
  ensure_installed = { 
        "c", 
        "cpp", 
        "go",
        "haskell",
        "javascript", 
        "julia", 
        "lua",
        "markdown", 
        "markdown_inline", 
        "perl", 
        "php", 
        "python", 
        "query", 
        "rust", 
        "sql",
        "typescript", 
        "vim", 
        "vimdoc", 
  },
  auto_install = true,
  highlight = { enable = true, additional_vim_regex_highlighting = false },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-n>",
      node_incremental = "<C-n>",
      scope_incremental = "<C-s>"
    }
  }
})

-- Update some devicons
require'nvim-web-devicons'.setup {
 -- your personnal icons can go here (to override)
 -- you can specify color or cterm_color instead of specifying both of them
 -- DevIcon will be appended to `name`
 override = {
  zsh = {
    icon = "",
    color = "#428850",
    cterm_color = "65",
    name = "Zsh"
  }
 };
 -- globally enable different highlight colors per icon (default to true)
 -- if set to false all icons will have the default icon's color
 color_icons = true;
 -- globally enable default icons (default to false)
 -- will get overriden by `get_icons` option
 default = true;
 -- globally enable "strict" selection of icons - icon will be looked up in
 -- different tables, first by filename, and if not found by extension; this
 -- prevents cases when file doesn't have any extension but still gets some icon
 -- because its name happened to match some extension (default to false)
 strict = true;
 -- set the light or dark variant manually, instead of relying on `background`
 -- (default to nil)
 variant = "light|dark";
 -- same as `override` but specifically for overrides by filename
 -- takes effect when `strict` is true
 override_by_filename = {
  [".gitignore"] = {
    icon = "྾",
    color = "#f1502f",
    name = "Gitignore"
  }
 };
 -- same as `override` but specifically for overrides by extension
 -- takes effect when `strict` is true
 override_by_extension = {
  ["log"] = {
    icon = "",
    color = "#81e043",
    name = "Log"
  },
  ["toml"] = {
    icon = "",
    color = "#428850",
    cterm_color = "65",
    name = "TOML"
  }
 };
 -- same as `override` but specifically for operating system
 -- takes effect when `strict` is true
 override_by_operating_system = {
  ["apple"] = {
    icon = "",
    color = "#A2AAAD",
    cterm_color = "248",
    name = "Apple",
  },
 };
}

-- Share clipboard with system
vim.api.nvim_set_option("clipboard", "unnamed")
