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
					package_installed = "✓",
					package_pending = "󱑞",
					package_uninstalled = "󱂱",
				},
			},
		})

		-- LSP servers only
		mason_lspconfig.setup({
			automatic_setup = true,
			automatic_installation = true,
			ensure_installed = {
				"lua_ls",
				"clangd",
				"jdtls",
			},
		})

		-- Formatters, linters, and other tools
		mason_tool_installer.setup({
			ensure_installed = {
				-- Formatters
				"stylua",
			},
		})
	end,
}
