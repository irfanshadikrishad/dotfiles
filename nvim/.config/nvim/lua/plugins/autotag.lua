return {
  "windwp/nvim-ts-autotag",
  enabled = true,
  event = "BufReadPre",
  config = function()
    require("nvim-ts-autotag").setup {
      enable_close = true,
      enable_rename = true,
      enable_close_on_slash = false,

      per_filetype = {
        ["html"] = {
          enable_close = false,
        },
        ["javascriptreact"] = {
          enable_close = false,
        },
        ["typescriptreact"] = {
          enable_close = false,
        },
      },
    }
  end,
}
