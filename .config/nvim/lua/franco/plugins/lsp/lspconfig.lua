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

		-- Helper function to find Poetry virtual environment
		local function get_poetry_venv_path(fname)
			local poetry_lock = vim.fs.find("pyproject.toml", { path = fname, upward = true })[1]
			if poetry_lock then
				local project_root = vim.fs.dirname(poetry_lock)
				local handle = io.popen("cd " .. project_root .. " && poetry env info --path 2>/dev/null")
				if handle then
					local venv_path = handle:read("*a"):gsub("%s+", "")
					handle:close()
					if venv_path and venv_path ~= "" then
						return venv_path .. "/bin/python"
					end
				end
			end
			return nil
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
			pyright = {
				settings = {
					python = {
						analysis = {
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
							diagnosticMode = "workspace",
						},
					},
				},
				root_dir = function(fname)
					-- Look for Poetry project first
					local poetry_root = vim.fs.dirname(vim.fs.find("pyproject.toml", { path = fname, upward = true })[1])
					if poetry_root then
						return poetry_root
					end
					-- Fallback to standard root patterns
					return lspconfig.util.root_pattern("setup.py", "setup.cfg", "pyproject.toml", "requirements.txt", ".git")(fname)
				end,
				before_init = function(_, config)
					-- Try to get Poetry virtual environment python path
					local poetry_python = get_poetry_venv_path(config.root_dir)
					if poetry_python then
						config.settings.python.pythonPath = poetry_python
					end
				end,
			},
		}

		-- Setup all servers
		for server, config in pairs(servers) do
			config.capabilities = capabilities
			lspconfig[server].setup(config)
		end
	end,
}
