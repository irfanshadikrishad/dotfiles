return {
  "folke/todo-comments.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = function()
    -- Catppuccin Mocha palette for consistent theming
    local colors = {
      rosewater = "#f5e0dc",
      flamingo = "#f2cdcd",
      pink = "#f5c2e7",
      mauve = "#cba6f7",
      red = "#f38ba8",
      maroon = "#eba0ac",
      peach = "#fab387",
      yellow = "#f9e2af",
      green = "#a6e3a1",
      teal = "#94e2d5",
      sky = "#89dceb",
      sapphire = "#74c7ec",
      blue = "#89b4fa",
      lavender = "#b4befe",
      text = "#cdd6f4",
      overlay1 = "#7f849c",
    }

    return {
      signs = true,
      sign_priority = 10,

      -- GUI styling: transparent bg, bold text
      gui_style = {
        fg = "NONE",
        bg = "BOLD",
      },

      -- Merge with default keywords rather than full replacement
      keywords = {
        FIX = {
          icon = " ",
          color = "error",
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE", "DEBUG" },
        },
        TODO = {
          icon = " ",
          color = "info",
          alt = { "TASK", "PLAN" },
        },
        HACK = {
          icon = " ",
          color = "warning",
          alt = { "TEMP", "WORKAROUND", "BODGE" },
        },
        WARN = {
          icon = " ",
          color = "warning",
          alt = { "WARNING", "XXX", "DEPRECATED" },
        },
        PERF = {
          icon = " ",
          color = "hint",
          alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE", "SPEED" },
        },
        NOTE = {
          icon = " ",
          color = "hint",
          alt = { "INFO", "DOC", "DOCUMENT" },
        },
        TEST = {
          icon = " ",
          color = "test",
          alt = { "TESTING", "PASSED", "FAILED" },
        },
        DONE = {
          icon = " ",
          color = "default",
          alt = { "COMPLETE", "RESOLVED", "CLOSED" },
        },
        REVIEW = {
          icon = " ",
          color = "warning",
          alt = { "CHECK", "AUDIT", "VERIFY" },
        },
        QUESTION = {
          icon = " ",
          color = "info",
          alt = { "QUERY", "CONFIRM" },
        },
      },

      -- Custom color mapping using palette
      colors = {
        error = { "DiagnosticError", "ErrorMsg", colors.red },
        warning = { "DiagnosticWarn", "WarningMsg", colors.peach },
        info = { "DiagnosticInfo", colors.blue },
        hint = { "DiagnosticHint", colors.teal },
        default = { "Identifier", colors.lavender },
        test = { "Identifier", colors.green },
      },

      -- Search configuration
      search = {
        command = "rg",
        args = {
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
        },
        -- Ripgrep regex pattern matching all keywords
        pattern = [[\b(KEYWORDS):]],
      },

      -- Highlight configuration
      highlight = {
        multiline = true,
        multiline_pattern = "^.", -- Match any start of line
        multiline_context = 10, -- Lines of context
        before = "", -- No highlight before keyword
        keyword = "wide", -- Highlight entire keyword
        after = "fg", -- Use foreground color after
        pattern = [[.*<(KEYWORDS)\s*:]],
        comments_only = true, -- Only match in comments
        max_line_len = 400, -- Skip very long lines
        exclude = {}, -- Filetypes to exclude
      },
    }
  end,

  keys = {
    {
      "]t",
      function()
        require("todo-comments").jump_next()
      end,
      desc = "Next todo comment",
    },
    {
      "[t",
      function()
        require("todo-comments").jump_prev()
      end,
      desc = "Previous todo comment",
    },
    {
      "<leader>tt",
      "<cmd>TodoTrouble<cr>",
      desc = "Todo (Trouble)",
    },
    {
      "<leader>tT",
      "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>",
      desc = "Todo/Fix/Fixme (Trouble)",
    },
    {
      "<leader>st",
      "<cmd>TodoTelescope<cr>",
      desc = "Search Todos",
    },
    {
      "<leader>sT",
      "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>",
      desc = "Search Todo/Fix/Fixme",
    },
  },
}
