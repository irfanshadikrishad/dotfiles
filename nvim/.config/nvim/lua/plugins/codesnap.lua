return {
  "mistricky/codesnap.nvim",
  build = "make",
  cmd = { "CodeSnap", "CodeSnapSave", "CodeSnapHighlight", "CodeSnapHighlightSave", "CodeSnapASCII" },
  opts = {
    save_path = "~/Pictures/CodeSnap/",
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
}
