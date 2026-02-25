return {
  "github/copilot.vim",
  lazy = false,
  event = "InsertEnter",
  config = function()
    vim.g.copilot_no_tab_map = true

    local map = vim.keymap.set

    map("i", "<M-]>", "<Plug>(copilot-next)")
    map("i", "<M-[>", "<Plug>(copilot-previous)")

    map("i", "<M-l>", 'copilot#Accept("<CR>")', {
      expr = true,
      replace_keycodes = false,
    })
  end,
}
