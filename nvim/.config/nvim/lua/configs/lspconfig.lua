require("nvchad.configs.lspconfig").defaults()

-- SchemaStore is optional: if it fails to load, jsonls/yamlls still work, just without the schema catalog.
local ok_store, schemastore = pcall(require, "schemastore")

local function json_schemas()
  return ok_store and schemastore.json.schemas() or nil
end

local function yaml_schemas()
  return ok_store and schemastore.yaml.schemas() or nil
end

-- Add a server by adding one entry. An empty table means "use lspconfig defaults".
local servers = {
  ts_ls = {}, -- JS, JSX, TS, TSX

  eslint = {
    settings = {
      workingDirectory = { mode = "auto" }, -- resolves the right ESLint root in monorepos
    },
  },

  html = {},
  cssls = {},
  emmet_language_server = {},
  bashls = {},
  lemminx = {}, -- XML, XSD, XSL, SVG
  marksman = {},

  jsonls = {
    settings = {
      json = {
        schemas = json_schemas(),
        validate = { enable = true },
      },
    },
  },

  yamlls = {
    settings = {
      redhat = { telemetry = { enabled = false } },
      yaml = {
        keyOrdering = false,
        format = { enable = true }, -- used as the fallback when conform has no formatter
        validate = true,
        -- built-in store disabled so SchemaStore.nvim is the only schema source
        schemaStore = { enable = false, url = "" },
        schemas = yaml_schemas(),
      },
    },
  },

  rust_analyzer = {},
}

for name, config in pairs(servers) do
  -- only call vim.lsp.config when there is something to merge
  if next(config) ~= nil then
    vim.lsp.config(name, config)
  end
end

vim.lsp.enable(vim.tbl_keys(servers))

-- read :h vim.lsp.config for changing options of lsp servers
