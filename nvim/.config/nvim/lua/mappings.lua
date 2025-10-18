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
-- Normal mode: Move current line up/down (M is Alt)
map("n", "<M-Up>", ":m .-2<CR>==", { desc = "Move line up", silent = true })
map("n", "<M-Down>", ":m .+1<CR>==", { desc = "Move line down", silent = true })

-- Visual mode: Move selected block up/down
map("v", "<M-Up>", ":m '<-2<CR>gv=gv", { desc = "Move block up", silent = true })
map("v", "<M-Down>", ":m '>+1<CR>gv=gv", { desc = "Move block down", silent = true })

-- Open File Buffer Switching
map({ "n", "v" }, "N", ":bnext<CR>")
map({ "n", "v" }, "P", ":bprevious<CR>")

-- Treewalker (movement)
-- map({ "n", "v" }, "<C-k>", "<cmd>Treewalker Up<cr>", { silent = true })
-- map({ "n", "v" }, "<C-j>", "<cmd>Treewalker Down<cr>", { silent = true })
-- map({ "n", "v" }, "<C-h>", "<cmd>Treewalker Left<cr>", { silent = true })
-- map({ "n", "v" }, "<C-l>", "<cmd>Treewalker Right<cr>", { silent = true })
-- Treewalker (swapping)
-- map("n", "<C-S-k>", "<cmd>Treewalker SwapUp<cr>", { silent = true })
-- map("n", "<C-S-j>", "<cmd>Treewalker SwapDown<cr>", { silent = true })
map("n", "<M-Left>", "<cmd>Treewalker SwapLeft<cr>", { silent = true })
map("n", "<M-Right>", "<cmd>Treewalker SwapRight<cr>", { silent = true })

-- Quickfix
map("n", "<leader>qo", ":copen<CR>", { desc = "Open quickfix list" })
map("n", "<leader>qc", ":cclose<CR>", { desc = "Close quickfix list" })
