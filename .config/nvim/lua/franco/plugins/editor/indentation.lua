return {
	"lukas-reineke/indent-blankline.nvim",
	event = { "BufReadPre", "BufNewFile" },
	main = "ibl",
	opts = {
		indent = {
			char = "┊",
		},
		scope = {
			char = "┊",
			enabled = true,
			show_start = false,
			show_end = false,

			include = {
				node_type = {
					["*"] = {
						-- Control flow
						"if_statement",
						"for_statement",
						"while_statement",
						"try_statement",
						"with_statement",
						"match_statement",

						-- Definitions
						"class_definition",
						"function_definition",
						"method_definition",

						-- Additional useful scopes
						"arguments",
						"parameters",
						"table_constructor",
						"dictionary",
						"object",
					},
				},
			},
		},

		whitespace = {
			remove_blankline_trail = true,
		},

		exclude = {
			filetypes = {
				-- Help and documentation
				"help",
				"man",

				-- Plugin interfaces
				"lazy",
				"mason",
				"lspinfo",
				"checkhealth",

				-- Telescope
				"TelescopePrompt",
				"TelescopeResults",

				-- Dashboard/startup screens
				"dashboard",
				"alpha",
				"starter",

				-- Other special buffers
				"notify",
			},
			buftypes = {
				"nofile",
				"prompt",
				"terminal",
				"quickfix",
			},
		},
	},
}
