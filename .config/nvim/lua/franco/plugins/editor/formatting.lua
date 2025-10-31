return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },

  config = function()
    local conform = require("conform")

    -- Ensure Mason's bin directory is in PATH
    local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
    local current_path = vim.env.PATH or ""

    if not current_path:find(mason_bin, 1, true) then
      vim.env.PATH = mason_bin .. ":" .. current_path
    end

    conform.setup({
      formatters_by_ft = {
        c          = { "clang_format" },
        lua        = { "stylua" },
        java       = { "google-java-format" },
        json       = { "prettier" },
        python     = { "black" },
        haskell    = { "fourmolu" },
        markdown   = { "prettier" },
        postgresql = { "sqlfluff" },
      },
      format_on_save = false,
    })

    -- Manual Formatting
    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({
        lsp_fallback = true,
        timeout_ms   = 5000,
        async        = false,
      })
    end, { desc = "Format file or range" })

  end,
}
