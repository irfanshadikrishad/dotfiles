-- init.lua

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins
require("lazy").setup({
	-- Example plugin
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 }, -- Catppuccin theme
	{ "tpope/vim-commentary" }, -- Enables gcc/gbc for commenting
	{ "preservim/nerdtree" }, -- Tree explorer
	{ "windwp/nvim-autopairs", event = "InsertEnter", opts = {} }, -- Auto Pairs
	{
		"stevearc/conform.nvim",
		opts = {
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true, -- Use LSP if no formatter is set
			},
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				python = { "black" },
				sh = { "shfmt" },
				json = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
			},
		},
	},
	{
		"echasnovski/mini.icons",
		version = false,
		config = function()
			require("mini.icons").setup()
		end,
	},
})

-- Set colorscheme
vim.cmd.colorscheme("catppuccin")

-- Line Numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Tabs & Indentations
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Appearance
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"

-- Other
vim.opt.clipboard = "unnamedplus"
vim.opt.cursorline = true
vim.opt.paste = true

-- Keybindings
vim.keymap.set("n", "<leader>n", ":NERDTreeToggle<CR>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<leader>f", function()
	require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format file" })
vim.keymap.set("n", "<F2>", function()
	vim.opt.paste = not vim.opt.paste:get()
	print("paste mode: " .. tostring(vim.opt.paste:get()))
end, { desc = "Toggle paste mode" })
