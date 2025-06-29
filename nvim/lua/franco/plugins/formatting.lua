return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			-- Configure formatters by file type
			formatters_by_ft = {
				c          = { "clang_format" },
				cpp        = { "clang_format" },
				css        = { "prettier" },
				lua        = { "stylua" },
				java       = { "google-java-format" },
				html       = { "prettier" },
				json       = { "prettier" },
				svelte     = { "prettier" },
        python     = { "black" },
				markdown   = { "prettier" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				postgresql = { "sqlfluff" },
			},
			format_on_save = false,
		})

		-- Keybinding to manually trigger formatting
		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				timeout_ms = 5000,
				async = false,
			})
		end, { desc = "Format file or range" })
	end,
}
