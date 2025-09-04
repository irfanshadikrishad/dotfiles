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
    branch = "master",
    build = ":TSUpdate",
    opts = {
      highlight = { enabled = true },
      indent = { enabled = true },
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "jsdoc",
        "javascript",
        "typescript",
        "tsx",
      },
    },
  },
  { "nvzone/volt", lazy = true },
  { "rafamadriz/friendly-snippets" },
  { "echasnovski/mini.nvim", version = "*" },
}
