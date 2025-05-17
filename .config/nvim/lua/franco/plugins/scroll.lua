return {
	"karb94/neoscroll.nvim",
	config = function()
		require("neoscroll").setup({
			-- You can add options here if needed
			--
			-- <C-u> Scroll half a page up
			-- <C-d> Scroll half a page down
			--
			-- <C-b> Scroll full page up
			-- <C-f> Scroll full page down
			--
			-- zt    Scroll current line to top of window
			-- zz    Scroll current line to center of window
			-- zb    Scroll current line to bottom of window
		})
	end,
}
