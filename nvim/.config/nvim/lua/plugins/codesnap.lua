return {
  "mistricky/codesnap.nvim",
  tag = "v2.1.1",
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
      show_workspace = true,
      save_path = "~/Pictures/CodeSnap",
      snapshot_config = {
        theme = "candy",
        background = "#00000000",
        window = {
          margin = { x = 0, y = 0 },
          border = { width = 0 },
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
          content = "@irfanshadikrishad",
          font_family = "CaskaydiaCove Nerd Font",
        },
      },
    }
  end,
}
