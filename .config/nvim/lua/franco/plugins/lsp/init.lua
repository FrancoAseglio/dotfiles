local buf      = vim.lsp.buf
local keymap   = vim.keymap
local severity = vim.diagnostic.severity
vim.o.updatetime = 250

local function setup_lsp_keymaps(bufnr)
	local maps = {
		{ "<leader>rs", ":LspRestart<CR>", "Restart LSP" },
		{ "<leader>rn", buf.rename, "Smart rename" },
		{ "<leader>ca", buf.code_action, "See code actions", { "n", "v" } },
		{ "<leader>gd", buf.definition, "Go to definition" },
		{ "<leader>sd", function() buf.hover({ border = "rounded" }) end, "Show documentation", },
	}
	for _, map in ipairs(maps) do
		keymap.set(map[4] or "n", map[1], map[2], { buffer = bufnr, desc = map[3] })
	end
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		setup_lsp_keymaps(ev.buf)

		if vim.b[ev.buf].lsp_diagnostics_autocmd then
			return
		end
		vim.b[ev.buf].lsp_diagnostics_autocmd = true

		vim.api.nvim_create_autocmd({ "CursorHold" }, {
			buffer = ev.buf,
			callback = function()
				if vim.fn.pumvisible() == 1 then
					return
				end

				local cmp_ok, cmp = pcall(require, "cmp")
				if cmp_ok and cmp.visible() then
					return
				end

				local linenr = vim.api.nvim_win_get_cursor(0)[1] - 1
				local diags = vim.diagnostic.get(ev.buf, { lnum = linenr })

				if #diags > 0 then
					vim.diagnostic.open_float(nil, { focus = false, border = "rounded" })
				end
			end,
		})
	end,
})

vim.diagnostic.config({
	virtual_text = {
		prefix = "●",
		spacing = 2,
		format = function() return "" end, -- clears text, displays number only
	},
	signs = {
		text = {
			[severity.ERROR] = "󰅚",
			[severity.WARN]  = "󰀪",
			[severity.HINT]  = "󰌶",
			[severity.INFO]  = "󰋽",
		},
	},
	update_in_insert = false,
	severity_sort = true,
})

return {}
