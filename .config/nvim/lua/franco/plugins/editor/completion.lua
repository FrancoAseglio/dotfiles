return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",

	dependencies = {
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"saadparwaiz1/cmp_luasnip",
		{
			"L3MON4D3/LuaSnip",
			version = "v2.*",
			build = "make install_jsregexp",
			dependencies = { "rafamadriz/friendly-snippets" },
			config = function()
				require("luasnip.loaders.from_vscode").lazy_load()
			end,
		},
	},

	config = function()
		vim.o.completeopt = "menu,menuone,noselect"
		vim.o.pumheight = 10
		local cmp = require("cmp")

		cmp.setup({
			window = {
				---@diagnostic disable-next-line: assign-type-mismatch
				documentation = false,
			},

			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},

			mapping = cmp.mapping.preset.insert({
				["<Tab>"] = cmp.mapping.confirm({ select = false }),
			}),

			sources = {
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "buffer" },
				{ name = "path" },
			},
		})
	end,
}
