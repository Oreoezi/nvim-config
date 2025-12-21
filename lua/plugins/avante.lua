return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = false, 
  opts = {
    provider = "openrouter",
    
    providers = {
      openrouter = {
        __inherited_from = "openai",
        endpoint = "https://openrouter.ai/api/v1",
        api_key_name = "OPENROUTER_API_KEY",
        model = "moonshotai/kimi-k2-thinking",
      },
    },  
  },
  build = "make",
  dependencies = {
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
}
