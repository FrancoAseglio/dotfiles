return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
	},
	config = function()
		-- Local variables for brevity
		local lspconfig = require("lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local keymap = vim.keymap
		local capabilities = cmp_nvim_lsp.default_capabilities()
		local runtime_path = vim.split(package.path, ";")
		table.insert(runtime_path, "lua/?.lua")
		table.insert(runtime_path, "lua/?/init.lua")

		-- Configure diagnostics
		vim.diagnostic.config({
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.WARN]  = "",
					[vim.diagnostic.severity.HINT]  = "󰠠",
					[vim.diagnostic.severity.INFO]  = "",
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
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      callback = function()
		    vim.diagnostic.open_float(nil, { focus = false, border = "rounded" })
	    end,
    })

		-- Keymaps setup function to reduce repetition
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
			local config  = vim.fn.stdpath("config")
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
						workspace  = { checkThirdParty = false, library = vim.api.nvim_get_runtime_file("", true) },
						completion = { callSnippet = "Replace" },
					},
				},
				root_dir = nvim_config_root_dir,
			},
      pyright = {
		    settings = {
			    python = {
				    analysis = {
					    typeCheckingMode = "basic", -- "off", "basic", "strict"
					    autoSearchPaths = true,
					    useLibraryCodeForTypes = true,
				    },
			    },
		    },
	    },
			jdtls = { cmd = { "jdtls" } },
			clangd = {},
		}

		-- Setup all servers
		for server, config in pairs(servers) do
			config.capabilities = capabilities
			lspconfig[server].setup(config)
		end
	end,
}
