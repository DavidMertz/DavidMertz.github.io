require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "c", "cpp", "go", "haskell", "javascript", "julia", "lua", "markdown",
        "markdown_inline", "perl", "php", "python", "query", "rust", "sql",
        "typescript", "vim", "vimdoc"
    },
    auto_install = true,
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
})
