return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{ "antosha417/nvim-lsp-file-operations", config = true },
	},
	config = function()
		local lspconfig = require("lspconfig")
		local keymap = vim.keymap

		-- Get capabilities from blink.cmp if available, otherwise default
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		local has_blink, blink = pcall(require, "blink.cmp")
		if has_blink then
			capabilities = blink.get_lsp_capabilities(capabilities)
		end

		local runtime_path = vim.split(package.path, ";")
		table.insert(runtime_path, "lua/?.lua")
		table.insert(runtime_path, "lua/?/init.lua")

		-- Configure diagnostics
		vim.diagnostic.config({
			virtual_text = true,
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.WARN]  = "",
					[vim.diagnostic.severity.HINT]  = "󰠠",
					[vim.diagnostic.severity.INFO]  = "",
				},
			},
		})

		-- Keymaps
		local function setup_lsp_keymaps(bufnr)
			local maps = {
				["<leader>ca"] = { vim.lsp.buf.code_action, "See code actions", { "n", "v" } },
				["<leader>gd"] = { vim.lsp.buf.definition, "Show LSP definitions" },
				["<leader>rn"] = { vim.lsp.buf.rename, "Smart rename" },
				["<leader>rs"] = { ":LspRestart<CR>", "Restart LSP" },
				["<leader>sd"] = {
					function()
						vim.lsp.buf.hover({ border = "rounded" })
					end,
					"Show under cursor documentation ",
				},
				["<leader>ld"] = {
					function()
						vim.diagnostic.open_float(nil, { focus = false, border = "rounded" })
					end,
					"Show all diagnostics for line",
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
			local config = vim.fn.stdpath("config")
			local wezterm = vim.fn.expand("~/.config/wezterm")

			if fname:find(config, 1, true) then
				return config
			elseif fname:find(wezterm, 1, true) then
				return wezterm
			end

			return vim.fs.dirname(vim.fs.find(".git", { path = fname, upward = true })[1]) or vim.fs.dirname(fname)
		end

		-- Global LSP settings
		local servers = {
			lua_ls = {
				settings = {
					Lua = {
						runtime = { version = "LuaJIT", path = runtime_path },
						diagnostics = {
							enable = false, -- turn off LSP diagnostics
						},
						workspace = { checkThirdParty = false, library = vim.api.nvim_get_runtime_file("", true) },
						completion = { callSnippet = "Replace" },
					},
				},
				root_dir = nvim_config_root_dir,
			},
		}

		-- Setup all servers
		for server, config in pairs(servers) do
			config.capabilities = capabilities
			lspconfig[server].setup(config)
		end
	end,
}
