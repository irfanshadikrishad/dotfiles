require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "lua_ls", "jsonls", "denols", "marksman", "eslint-ls", "emmet_ls" }

vim.lsp.config.denols = { NO_COLOR = false }

vim.lsp.enable(servers)

-- read :h vim.lsp.con47fig for changing options of lsp servers
