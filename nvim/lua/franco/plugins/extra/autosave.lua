return {
	"okuuva/auto-save.nvim",
	version = "^1.0.0", -- see https://devhints.io/semver
	cmd = "ASToggle",
	event = { "InsertLeave", "TextChanged" }, -- trigger events
  opts = {},
}
