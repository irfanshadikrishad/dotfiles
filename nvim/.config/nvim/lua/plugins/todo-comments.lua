return {
  "folke/todo-comments.nvim",
  event = "VeryLazy",
  opts = {
    signs = true,
    sign_priority = 10,
    gui_style = { fg = "NONE", bg = "BOLD" },
    keywords = {
      FIX = {
        icon = " ",
        color = "#dd7878",
        alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
      },
      TODO = { icon = " ", color = "#ea76cb" },
      HACK = { icon = " ", color = "#fab387" },
      WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
      PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
      NOTE = { icon = " ", color = "#ca9ee6", alt = { "INFO" } },
      TEST = { icon = " ", color = "#94e2d5", alt = { "TESTING", "PASSED", "FAILED" } },
      DONE = { icon = " ", color = "#89b4fa", alt = { "COMPLETE" } },
    },
    highlight = {
      multiline = true,
    },
  },
}
