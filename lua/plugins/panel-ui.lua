return {
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    init = function()
      vim.opt.laststatus = 3
      vim.opt.splitkeep = "screen"
    end,
    opts = {
      bottom = {
        {
          ft = "toggleterm",
          size = { height = 15 },
          filter = function(buf, win)
            return vim.api.nvim_win_get_config(win).relative == ""
          end,
        },
	  },
	},
  },

  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 15,
        open_mapping = [[<c-\>]], 
        hide_numbers = true,
        shade_terminals = true,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "horizontal",
        close_on_exit = true,
        shell = vim.o.shell,
      })
	
    end
  },
}  
