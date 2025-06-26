return {
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    event = "VeryLazy",
    cmd = {
      "GitConflictChooseOurs",
      "GitConflictChooseTheirs",
      "GitConflictChooseBoth",
      "GitConflictChooseNone",
      "GitConflictNextConflict",
      "GitConflictPrevConflict",
      "GitConflictListQf",
    },
    opts = {
      default_mappings = true,
      default_commands = true,
      disable_diagnostics = false,
      list_opener = "copen",
      highlights = { incoming = "DiffAdd", current = "DiffText" },
    },
    config = true,
  },
  { "lewis6991/gitsigns.nvim", opts = { current_line_blame = true } },
  { "tpope/vim-fugitive" },
}
