local opts = { noremap = true, silent = true }
local map = vim.keymap.set
vim.g.maplocalleader = ","
-- Setup keys
-- check using :letmapleader or :let maplocalleader
-- -> need to put inside plugins mapping also to make it work on those mapping
-- command completion in command line mode
vim.cmd([[
  cnoremap <expr> <C-j> wildmenumode() ? "\<C-N>" : "\<C-j>"
  cnoremap <expr> <C-k> wildmenumode() ? "\<C-P>" : "\<C-k>"
]])
-- ============================
--  Navigations
-- ============================
-- Tmux navigation - move to plugins config
--
map("n", "<C-k>", "<cmd>NvimTmuxNavigateUp<cr>", opts)
map("n", "<C-j>", "<cmd>NvimTmuxNavigateDown<cr>", opts)
map("n", "<C-h>", "<cmd>NvimTmuxNavigateLeft<cr>", opts)
map("n", "<C-l>", "<cmd>NvimTmuxNavigateRight<cr>", opts)

map("t", "<C-k>", "<cmd>NvimTmuxNavigateUp<cr>", opts)
map("t", "<C-j>", "<cmd>NvimTmuxNavigateDown<cr>", opts)
map("t", "<C-h>", "<cmd>NvimTmuxNavigateLeft<cr>", opts)
map("t", "<C-l>", "<cmd>NvimTmuxNavigateRight<cr>", opts)
-- ============================
--   Windows and Tabs
-- ============================
map("n", "<leader>wh", ":sp<CR>", { desc = "HSplit", silent = true })
map("n", "<leader>wv", ":vs<CR>", { desc = "VSplit", silent = true })
map("n", "<M-Tab>", ":tabnext<CR>", { noremap = true, silent = true })

-- map("n", "<C-Up>", ":resize -3<CR>", opts)
-- map("n", "<C-Down>", ":resize +3<CR>", opts)
-- map("n", "<C-Left>", ":vertical resize -3<CR>", opts)
-- map("n", "<C-Right>", ":vertical resize +3<CR>", opts)

-- Resize with ESC keys - up down use for auto cmpl
map("n", "<Up>", ":resize -3<CR>", opts)
map("n", "<Down>", ":resize +3<CR>", opts)
map("n", "<Left>", "<cmd>vertical resize -3<CR>", opts)
map("n", "<Right>", "<cmd>vertical resize +3<CR>", opts)
-- H and L to change buffer (LAZY)
-- map("n", "H", ":bp<CR>", { desc = "Previous Buffer", silent = true })
-- map("n", "L", ":bn<CR>", { desc = "Next Buffer", silent = true })
-- use <l>bd instead
-- map("n", "<leader>wx", ":bd<CR>", { desc = "Close buffer" })
-- map("n", "<leader>wX", ":bd!<CR>", { desc = "Force close buffer" })

-- ============================
-- Terminal & Commands
-- ============================
map("n", ";", ":", { desc = "CMD enter command mode" })
-- map("i", "jk", "<ESC>", { desc = "Escape insert mode" })
-- Resize with arrows

-- close buffer

-- ===========================================
-- GIT
-- ===============================================

function gitsigns_jump_next_hunk()
  if vim.wo.diff then
    return "[c"
  end
  vim.schedule(function()
    require("gitsigns").next_hunk()
  end)
  return "<Ignore>"
end
function gitsigns_jump_prev_hunk()
  if vim.wo.diff then
    return "[c"
  end
  vim.schedule(function()
    require("gitsigns").prev_hunk()
  end)
  return "<Ignore>"
end
map("n", "<C-S-j>", gitsigns_jump_next_hunk, { desc = "Jump to next hunk", expr = true })
map("n", "<C-M-j>", gitsigns_jump_next_hunk, { desc = "Jump to next hunk", expr = true })
map("n", "<C-S-k>", gitsigns_jump_prev_hunk, { desc = "Jump to prev hunk", expr = true })
map("n", "<C-M-k>", gitsigns_jump_prev_hunk, { desc = "Jump to prev hunk", expr = true })

-- ===============================================
-- LOCALLEADER ==========================
-- ===============================================
--   # which key migrate .nvim $HOME/.config/nvim/keys/which-key.vim
map("n", "<localleader>q", ":q<CR>", { desc = "Close", noremap = true, silent = true })
map("n", "<localleader>w", ":w<CR>", { desc = "Save file" })
map("n", "<localleader>X", ":qall!<CR>", { desc = "Close All" })
-- files
map("n", "<localleader>rl", ":luafile %<CR>", { desc = "Reload Lua file" })
-- map('n', 'localleader>rp', ':python3 %<CR>', { desc = "Run Python3" })

-- ===========================
-- Custom commands ====================
-- =======================

local function rename_buffer()
  local old_name = vim.fn.expand("%")
  local new_name = vim.fn.input("Enter new buffer name: ", old_name)

  -- If user provided a new name and it's different from the old name
  if new_name ~= "" and new_name ~= old_name then
    -- Rename the buffer
    vim.api.nvim_buf_set_name(0, new_name)
    print("Buffer renamed to " .. new_name)
  else
    print("Buffer not renamed.")
  end
end

-- map("n", "<leader>n", "", { desc = "+CustomCommands" })
-- map("n", "<leader>nn", "<cmd>so $MYVIMRC<CR>", { desc = "Source Config" })
-- map("n", "<leader>S", "<cmd>SSave<CR>", { desc = "Save Session" })
-- map('n', '<Leader>nm', ':messages <CR>', { noremap = true, silent = true, desc = 'Show messages' })
-- map('n', '<Leader>nM', [[:redir @a<CR>:messages<CR>:redir END<CR>:put! a<CR>]], { noremap = true, silent = true, desc = 'Print messages' })
-- copy relative filepath name
-- map("n", "<leader>nf", ":let @+=@%<CR>", { desc = "Copy relative filepath name" })
-- copy absolute filepath - use neotree (no relative file)
-- map("n", "<leader>nF", ':let @+=expand("%:p")<CR>', { desc = "Copy absolute filepath" })
-- Bind a key to invoke the renaming function
map("n", "<leader>bR", rename_buffer, { desc = "Rename Buffer", noremap = true, silent = true })

local open_command = "xdg-open"
if vim.fn.has("mac") == 1 then
  open_command = "open"
end

local function url_repo()
  local cursorword = vim.fn.expand("<cfile>")
  if string.find(cursorword, "^[a-zA-Z0-9-_.]*/[a-zA-Z0-9-_.]*$") then
    cursorword = "https://github.com/" .. cursorword
  end
  return cursorword or ""
end

map("n", "gx", function()
  vim.fn.jobstart({ open_command, url_repo() }, { detach = true }) -- not work in tmux
  -- fallback to send gx if not a link or file
  -- print("!" .. open_command .. " " .. url_repo())
  -- vim.cmd("!" .. open_command .. " " .. url_repo())
end, { silent = true, desc = "Open url" })
--
--
