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
			show_end = false,
			show_start = false,
			include = {
				node_type = {
					["*"] = {
						"if_statement",
						"for_statement",
						"try_statement",
						"with_statement",
						"while_statement",
						"match_statement",
						"class_definition",
						"method_definition",
						"function_definition",
					},
				},
			},
		},
		exclude = {
			filetypes = {
				"qf",
				"man",
				"help",
				"lspinfo",
				"checkhealth",
				"TelescopePrompt",
				"TelescopeResults",
			},
			buftypes = {
				"nofile",
				"prompt",
				"terminal",
			},
		},
	},
}
