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
        --  TODO: for todo
        TODO = { icon = " ", color = "#7287fd" },
        --  HACK: This is hack
        HACK = { icon = " ", color = "#fab387" },
        --  WARN: this is warn
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        --  PERF: for performance
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        --  NOTE: any notes?
        NOTE = { icon = " ", color = "#ca9ee6", alt = { "INFO" } },
        --  TEST: Testing codes here
        TEST = { icon = " ", color = "#94e2d5", alt = { "TESTING", "PASSED", "FAILED" } },
        --  DONE: complete
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
  {
    "nvzone/floaterm",
    dependencies = "nvzone/volt",
    opts = {},
    cmd = "FloatermToggle",
  },
  { "rafamadriz/friendly-snippets" },
  { "echasnovski/mini.nvim", version = "*" },
  {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = { default_file_explorer = false, view_options = { show_hidden = true }, float = { padding = 10 } },
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    lazy = false,
  },
  {
    "mistricky/codesnap.nvim",
    build = "make",
    cmd = { "CodeSnap" },
    opts = {
      save_path = "~/Pictures",
      has_breadcrumbs = true,
      bg_theme = "sea",
      show_workspace = false,
      breadcrumbs_separator = "/",
      has_line_number = true,
      watermark = "@irfanshadikrishad",
      mac_window_bar = false,
      title = "@irfanshadikrishad",
      code_font_family = "CaskaydiaCove Nerd Font",
      watermark_font_family = "Pacifico",
      bg_padding = 0,
    },
  },
}
