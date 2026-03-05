return {
  -- CodeCompanion (AI Chat & Agent)
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim",
      {
        "ravitemer/mcphub.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        build = "npm install -g mcp-hub@latest",
        config = function()
          require("mcphub").setup({
            port = 3000,
            config = vim.fn.expand("~/mcpservers.json"),
          })
        end,
      },
      "hrsh7th/nvim-cmp",
    },
    config = function()
      local tools = {
        ["mcp"] = {
          callback = function()
            return require("mcphub.extensions.codecompanion")
          end,
          description = "Access tools and resources from MCP servers",
        },
        ["files"] = {
          callback = "strategies.chat.tools.files",
          description = "Read and write files",
        },
        ["shell"] = {
          callback = "strategies.chat.tools.shell",
          description = "Run shell commands",
        },
        ["editor"] = {
          callback = "strategies.chat.tools.editor",
          description = "Interact with the Neovim editor",
        },
      }

      require("codecompanion").setup({
        display = {
          action_palette = {
            provider = "telescope",
          },
        },
        strategies = {
          chat = {
            adapter = "openrouter",
            roles = {
              llm = "CodeCompanion",
              user = "Me",
            },
            opts = {
              completion_provider = "cmp",
            },
            tools = tools,
          },
          inline = {
            adapter = "openrouter",
          },
        },
        adapters = {
          http = {
            openrouter = function()
              return require("codecompanion.adapters").extend("openai", {
                env = {
                  api_key = function()
                    local env_key = os.getenv("OPENROUTER_API_KEY")
                    if env_key then
                      return env_key
                    end

                    local f = io.open(vim.fn.expand("~/.config/nvim/.env"), "r")
                    if f then
                      for line in f:lines() do
                        local value = line:match("^OPENROUTER_API_KEY=(.+)$")
                        if value then
                          f:close()
                          return value
                        end
                      end
                      f:close()
                    end
                    return ""
                  end,
                },
                url = "https://openrouter.ai/api/v1/chat/completions",
                headers = {
                  ["HTTP-Referer"] = "https://github.com/olimorris/codecompanion.nvim",
                  ["X-Title"] = "CodeCompanion",
                  ["Authorization"] = "Bearer ${api_key}",
                },
                schema = {
                  model = {
                    default = "minimax/minimax-m2.5",
                  },
                },
              })
            end,
          },
        },
      })

      -- Expand 'cc' into 'CodeCompanion' in the command line
      vim.cmd([[cabbrev cc CodeCompanion]])

      -- Keymaps
      vim.keymap.set({ "n", "v" }, "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "Toggle CodeCompanion Chat" })
      vim.keymap.set({ "n", "v" }, "<leader>ca", "<cmd>CodeCompanionActions<cr>", { desc = "CodeCompanion Actions" })
      vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { desc = "Add selection to Chat" })
    end,
  },
}
