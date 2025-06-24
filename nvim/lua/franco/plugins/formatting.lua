return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			-- Configure formatters by file type
			formatters_by_ft = {
				lua        = { "stylua" },
				c          = { "clang_format" },
				cpp        = { "clang_format" },
				java       = { "google-java-format" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				svelte     = { "prettier" },
				html       = { "prettier" },
				css        = { "prettier" },
				json       = { "prettier" },
				markdown   = { "prettier" },
				postgresql = { "sqlfluff" },
			},
			format_on_save = false,
		})

		-- Keybinding to manually trigger formatting
		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 5000,
			})
		end, { desc = "Format file or range" })
	end,
}
