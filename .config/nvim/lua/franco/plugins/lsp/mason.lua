return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		-- import mason
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")

		-- enable mason and configure icons
		mason.setup({
			ui = {
				icons = {
					package_pending     = "󱑞",
					package_installed   = "✓",
					package_uninstalled = "󱂱",
				},
				border    = "rounded",
				title_pos = "center",
			},
		})

		-- LSP servers only
		mason_lspconfig.setup({
			automatic_setup = false,
			automatic_installation = true,
			ensure_installed = {
				"lua_ls", "clangd", "jdtls", "hls", "pyright", "dockerls",
			},
		})

		-- Formatters, linters, and other tools
		mason_tool_installer.setup({
			ensure_installed = {
				"stylua",
				"black", "pylint",
        "fourmolu", "hlint",
			},
		})
	end,

  keys = {
		{ "<leader>ma", ":Mason<CR>", desc = "Toggle Mason" },
	},

}
