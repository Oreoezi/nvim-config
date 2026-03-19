return {
  {
    "ravitemer/mcphub.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    build = "npm install -g mcp-hub@latest",
    config = function()
      require("mcphub").setup({
        port = 3000,
        config = vim.fn.stdpath("config") .. "/mcpservers.json",
      })
    end,
  },
  {
    "georgeharker/mcp-diagnostics.nvim",
    dependencies = { "ravitemer/mcphub.nvim" },
    -- No manual setup needed - loaded automatically via CodeCompanion extensions config
  },
  {
    "Davidyz/VectorCode",
    cmd = { "VectorCode" },
    build="uv tool install vectorcode[sentence-transformers]"
  },
}
