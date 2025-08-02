require "nvchad.mappings"

-- add yours here

-- local map = vim.keymap.set

-- map("n", ";", ":", { desc = "CMD enter command mode" })
-- map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

vim.keymap.del("n", "<C-n>")
vim.keymap.set("n", "<leader>e", function()
  require("nvim-tree.api").tree.toggle()
end, { desc = "nvimtree focus window" })

vim.keymap.del({ "n", "t" }, "<A-i>")
vim.keymap.set({ "n", "t" }, "<C-\\>", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end, { desc = "terminal toggle floating term" })

vim.keymap.set({ "n", "t" }, "<leader>gg", function()
  require("nvchad.term").toggle { cmd = "exec lazygit", pos = "float", id = "floatTerm" }
end, { desc = "terminal toggle lazygit" })
