local opt = vim.opt

-- Close neo-tree before quit to prevent invalid window ID errors
vim.api.nvim_create_autocmd('VimLeavePre', {
  group = vim.api.nvim_create_augroup('neo-tree-cleanup', { clear = true }),
  callback = function()
    -- Try to close neo-tree gracefully if it's open
    local neo_tree_exists = pcall(function()
      vim.cmd('Neotree close')
    end)
    -- Force close any remaining neo-tree buffers
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) then
        local ft = vim.api.nvim_buf_get_option(buf, 'filetype')
        if ft == 'neo-tree' then
          vim.cmd('bd! ' .. buf)
        end
      end
    end
  end,
})

-- Allow :q on empty/default buffers
vim.api.nvim_create_autocmd('BufEnter', {
  group = vim.api.nvim_create_augroup('empty-buffer-quit', { clear = true }),
  pattern = '*',
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local buftype = vim.api.nvim_buf_get_option(bufnr, 'buftype')
    local name = vim.api.nvim_buf_get_name(bufnr)
    
    -- If it's an empty unnamed buffer with nothing in it, allow :q to close it
    if buftype == '' and name == '' and vim.api.nvim_buf_line_count(bufnr) == 1 then
      local line = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1]
      if line == nil or line == '' then
        -- Set it to help so :q works
        vim.api.nvim_buf_set_option(bufnr, 'bufhidden', 'wipe')
      end
    end
  end,
})

opt.expandtab = false
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4

opt.relativenumber = true
opt.number = true
opt.wrap = false
opt.ignorecase = true
opt.smartcase = true
opt.cursorline = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.clipboard = "unnamedplus"
opt.mouse = "a"
opt.scrolloff = 8
opt.updatetime = 250

opt.laststatus = 3
opt.splitkeep = "screen"
