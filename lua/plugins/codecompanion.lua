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
          -- Temporarily disabled to prevent the version parsing crash
          -- require("mcphub").setup({
          --   port = 3000,
          --   config = vim.fn.expand("~/mcpservers.json"),
          -- })
        end,
      },
      "hrsh7th/nvim-cmp",
    },
    config = function()
      -- Helper: read API key from env or .env file
      local function get_api_key(var_name)
        local env_key = os.getenv(var_name)
        if env_key then
          return env_key
        end

        local f = io.open(vim.fn.stdpath("config") .. "/.env", "r")
        if f then
          for line in f:lines() do
            local value = line:match("^" .. var_name .. "=(.+)$")
            if value then
              f:close()
              return value
            end
          end
          f:close()
        end
        return ""
      end

      require("codecompanion").setup({
        display = {
          action_palette = {
            provider = "telescope",
          },
        },
        opts = {
          system_prompt = function()
            local prompt_path = vim.fn.stdpath("config") .. "/prompts/system.prompt"
            local f = io.open(prompt_path, "r")
            if f then
              local content = f:read("*all")
              f:close()
              return content
            end
            return "You are a helpful programming assistant."
          end,
        },
        prompt_library = {
          markdown = {
            dirs = {
              vim.fn.stdpath("config") .. "/prompts",
            },
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
            tools = {
              ["mcp"] = {
                callback = function()
                  local ok, mcphub = pcall(require, "mcphub.extensions.codecompanion")
                  if ok then
                    return mcphub
                  end
                end,
                description = "Access tools and resources from MCP servers",
              },
              ["web_search"] = {
                opts = {
                  adapter = "tavily",
                  opts = {
                    search_depth = "advanced",
                    topic = "general",
                    chunks_per_source = 3,
                    max_results = 5,
                  },
                },
              },
              ["files"] = { enabled = true },
              ["cmd_runner"] = { enabled = true },
              ["editor"] = { enabled = true },
            },
            slash_commands = {
              ["search"] = {
                callback = "codecompanion.strategies.chat.slash_commands.search",
                description = "Search the web for information",
                opts = {
                  adapter = "tavily",
                },
              },
            },
          },
          inline = {
            adapter = "openrouter",
          },
        },
        adapters = {
          http = {
            tavily = function()
              return require("codecompanion.adapters").extend("tavily", {
                env = {
                  api_key = function()
                    return get_api_key("TAVILY_API_KEY")
                  end,
                },
              })
            end,
            openrouter = function()
              return require("codecompanion.adapters").extend("openai", {
                env = {
                  api_key = function()
                    return get_api_key("OPENROUTER_API_KEY")
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
