return {
	"lukas-reineke/indent-blankline.nvim",
	event = { "BufReadPre", "BufNewFile" },
	main = "ibl",
	opts = {
		indent = {
			char = "┊",
		},

		scope = {
			enabled = true,
			char = "┊",
			show_start = false,
			show_end = false,
			include = {
				node_type = {
					["*"] = {
						-- Control structures
						"if_statement",
						"for_statement",
						"while_statement",
						"try_statement",
						"with_statement",
						"match_statement",
						-- Functions and classes
						"class_definition",
						"function_definition",
						"method_definition",
					},
				},
			},
		},

		exclude = {
			filetypes = {
				"help",
				"man",
				"lspinfo",
				"checkhealth",
				"TelescopePrompt",
				"TelescopeResults",
				"qf",
			},
			buftypes = {
				"terminal",
				"nofile",
				"prompt",
			},
		},
	},
}
