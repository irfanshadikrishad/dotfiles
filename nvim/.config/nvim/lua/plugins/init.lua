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
    { "nvzone/volt", lazy = true },
    {
      "nvzone/minty",
      cmd = { "Shades", "Huefy" },
    },
  },
  {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    opts = {
      signs = true,
      sign_priority = 10,
      gui_style = { fg = "NONE", bg = "BOLD" },
      keywords = {
        FIX = { -- BUG: for bugs or issues
          icon = " ",
          color = "#f38ba8",
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
        },
        -- TODO: for todo
        TODO = { icon = " ", color = "#a6e3a1" },
        -- HACK: This is hack
        HACK = { icon = " ", color = "#fab387" },
        -- WARN: this is warn
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        -- PERF: for performance
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        -- NOTE: any notes?
        NOTE = { icon = " ", color = "#ca9ee6", alt = { "INFO" } },
        -- TEST: Testing codes here
        TEST = { icon = " ", color = "#94e2d5", alt = { "TESTING", "PASSED", "FAILED" } },
        -- DONE: complete
        DONE = { icon = " ", color = "#89b4fa", alt = { "COMPLETE" } },
      },
      highlight = {
        multiline = true,
      },
    },
  },
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {},
    config = function(_, opts)
      require("go").setup(opts)
      local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
          require("go.format").goimports()
        end,
        group = format_sync_grp,
      })
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()',
  },
  {
    "nvzone/showkeys",
    cmd = "ShowKeysToggle",
    opts = { winopts = {
      border = "none",
    }, timeout = 5, maxkeys = 3 },
  },
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    config = true,
  },
  { "lewis6991/gitsigns.nvim", opts = { current_line_blame = true } },
  { "tpope/vim-fugitive" },
  {
    "roobert/search-replace.nvim",
    config = function()
      require("search-replace").setup {
        default_replace_single_buffer_options = "gcI",
        default_replace_multi_buffer_options = "egcI",
      }
    end,
  },
}
