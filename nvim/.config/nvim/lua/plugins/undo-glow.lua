return {
  "y3owk1n/undo-glow.nvim",
  event = "VeryLazy",
  version = "*",
  enabled = false,
  opts = {
    animation = {
      enabled = true,
      duration = 300,
      animtion_type = "zoom",
      window_scoped = true,
    },
    highlights = {
      undo = {
        hl_color = { bg = "#693232" },
      },
      redo = {
        hl_color = { bg = "#2F4640" },
      },
      yank = {
        hl_color = { bg = "#7A683A" },
      },
      paste = {
        hl_color = { bg = "#325B5B" },
      },
      search = {
        hl_color = { bg = "#5C475C" },
      },
      comment = {
        hl_color = { bg = "#7A5A3D" },
      },
      cursor = {
        hl_color = { bg = "#793D54" },
      },
    },
  },
}
