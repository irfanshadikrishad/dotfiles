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
    cmd = "ShowKeysToggle",
    opts = {},
    {
      "monkoose/neocodeium",
      event = "VeryLazy",
      config = function()
        local neocodeium = require "neocodeium"
        neocodeium.setup()
        vim.keymap.set("i", "<A-f>", neocodeium.accept)
      end,
    },
    { "nvzone/volt", lazy = true },
    {
      "nvzone/minty",
      cmd = { "Shades", "Huefy" },
    },
  },
}
