-- Single source of truth for everything Mason should install.
-- Add a package name here and run :ToolsInstall. No other file needs to change.
return {
  -- LSP servers
  "typescript-language-server", -- ts_ls (JS, TS, JSX, TSX)
  "eslint-lsp",
  "html-lsp",
  "css-lsp",
  "emmet-language-server",
  "bash-language-server",
  "yaml-language-server",
  "json-lsp",
  "lemminx", -- XML,
  "marksman",

  -- Formatters / linters
  "stylua",
  "prettier",
  "shfmt",
  "shellcheck", -- bashls picks this up automatically for diagnostics
  "yamlfmt", -- already referenced in your conform yaml config
  "yamlfix", -- already referenced in your conform yaml config
}
