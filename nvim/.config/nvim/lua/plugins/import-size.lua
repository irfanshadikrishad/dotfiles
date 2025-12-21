return {
  "stuckinsnow/import-size.nvim",
  event = "VeryLazy",
  config = function()
    require("import-size").setup()
  end,
}
