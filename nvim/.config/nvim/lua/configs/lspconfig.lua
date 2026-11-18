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

  -- Python: pyright = types/completion/navigation, ruff = lint + import code actions.
  -- Formatting stays with conform (black).
  pyright = {
    settings = {
      pyright = {
        disableOrganizeImports = true, -- ruff owns import sorting
      },
      python = {
        analysis = {
          typeCheckingMode = "standard", -- "basic" is looser, "strict" is noisy on untyped code
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = "openFilesOnly", -- keeps large repos/monorepos fast
        },
      },
    },
  },

  ruff = {
    init_options = {
      settings = {
        logLevel = "warn",
      },
    },
  },
}

-- Ruff and pyright both provide hover; keep pyright's (it has the type info).
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("RuffDisableHover", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "ruff" then
      client.server_capabilities.hoverProvider = false
    end
  end,
  desc = "LSP: disable hover from ruff in favour of pyright",
})

for name, config in pairs(servers) do
  -- only call vim.lsp.config when there is something to merge
  if next(config) ~= nil then
    vim.lsp.config(name, config)
  end
end

vim.lsp.enable(vim.tbl_keys(servers))

-- read :h vim.lsp.config for changing options of lsp servers
