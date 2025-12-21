vim.g.mapleader = "\\"
vim.g.maplocalleader = " "

local keymap = vim.keymap

keymap.set("n", "<leader>nh", ":nohl<CR>")
keymap.set("n", "x", '"_x')

keymap.set("n", "<leader>sv", "<C-w>v")
keymap.set("n", "<leader>sh", "<C-w>s")
keymap.set("n", "<leader>se", "<C-w>=")
keymap.set("n", "<leader>sx", "<cmd>close<CR>")

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>")
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>")
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>")
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>")
