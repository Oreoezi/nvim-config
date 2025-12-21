return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "saghen/blink.cmp", 
  },
  config = function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local has_blink, blink = pcall(require, "blink.cmp")
    if has_blink then
      capabilities = blink.get_lsp_capabilities()
    else
      local has_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if has_cmp then
        capabilities = cmp_lsp.default_capabilities()
      end
    end

    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = { "lua_ls", "ts_ls" },
      handlers = {
        function(server_name)
          -- THE FIX: Native config for Nvim 0.11+
          if vim.fn.has('nvim-0.11') == 1 then
            vim.lsp.config(server_name, {
              capabilities = capabilities,
            })
            vim.lsp.enable(server_name)
          else
            require("lspconfig")[server_name].setup({
              capabilities = capabilities,
            })
          end
        end,
      }
    })
  end
}
