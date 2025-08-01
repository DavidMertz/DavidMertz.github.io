require("nvim-web-devicons").setup({
	-- your personnal icons can go here (to override)
	-- you can specify color or cterm_color instead of specifying both of them
	-- DevIcon will be appended to `name`
	override = {
		zsh = {
			icon = "𝜁",
			color = "#428850",
			cterm_color = "65",
			name = "Zsh",
		},
	},
	-- globally enable different highlight colors per icon (default to true)
	-- if set to false all icons will have the default icon's color
	color_icons = false,
	-- globally enable default icons (default to false)
	-- will get overriden by `get_icons` option
	default = false,
	-- globally enable "strict" selection of icons - icon will be looked up in
	-- different tables, first by filename, and if not found by extension; this
	-- prevents cases when file doesn't have any extension but still gets some icon
	-- because its name happened to match some extension (default to false)
	strict = false,
	-- set the light or dark variant manually, instead of relying on `background`
	-- (default to nil)
	variant = "light|dark",
	-- same as `override` but specifically for overrides by filename
	-- takes effect when `strict` is true
	override_by_filename = {
		[".gitignore"] = {
			icon = "྾",
			color = "#f1502f",
			name = "Gitignore",
		},
	},
	-- same as `override` but specifically for overrides by extension
	-- takes effect when `strict` is true
	override_by_extension = {
        ["csv"] = {
            icon = "📈",
            name = "CSV",
        },
        ["db"] = {
            icon = "Σ",
            name = "Sqlite3",
        },
        ["html"] = {
            icon = "🕸",
            name = "HTML",
        },
        ["js"] = {
            icon = "☕",
            name = "JavaScript",
        },
		["json"] = {
			icon = "Ｊ",
			name = "JSON",
		},
        ["lock"] = {
            icon = "🔏",
            name = "Lock",
        },
		["log"] = {
			icon = "㏒",
			color = "#81e043",
			name = "Log",
		},
        ["lua"] = {
            icon = "𝓵",
            name = "Lua",
        },
		["md"] = {
			icon = "Ⓜ",
			name = "Markdown",
		},
		["py"] = {
			icon = "∿",
			name = "Python",
		},
		["sh"] = {
			icon = "⏵",
			name = "Shell",
		},
        ["sqlite"] = {
            icon = "Σ",
            name = "Sqlite3",
        },
		["toml"] = {
			icon = "🅃",
			color = "#428850",
			cterm_color = "65",
			name = "TOML",
		},
        ["text"] = {
            icon = "📝",
            name = "Text",
        },
        ["txt"] = {
            icon = "📝",
            name = "Text",
        },
        ["vim"] = {
            icon = "㏞",
            name = "Vim",
        },
		["yaml"] = {
			icon = "Ｙ",
			name = "YAML",
		},
		["yml"] = {
			icon = "Ｙ",
			name = "YAML",
		},
	},
	-- same as `override` but specifically for operating system
	-- takes effect when `strict` is true
	override_by_operating_system = {
		["apple"] = {
			icon = "🍎",
			color = "#A2AAAD",
			cterm_color = "248",
			name = "Apple",
		},
	},
})
