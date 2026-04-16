return {
  "milanglacier/minuet-ai.nvim",
  lazy = false,  -- Load immediately so cmp can use it as source
  ft = { "lua", "python", "javascript", "typescript", "go", "rust", "cpp", "c", "java", "sh" },  -- filetype detection still works
  dependencies = { "nvim-lua/plenary.nvim" },
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

    require("minuet").setup({
      -- Use openai_compatible for chat-based models
      provider = "openai_compatible",

      -- Timing settings - conservative to avoid rate limits
      throttle = 3000,  -- Only send request every 3 seconds max
      debounce = 800,   -- Wait 800ms after typing stops

      -- Context window (16k chars ≈ 4k tokens for most models)
      context_window = 8000,  -- Smaller for faster responses
      context_ratio = 0.75,

      -- Number of completion items to request (fewer = faster)
      n_completions = 1,

      -- Filter settings
      after_cursor_filter_length = 15,
      before_cursor_filter_length = 2,

      -- Show single line entry for multi-line completions
      add_single_line_entry = true,

      -- Notification level
      notify = "warn",

      provider_options = {
        openai_compatible = {
          api_key = function()
            return get_api_key("OPENROUTER_API_KEY")
          end,
          end_point = "https://openrouter.ai/api/v1/chat/completions",
          model = "google/gemma-4-31b-it",
          name = "OpenRouter",
          stream = true,
          optional = {
            max_tokens = 128,
            top_p = 0.9,
          },
        },
      },
      
      -- Virtual text as the frontend (recommended in docs)
      virtualtext = {
        -- Enable for all common code filetypes
        auto_trigger_ft = { "lua", "python", "javascript", "typescript", "go", "rust", "cpp", "c", "java", "sh" },
        auto_trigger_ignore_ft = {},
        show_on_completion_menu = false,
        keymap = {
          accept = "<A-A>",        -- Alt+A twice: accept whole completion
          accept_line = "<A-a>",   -- Alt+a: accept one line
          accept_n_lines = "<A-z>",-- Alt+z: accept n lines (prompts for number)
          prev = "<A-[>",          -- Alt+[: cycle to prev
          next = "<A-]>",          -- Alt+]: cycle to next
          dismiss = "<A-e>",       -- Alt+e: dismiss
        },
      },
      
      -- Disable cmp integration, use only virtual text
      cmp = {
        enable_auto_complete = false,  -- Disable cmp source
      },
    })
    
    -- Lualine integration (if using lualine)
    pcall(function()
      local ok, lualine = pcall(require, "lualine")
      if ok then
        -- Re-configure lualine to include minuet status
      end
    end)
  end,
}
