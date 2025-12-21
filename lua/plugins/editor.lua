return {
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
       position = "bottom",
       height = 10,
    },
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>" },
    },
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      size = 15,
      open_mapping = [[<c-\>]], 
      direction = "horizontal",
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      close_on_exit = true,
    },
  },
  {
    "MagicDuck/grug-far.nvim",
    opts = {},
    cmd = "GrugFar",
    keys = {
      { "<leader>sr", "<cmd>GrugFar<cr>" },
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
