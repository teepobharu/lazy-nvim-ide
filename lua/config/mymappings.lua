print(123)

local opts = { noremap = true, silent = true }
local map = vim.keymap.set
-- Resize with arrows

-- close buffer
map("n', <leader>wx", ":bd<CR>", { desc = "Close buffer" })
map("n', <leader>wX", ":bd!<CR>", { desc = "Force close buffer" })

-- map("n", "<C-Up>", ":resize -3<CR>", opts)
-- map("n", "<C-Down>", ":resize +3<CR>", opts)
-- map("n", "<C-Left>", ":vertical resize -3<CR>", opts)
-- map("n", "<C-Right>", ":vertical resize +3<CR>", opts)

-- Resize with ESC keys - up down use for auto cmpl
map("n", "<Up>", ":resize -3<CR>", opts)
map("n", "<Down>", ":resize +3<CR>", opts)
map("n", "<Left>", "<cmd>vertical resize -3<CR>", opts)
map("n", "<Right>", "<cmd>vertical resize +3<CR>", opts)

----- LOCALLEADER ==========================
--   # which key migrate .nvim $HOME/.config/nvim/keys/which-key.vim
map("n", "<localleader>q", ":q<CR>", { desc = "Close", noremap = true, silent = true })
map("n", "<localleader>w", ":w<CR>", { desc = "Save file" })
map("n", "<localleader>X", ":qall!<CR>", { desc = "Close All" })
-- files
map("n", "<localleader>rl", ":luafile %<CR>", { desc = "Reload Lua file" })
-- map('n', 'localleader>rp', ':python3 %<CR>', { desc = "Run Python3" })
--
