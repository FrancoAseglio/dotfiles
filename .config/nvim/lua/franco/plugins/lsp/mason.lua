return {
  -- lsp servers
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			ensure_installed = {
				"lua_ls", "clangd", "jdtls", "pyright", "dockerls",
				"ts_ls", "html", "cssls", "emmet_ls",
			},
		},
		dependencies = {
			{
				"williamboman/mason.nvim",
				opts = {
					ui = {
						border = "rounded",
						width  = 0.8,
						height = 0.8,
						icons = {
							package_pending     = "󱑞",
							package_installed   = "✓",
							package_uninstalled = "󱂱",
						},
					},
				},
				keys = {
					{ "<leader>ma", ":Mason<CR>", desc = "Toggle Mason" },
				},
			},
			"neovim/nvim-lspconfig",
		},
	},
  -- formatters
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = {
			ensure_installed = {
				"stylua", "black", "pylint", "fourmolu", "google-java-format",
				"prettier", "eslint_d", "clang-format",
			},
		},
		dependencies = {
			"williamboman/mason.nvim",
		},
	},
}
