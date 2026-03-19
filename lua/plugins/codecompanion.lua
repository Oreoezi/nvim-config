return {
  -- CodeCompanion (AI Chat & Agent)
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = function()
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
          chat = {
            show_reasoning = true,
            fold_reasoning = false,
          },
          action_palette = {
            provider = "telescope",
          },
        },
        -- Add extensions here
        extensions = {
          mcp_diagnostics = {
            callback = "mcp-diagnostics.codecompanion.extension",
            opts = {},
          },
        },
        interactions = {
          chat = {
            adapter = "openrouter",
            roles = {
              llm = "CodeCompanion",
              user = "Me",
            },
            opts = {
              completion_provider = "cmp",
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
            tools = {
              opts = {
                default_tools = {
                  "ask_questions",
                  "create_file",
                  "delete_file",
                  "fetch_webpage",
                  "file_search",
                  "get_changed_files",
                  "get_diagnostics",
                  "grep_search",
                  "insert_edit_into_file",
                  "memory",
                  "read_file",
                  "run_command",
                  "web_search",
                  "files",
                  "agent",
                },
              },
              ["lsp"] = { enabled = true },
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
        prompt_library = {
          markdown = {
            dirs = {
              vim.fn.stdpath("config") .. "/prompts",
            },
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

      vim.cmd([[cabbrev cc CodeCompanion]])

    end,
  },
}
