return {
  "karb94/neoscroll.nvim",
  enabled = true,
  event = "VeryLazy",
  opts = {
    hide_cursor = true,
    stop_eof = true,
    respect_scrolloff = false,
    cursor_scrolls_alone = true,
    duration_multiplier = 1.0,
    easing = "linear", -- [linear, quadratic, cubic, quartic, quintic, circular, sine]
    pre_hook = nil,
    post_hook = nil,
    performance_mode = false,
    ignored_events = {
      "WinScrolled",
      "CursorMoved",
    },
  },
  config = function()
    local neoscroll = require "neoscroll"
    neoscroll.setup()

    local keymap = {
      ["<C-Up>"] = function()
        neoscroll.scroll(-0.1, { move_cursor = true, duration = 100 })
      end,
      ["<C-Down>"] = function()
        neoscroll.scroll(0.1, { move_cursor = true, duration = 100 })
      end,
      ["<C-Left>"] = function()
        neoscroll.scroll(-0.5, { move_cursor = true, duration = 200 })
      end,
      ["<C-Right>"] = function()
        neoscroll.scroll(0.5, { move_cursor = true, duration = 200 })
      end,
    }

    local modes = { "n", "v", "x" }
    for key, func in pairs(keymap) do
      vim.keymap.set(modes, key, func)
    end
  end,
}
