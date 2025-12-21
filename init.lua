require("core.options")
require("core.keymaps")
require("config.lazy")

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.cmd("Neotree show")
  end,
})
