require "nvchad.mappings"

local map = vim.keymap.set

-- Basic mappings
map("n", ";", ":", { desc = "CMD enter command mode" })
map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>", { desc = "Save file" })
map("i", "jk", "<ESC>")

-- Floaterm toggle
map("n", "<leader>ft", function()
  local ok, floaterm = pcall(require, "floaterm")
  if ok then
    floaterm.toggle()
  end
end, { noremap = true, silent = true, desc = "Toggle floaterm." })

-- Oil file manager
map("n", "<leader>-", ":Oil --float<CR>", { desc = "Opens Oil file manager in float mode." })

-- CodeSnap mappings
map("v", "<leader>0", ":CodeSnap<CR>", { desc = "Snaps the selected code to clipboard." })
map("v", "<leader>1", ":CodeSnapSave<CR>", { desc = "Snaps and saves the selected code." })

-- Timerly toggle
map("n", "<leader>tt", ":TimerlyToggle<CR>", { desc = "Toggle Timerly." })

-- Move lines up/down
-- Normal mode: Move current line up/down
map("n", "<M-Up>", ":m .-2<CR>==", { desc = "Move line up", silent = true })
map("n", "<M-Down>", ":m .+1<CR>==", { desc = "Move line down", silent = true })

-- Visual mode: Move selected block up/down
map("v", "<M-Up>", ":m '<-2<CR>gv=gv", { desc = "Move block up", silent = true })
map("v", "<M-Down>", ":m '>+1<CR>gv=gv", { desc = "Move block down", silent = true })
