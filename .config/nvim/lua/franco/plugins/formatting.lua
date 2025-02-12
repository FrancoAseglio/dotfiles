return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				svelte = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				graphql = { "prettier" },
				liquid = { "prettier" },
				lua = { "stylua" },
				python = { "isort", "black" },
				java = { "google-java-format" },
				sql = { "pg_format" },
			},
			formatters = {
				pg_format = {
					command = "pg_format",
					args = { "postgresql" },
				},
			},
			--  Enable format on save properly
			format_on_save = {
				lsp_fallback = true, -- Ensure fallback to LSP if formatter fails
				async = false,
				timeout_ms = 5000,
			},
		})

		--  Add autocommand to ensure format on save works
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*",
			callback = function()
				conform.format({
					lsp_fallback = true,
					async = false,
					timeout_ms = 5000,
				})
			end,
		})

		--  Keybinding to manually trigger formatting
		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 5000,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
