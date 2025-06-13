require "nvchad.autocmds"

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local ok, showkeys = pcall(require, "showkeys")
    if ok then
      showkeys.toggle()
    end
  end,
})
