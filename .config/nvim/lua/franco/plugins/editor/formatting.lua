return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				c          = { "clang_format" },
				lua        = { "stylua" },
				java       = { "google-java-format" },
				json       = { "prettier" },
				python     = { "black" },
        haskell    = { "fourmolu" },
				markdown   = { "prettier" },
				postgresql = { "sqlfluff" },
			},
			format_on_save = false,
		})

		-- Manual Formatting
		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				timeout_ms   = 5000,
				async        = false,
			})
		end, { desc = "Format file or range" })
	end,
}
