local o = vim.o

o.number = true
o.signcolumn = "yes"
o.termguicolors = true
o.mouse = "a"
o.clipboard = "unnamedplus"

-- Indentation: 2-space soft tabs.
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.smartindent = true

-- Searching.
o.ignorecase = true
o.smartcase = true

-- Splits & persistence.
o.splitright = true
o.splitbelow = true
o.undofile = true
o.updatetime = 250
