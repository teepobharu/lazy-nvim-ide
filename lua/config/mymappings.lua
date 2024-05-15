-- Resize with arrows
map("n", "<C-Up>", ":resize -2<CR>", opts)
map("n", "<C-Down>", ":resize +2<CR>", opts)
map("n", "<C-Left>", ":vertical resize -2<CR>", opts)
map("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Resize with ESC keys - up down use for auto cmpl
map("n", "<Up>", ":resize -2<CR>", opts)
map("n", "<Down>", ":resize +2<CR>", opts)
map("n", "<Left>", "<cmd>vertical resize -2<CR>", opts)
map("n", "<Right>", "<cmd>vertical resize +2<CR>", opts)

----- LOCALLEADER ==========================
--   # which key migrate .nvim $HOME/.config/nvim/keys/which-key.vim
map("n", "<localleader>q", ":q<CR>", { desc = "Close", noremap = true, silent = true })
map("n", "<localleader>w", ":w<CR>", { desc = "Save file" })
map("n", "<localleader>X", ":qall!<CR>", { desc = "Close All" })
-- files
map("n", "<localleader>rl", ":luafile %<CR>", { desc = "Reload Lua file" })
-- map('n', 'localleader>rp', ':python3 %<CR>', { desc = "Run Python3" })
