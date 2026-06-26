local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok then
  capabilities = cmp_lsp.default_capabilities(capabilities)
end

local function on_attach(_, bufnr)
  local function map(keys, fn, desc)
    vim.keymap.set("n", keys, fn, { buffer = bufnr, desc = "LSP: " .. desc })
  end

  map("gd", vim.lsp.buf.definition, "Goto definition")
  map("gD", vim.lsp.buf.declaration, "Goto declaration")
  map("gi", vim.lsp.buf.implementation, "Goto implementation")
  map("gr", vim.lsp.buf.references, "References")
  map("K", vim.lsp.buf.hover, "Hover")
  map("<leader>ca", vim.lsp.buf.code_action, "Code action")
  map("<leader>rn", vim.lsp.buf.rename, "Rename")
  map("[d", function() vim.diagnostic.jump({ count = -1 }) end, "Prev diagnostic")
  map("]d", function() vim.diagnostic.jump({ count = 1 }) end, "Next diagnostic")
end

-- Servers configured with defaults.
local servers = {
  "html",
  "cssls",
  "gopls",
  "ruff",
  "dockerls",
  "terraformls",
  "ts_ls",
  "bashls",
  "ansiblels",
  "lua_ls",
}

for _, server in ipairs(servers) do
  vim.lsp.config(server, {
    on_attach = on_attach,
    capabilities = capabilities,
  })
  vim.lsp.enable(server)
end

-- yamlls with custom formatting settings.
vim.lsp.config("yamlls", {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    yaml = {
      format = {
        proseWrap = "preserve",
        printWidth = 9999,
      },
    },
  },
})
vim.lsp.enable("yamlls")
