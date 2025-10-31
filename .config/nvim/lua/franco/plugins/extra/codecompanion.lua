return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-telescope/telescope.nvim",
		{ "stevearc/dressing.nvim", opts = {} },
	},
	opts = {
		adapters = {
			http = {
				ollama = function()
					return require("codecompanion.adapters").extend("ollama", {
						schema = {
							model = { default = "qwen2.5-coder:7b" },
							num_ctx = { default = 16384 },
							num_predict = { default = 2048 },
						},
					})
				end,
			},
		},
		strategies = {
			chat = { adapter = "ollama" },
			inline = { adapter = "ollama" },
		},
		display = {
			chat = {
				window = {
					layout = "float",
					width = 0.6,
				},
			},
		},
	},
	keys = {
		{ "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n" }, desc = "Toggle Chat" },
		{ "<leader>ic", "<cmd>CodeCompanion<cr>", mode = { "n" }, desc = "Inline Prompt" },
	},
}
