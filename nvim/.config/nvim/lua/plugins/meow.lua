return {
  dir = "/home/irfanshadikrishad/workshop/meow.nvim",
  name = "meow",
  lazy = false,
  enabled = false,
  priority = 1000,
  config = function()
    require("meow").setup()
    vim.cmd.colorscheme "meow"
  end,
}
