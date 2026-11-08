return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = require "configs.conform",
  },
  {
    "neovim/nvim-lspconfig",
    -- loaded together with lspconfig, so require("schemastore") works inside configs.lspconfig
    dependencies = { "b0o/SchemaStore.nvim" },
    -- init runs at startup, so the command exists even before the first file is opened
    init = function()
      vim.api.nvim_create_user_command("ToolsInstall", function()
        local ok, tools = pcall(require, "configs.tools")
        if not ok or type(tools) ~= "table" or #tools == 0 then
          vim.notify("configs.tools is missing or empty", vim.log.levels.ERROR)
          return
        end

        local ran, err = pcall(function()
          vim.cmd { cmd = "MasonInstall", args = tools }
        end)
        if not ran then
          vim.notify("MasonInstall failed: " .. tostring(err), vim.log.levels.ERROR)
        end
      end, { desc = "Install LSP servers and formatters via Mason" })
    end,
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
        "markdown",
        "markdown_inline",
        "bash",
        "yaml",
        "json",
        "jsonc",
        "xml",
      },
    },
  },
  { "nvzone/volt", lazy = true },
  { "rafamadriz/friendly-snippets" },
  { "echasnovski/mini.nvim", version = "*" },
}
