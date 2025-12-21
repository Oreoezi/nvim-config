return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<cr>" },
    },
    opts = {
      close_if_last_window = true,
      filesystem = {
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = {
            visible = true,
            hide_dotfiles = false,
            hide_gitignored = false,
        },
      },
      window = {
        width = 30,
      }
    },
  },
  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    version = "*",
    lazy = false,
    opts = {
      options = {
        mode = "buffers",
        separator_style = "slant",
        always_show_bufferline = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        color_icons = true,
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "auto",
        globalstatus = true,
        component_separators = { left = '|', right = '|'},
        section_separators = { left = '', right = ''},
      },
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
        indent = { char = "│" },
        scope = { enabled = true },
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
        require("catppuccin").setup({
            flavour = "mocha",
            transparent_background = false,
            integrations = {
                neotree = true,
                gitsigns = true,
                cmp = true,
                mason = true,
                native_lsp = { enabled = true },
            }
        })
        vim.cmd.colorscheme "catppuccin"
    end
  }
}
