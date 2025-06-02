return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  { import = "nvchad.blink.lazyspec" },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
      },
    },
  },

  {
    "nvzone/typr",
    dependencies = { "nvzone/volt" },
    opts = {},
    cmd = { "Typr", "TyprStats" },
  },

  {
    "nvzone/showkeys",
    lazy = false,
    cmd = "ShowKeysToggle",
    opts = {
      timeout = 1,
      maxkeys = 5,
    },
  },
}
