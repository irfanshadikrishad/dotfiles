return {
  "mistricky/codesnap.nvim",
  tag = "v2.0.5",
  cmd = {
    "CodeSnap",
    "CodeSnapSave",
    "CodeSnapHighlight",
    "CodeSnapSaveHighlight",
    "CodeSnapASCII",
  },
  config = function()
    require("codesnap").setup {
      show_line_number = true,
      show_workspace = false,
      bg_padding = 0,
      snapshot_config = {
        theme = "candy",
        background = "#00000000",
        window = {
          mac_window_bar = false,
          title_config = { font_family = "Pacifico" },
        },
        code_config = {
          font_family = "CaskaydiaCove Nerd Font",
          breadcrumbs = {
            enable = true,
            separator = "/",
            font_family = "CaskaydiaCove Nerd Font",
          },
        },
        watermark = {
          content = "",
          font_family = "Pacifico",
        },
      },
    }
  end,
}
