return {
  "utilyre/barbecue.nvim",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "SmiteshP/nvim-navic",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("barbecue").setup {
      create_autocmd = false,
    }

    vim.api.nvim_create_autocmd({
      "WinResized",
      "BufWinEnter",
      "CursorHold",
      "InsertLeave",
    }, {
      group = vim.api.nvim_create_augroup("barbecue.updater", {}),
      callback = function()
        require("barbecue.ui").update()
      end,
    })
  end,
}
