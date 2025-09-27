require("nvchad.configs.lspconfig").defaults()

local servers = {
  "html",
  "cssls",
  "lua_ls",
  "jsonls",
  "marksman",
  "eslint-ls",
  "emmet_ls",
  "bashls",
  "jedi_language_server",
  "tailwindcss",
  "ts_ls",
  "yamlls",
  "dockerls",
  "nginx_language_server",
}

vim.lsp.config.bashls = {
  { "bash", "sh" },
}
vim.lsp.config.ts_ls = {
  filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact", "javascript.jsx" },
  settings = {
    implicitProjectConfiguration = {
      checkJs = true,
    },
  },
}
vim.lsp.config.dockerls = {
  settings = {
    docker = {
      languageserver = {
        formatter = {
          ignoreMultilineInstructions = false,
        },
      },
    },
  },
}

vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
