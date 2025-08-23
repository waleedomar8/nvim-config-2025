require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("i", "jj", "<ESC>", { desc = "Exit insert mode with jj" })

-- Tabs
map("n", "<leader>1", "<cmd>tabnext<CR>", { desc = "Next Tab" })
map("n", "<leader>2", "<cmd>tabprevious<CR>", { desc = "Prev Tab" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
