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
    python = { "black" },
    rust = { "rustfmt" },
    yaml = { "yamlfix", "yamlfmt" },
    sh = { "shfmt" },
    bash = { "shfmt" },
    -- xml is intentionally absent: lsp_fallback below hands it to lemminx
  },

  formatters = {
    shfmt = { prepend_args = { "-i", "2" } },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 2000, -- raised from 500: prettier often exceeds 500ms on a cold start and silently skips
    lsp_fallback = true,
  },
}

return options
