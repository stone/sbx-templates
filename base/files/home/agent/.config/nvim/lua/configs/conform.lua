-- Options passed to conform.nvim.
return {
  formatters_by_ft = {
    lua = { "stylua" },
  },

  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
}
