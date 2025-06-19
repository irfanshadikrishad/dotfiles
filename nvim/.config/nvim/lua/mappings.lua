require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "<leader>ft", function()
  local ok, floaterm = pcall(require, "floaterm")
  if ok then
    floaterm.toggle()
  end
end, { noremap = true, silent = true, desc = "Toggle floaterm." })
map("n", "<leader>-", ":Oil --float<CR>", { desc = "Opens Oil file manager in float mode." })
map("v", "<leader>0", ":CodeSnap<CR>", { desc = "Snaps the selected code." })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
