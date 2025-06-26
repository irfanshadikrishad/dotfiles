return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  config = function()
    local cmp = require "cmp"
    cmp.setup {
      sources = {
        name = "codeium",
      },
      mapping = cmp.mapping.preset.insert {
        ["<CR>"] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Insert,
          select = false, -- Don't confirm unless explicitly selected
        },
        ["<Tab>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
        ["<S-Tab>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
      },
    }
  end,
}
