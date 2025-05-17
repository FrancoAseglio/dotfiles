return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
	},
	config = function()
		-- Local variables for brevity
		local lspconfig, cmp_nvim_lsp, keymap, util =
			require("lspconfig"), require("cmp_nvim_lsp"), vim.keymap, require("lspconfig.util")
		local capabilities = cmp_nvim_lsp.default_capabilities()
		local runtime_path = vim.split(package.path, ";")
		table.insert(runtime_path, "lua/?.lua")
		table.insert(runtime_path, "lua/?/init.lua")

		-- Configure diagnostics
		vim.diagnostic.config({
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.WARN] = "",
					[vim.diagnostic.severity.HINT] = "󰠠",
					[vim.diagnostic.severity.INFO] = "",
				},
			},
			float = {
				border = "rounded",
				format = function(d)
					return string.format("%s (%s)", d.message, d.source)
				end,
			},
		})

		-- Show diagnostics on hover
		vim.o.updatetime = 1500
		vim.cmd(
			[[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, { focus = false, border = "rounded" })]]
		)

		-- Keymaps setup function to reduce repetition
		local function setup_lsp_keymaps(bufnr)
			local maps = {
				["gR"] = { "<cmd>Telescope lsp_references<CR>", "Show LSP references" },
				["gD"] = { vim.lsp.buf.declaration, "Go to declaration" },
				["gd"] = { "<cmd>Telescope lsp_definitions<CR>", "Show LSP definitions" },
				["gi"] = { "<cmd>Telescope lsp_implementations<CR>", "Show LSP implementations" },
				["gt"] = { "<cmd>Telescope lsp_type_definitions<CR>", "Show LSP type definitions" },
				["<leader>ca"] = { vim.lsp.buf.code_action, "See code actions", { "n", "v" } },
				["<leader>rn"] = { vim.lsp.buf.rename, "Smart rename" },
				["<leader>D"] = { "<cmd>Telescope diagnostics bufnr=0<CR>", "Show buffer diagnostics" },
				["<leader>d"] = { vim.diagnostic.open_float, "Show line diagnostics" },
				["<leader>rs"] = { ":LspRestart<CR>", "Restart LSP" },
				["K"] = {
					function()
						vim.lsp.buf.hover({ border = "rounded" })
					end,
					"Show documentation for what is under cursor",
				},
			}

			for k, v in pairs(maps) do
				keymap.set(v[3] or "n", k, v[1], { buffer = bufnr, desc = v[2] })
			end
		end

		-- LSP Attach autocommand
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				setup_lsp_keymaps(ev.buf)
			end,
		})

		-- Common root_dir function for configs
		local function nvim_config_root_dir(fname)
			return fname:find(vim.fn.stdpath("config"), 1, true) and vim.fn.stdpath("config")
				or util.find_git_ancestor(fname)
				or util.path.dirname(fname)
		end

		-- Global LSP settings
		local servers = {
			svelte = {
				on_attach = function(client, _)
					vim.api.nvim_create_autocmd("BufWritePost", {
						pattern = { "*.js", "*.ts" },
						callback = function(ctx)
							client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
						end,
					})
				end,
			},
			graphql = { filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" } },
			emmet_ls = {
				filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
			},
			lua_ls = {
				settings = {
					Lua = {
						runtime = { version = "LuaJIT", path = runtime_path },
						diagnostics = {
							globals = { "vim", "require", "pairs", "ipairs", "print", "table", "string", "math", "os" },
						},
						workspace = { checkThirdParty = false, library = vim.api.nvim_get_runtime_file("", true) },
						completion = { callSnippet = "Replace" },
					},
				},
				root_dir = nvim_config_root_dir,
			},
			sqlls = {
				on_attach = function(client, bufnr)
					vim.diagnostic.enable(bufnr)
					client.server_capabilities.documentFormattingProvider = true
				end,
				settings = { sqlls = { lint = { enable = true }, diagnostics = { enable = true } } },
			},
			clangd = {},
			jdtls = { cmd = { "jdtls" } },
		}

		-- Setup all servers
		for server, config in pairs(servers) do
			config.capabilities = capabilities
			lspconfig[server].setup(config)
		end
	end,
}
