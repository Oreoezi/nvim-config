vim.g.mapleader = "\\"
vim.g.maplocalleader = " "

local keymap = vim.keymap.set

-- General
keymap("n", "<leader>nh", "<cmd>nohl<CR>")
keymap("n", "x", '"_x')

-- Splits
keymap("n", "<leader>sv", "<C-w>v")
keymap("n", "<leader>sh", "<C-w>s")
keymap("n", "<leader>se", "<C-w>=")
keymap("n", "<leader>sx", "<cmd>close<CR>")

-- Tabs
keymap("n", "<leader>to", "<cmd>tabnew<CR>")
keymap("n", "<leader>tx", "<cmd>tabclose<CR>")
keymap("n", "<leader>tn", "<cmd>tabn<CR>")
keymap("n", "<leader>tp", "<cmd>tabp<CR>")

-- NeoTree / Edgy
keymap("n", "<leader>e", function()
  require("edgy").toggle("left")
end, { desc = "Toggle Edgy (NeoTree + Aerial)" })

keymap("n", "<leader>t", "<cmd>ToggleTerm<CR>", { desc = "Toggle Terminal" })

-- CodeCompanion
keymap({ "n", "v" }, "<leader>cc", function()
  vim.cmd("CodeCompanionChat Toggle")
  vim.defer_fn(function()
    vim.cmd("60wincmd |")
  end, 50)
end, { desc = "Toggle CodeCompanion Chat" })
keymap({ "n", "v" }, "<leader>ca", "<cmd>CodeCompanionActions<CR>", { desc = "CodeCompanion Actions" })
keymap("v", "ga", "<cmd>CodeCompanionChat Add<CR>", { desc = "Add selection to Chat" })
