return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("configs.treesitter")
    end,
  },

  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- format on save
    opts = require("configs.conform"),
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require("configs.lspconfig")
    end,
  },

  -- Completion. Standalone setup (no distro base): sources + snippet engine are
  -- wired up here, and <CR> confirms the selection (behavior preserved from the
  -- original config: insert, no auto-select).
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
    },
    opts = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      return {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = false,
          }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
        }, {
          { name = "buffer" },
        }),
      }
    end,
    config = function(_, opts)
      require("cmp").setup(opts)
    end,
  },

  {
    "echasnovski/mini.diff",
    config = function()
      local diff = require("mini.diff")
      diff.setup({
        -- Disabled by default
        source = diff.gen_source.none(),
      })
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      git = {
        enable = false,
      },
      view = {
        side = "left",
        adaptive_size = true,
      },
    },
  },

  {
    "stevearc/aerial.nvim",
    cmd = { "AerialToggle", "AerialOpen", "AerialNavToggle" },
    keys = {
      { "<leader>o", "<cmd>AerialToggle<cr>", desc = "Toggle symbol outline" },
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      layout = { default_direction = "right" },
      filter_kind = false,
      show_guides = true,
    },
  },

  {
    "SmiteshP/nvim-navic",
    event = "LspAttach",
    opts = {
      highlight = true,
      lsp = { auto_attach = true },
      separator = "  ",
    },
    config = function(_, opts)
      require("nvim-navic").setup(opts)
      vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
    end,
  },

  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {},
    keys = {
      { "<leader>td", "<cmd>Trouble diagnostics toggle<cr>",         desc = "Diagnostics (Trouble)" },
      { "<leader>tr", "<cmd>Trouble lsp_references toggle<cr>",      desc = "LSP references (Trouble)" },
      { "<leader>ts", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Document symbols (Trouble)" },
      { "<leader>tq", "<cmd>Trouble qflist toggle<cr>",              desc = "Quickfix (Trouble)" },
    },
  },

  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>",        desc = "Diffview: open" },
      { "<leader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview: file history" },
      { "<leader>gc", "<cmd>DiffviewClose<cr>",       desc = "Diffview: close" },
    },
  },
}
