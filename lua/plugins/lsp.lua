return { 
  {
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
        ensure_installed = {
          "svelte",
          "ts_ls",
          "pyright",
          "clangd",
          "neocmake",
          "jdtls",
          "rust_analyzer",
          "yamlls",
          "taplo",
          "jsonls",
          "verible",
          "hls",
          "bashls",
        },
        handlers = {
          -- Python: use venv if detected
          pyright = function()
            local venv = os.getenv("VIRTUAL_ENV")
            local pythonBin = "python"
            if venv then
              pythonBin = venv .. "/bin/python"
            end
            
            local config = {
              capabilities = capabilities,
              settings = {
                python = {
                  pythonPath = pythonBin,
                }
              }
            }
            
            if vim.fn.has('nvim-0.11') == 1 then
              vim.lsp.config("pyright", config)
              vim.lsp.enable("pyright")
            else
              require("lspconfig")["pyright"].setup(config)
            end
          end,
          function(server_name)
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
  },
  {
    "smjonas/inc-rename.nvim",
    config = function()
      require("inc_rename").setup()
    end
  }
}
