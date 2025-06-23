local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    json = { "prettier" },
    jsonc = { "prettier" },
    markdown = { "prettier" },
    toml = { "prettier" },
    scss = { "prettier" },
    less = { "prettier" },
    graphql = { "prettier" },
    go = { "goimports", "gofmt" },
    python = { "black" },
    rust = { "rustfmt" },
    yaml = { "yamlfix", "yamlfmt" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
