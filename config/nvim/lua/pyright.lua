-- Require the language server fo, Pyright
local pyright_opts = {
	single_file_support = false,
	settings = {
		pyright = {
			disableLanguageServices = true,
			-- Using Ruff's import organizer
			disableOrganizeImports = true,
		},
		python = {
			analysis = {
				autoImportCompletions = true,
				autoSearchPaths = true,
				diagnosticMode = "workspace", -- openFilesOnly, workspace
				typeCheckingMode = "basic", -- off, basic, strict
				useLibraryCodeForTypes = true,
			},
		},
	},
}
require("lspconfig").pyright.setup({
	settings = {
		pyright = pyright_opts,
	},
})

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
	for i = new_index, size_orig do
		arr[i] = nil
	end
end

-- Filter out Pyright diagnostics that we don't want to see
-- TODO: more specific filtering based on the diagnostic message and severity
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

-- LSP configuration
function custom_on_publish_diagnostics(a, params, client_id, c, config)
	filter(params.diagnostics, filter_diagnostics)
	vim.lsp.diagnostic.on_publish_diagnostics(a, params, client_id, c, config)
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(custom_on_publish_diagnostics, {})
