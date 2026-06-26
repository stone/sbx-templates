local parsers = {
  "bash",
  "go",
  "lua",
  "luadoc",
  "markdown",
  "markdown_inline",
  "printf",
  "python",
  "terraform",
  "toml",
  "vim",
  "vimdoc",
  "yaml",
}

require("nvim-treesitter").install(parsers)

vim.api.nvim_create_autocmd("FileType", {
  pattern = parsers,
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
