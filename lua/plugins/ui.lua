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
    opts = {
      close_if_last_window = false,
      open_files_do_not_replace_types = { "terminal", "toggleterm", "codecompanion", "qf", "trouble" },
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
        position = "left",
      },
      default_component_configs = {
        indent = {
          indent_level = 2,
        },
      },
    },
  },
  {
    "stevearc/aerial.nvim",
    opts = {
      on_attach = function(buffer)
        vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = buffer })
        vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = buffer })
      end,
      layout = { default_direction = "left" },
      autojump = true,
    },
  },
  {
    "folke/edgy.nvim",
    lazy = false,
    init = function()
      vim.opt.laststatus = 3
      vim.opt.splitkeep = "screen"
    end,
    opts = {
      exit_when_last = false,
      left = {
        {
          title = "NeoTree",
          ft = "neo-tree",
          pinned = true,
          size = { height = 0.7 },
          open = "Neotree show",
        },
        {
          title = "Aerial",
          ft = "aerial",
          pinned = true,
          size = { height = 0.3 },
          open = "AerialOpen",
        },
      },
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
        offsets = {
            {
                filetype = "neo-tree",
                text_align = "left",
                separator = true,
            },
        }
      },
    },
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
        size = 20,
        open_mapping = [[<c-\>]],
        direction = "horizontal",
    }
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
