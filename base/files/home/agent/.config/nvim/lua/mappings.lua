local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- CTRL + Arrow keys to move between splits.
map("n", "<C-Right>", "<cmd>wincmd l<CR>", { desc = "Window right" })
map("n", "<C-Left>", "<cmd>wincmd h<CR>", { desc = "Window left" })
map("n", "<C-Up>", "<cmd>wincmd k<CR>", { desc = "Window up" })
map("n", "<C-Down>", "<cmd>wincmd j<CR>", { desc = "Window down" })

-- File tree.
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file tree" })

-- Toggle diagnostics.
map("n", "<leader>de", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle diagnostics" })

-- Tab navigation.
map("n", "<Tab>", vim.cmd.tabnext, { desc = "Next tab" })
map("n", "<S-Tab>", vim.cmd.tabprevious, { desc = "Previous tab" })

map("n", "<Del>", function()
  if vim.fn.tabpagenr("$") == 1 then
    return -- only one tab open
  end
  if vim.bo.modified then
    return -- unsaved changes
  end
  vim.cmd.tabclose()
end, { desc = "Close tab if no changes and more than one tab is open" })
