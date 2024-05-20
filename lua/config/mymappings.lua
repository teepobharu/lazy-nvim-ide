local LazyVimUtil = require("lazyvim.util")
local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set
-- ===========================
-- LAZY NVIM ====================
-- =======================
vim.api.nvim_del_keymap("n", "<leader>l")
vim.api.nvim_del_keymap("n", "<leader>L")

-- Setup keys
-- check using :letmapleader or :let maplocalleader
-- -> need to put inside plugins mapping also to make it work on those mapping
-- command completion in command line mode
keymap("n", "<leader>ll", "<cmd>Lazy<CR>", { desc = "Lazy" })
keymap("n", "<leader>lx", "<cmd>LazyExtras<CR>", { desc = "Lazy Extras" })

keymap("n", "<leader>lc", function()
  LazyVimUtil.lazygit.open({
    cwd = vim.fn.expand("~/.cfg"),
    args = { "-w", vim.fn.expand("~"), "--git-dir", vim.fn.expand("~/.cfg") },
  })
end, { desc = "LazyGit Config" })

-- ============================
-- EDITING
-- ============================
--
vim.cmd([[
  cnoremap <expr> <C-j> wildmenumode() ? "\<C-N>" : "\<C-j>"
  cnoremap <expr> <C-k> wildmenumode() ? "\<C-P>" : "\<C-k>"
]])

-- ============================
--  Navigations
-- ============================
-- Tmux navigation - move to plugins config
--
keymap("n", "<C-k>", "<cmd>NvimTmuxNavigateUp<cr>", opts)
keymap("n", "<C-j>", "<cmd>NvimTmuxNavigateDown<cr>", opts)
keymap("n", "<C-h>", "<cmd>NvimTmuxNavigateLeft<cr>", opts)
keymap("n", "<C-l>", "<cmd>NvimTmuxNavigateRight<cr>", opts)

keymap("t", "<C-k>", "<cmd>NvimTmuxNavigateUp<cr>", opts)
keymap("t", "<C-j>", "<cmd>NvimTmuxNavigateDown<cr>", opts)
keymap("t", "<C-h>", "<cmd>NvimTmuxNavigateLeft<cr>", opts)
keymap("t", "<C-l>", "<cmd>NvimTmuxNavigateRight<cr>", opts)

-- ============================
--   Windows and Tabs
-- ============================
keymap("n", "<leader>wh", ":sp<CR>", { desc = "HSplit", silent = true })
keymap("n", "<leader>wv", ":vs<CR>", { desc = "VSplit", silent = true })
keymap("n", "<M-Tab>", ":tabnext<CR>", { noremap = true, silent = true })

-- map("n", "<C-Up>", ":resize -3<CR>", opts)
-- map("n", "<C-Down>", ":resize +3<CR>", opts)
-- map("n", "<C-Left>", ":vertical resize -3<CR>", opts)
-- map("n", "<C-Right>", ":vertical resize +3<CR>", opts)

-- Resize with ESC keys - up down use for auto cmpl
keymap("n", "<Up>", ":resize -3<CR>", opts)
keymap("n", "<Down>", ":resize +3<CR>", opts)
keymap("n", "<Left>", "<cmd>vertical resize -3<CR>", opts)
keymap("n", "<Right>", "<cmd>vertical resize +3<CR>", opts)
-- H and L to change buffer (LAZY)
-- map("n", "H", ":bp<CR>", { desc = "Previous Buffer", silent = true })
-- map("n", "L", ":bn<CR>", { desc = "Next Buffer", silent = true })
-- use <l>bd instead
-- map("n", "<leader>wx", ":bd<CR>", { desc = "Close buffer" })
-- map("n", "<leader>wX", ":bd!<CR>", { desc = "Force close buffer" })

-- ============================
-- Terminal & Commands
-- ============================
keymap("n", ";", ":", { desc = "CMD enter command mode" })
--
-- ===========================================
--  Search
-- ===============================================
-- before adding to search copy to system clipboard first
keymap("v", "//", "y/\\V<C-R>=escape(@\",'/\\')<CR><CR>", { desc = "Search selected visual" })
keymap("v", "//", "\"+y/\\V<C-R>=escape(@\",'/\\')<CR><CR>", { desc = "Search selected visual" })
--
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
keymap("n", "<C-S-j>", gitsigns_jump_next_hunk, { desc = "Jump to next hunk", expr = true })
keymap("n", "<C-M-j>", gitsigns_jump_next_hunk, { desc = "Jump to next hunk", expr = true })
keymap("n", "<C-S-k>", gitsigns_jump_prev_hunk, { desc = "Jump to prev hunk", expr = true })
keymap("n", "<C-M-k>", gitsigns_jump_prev_hunk, { desc = "Jump to prev hunk", expr = true })

-- ===============================================
-- LOCALLEADER ==========================
-- ===============================================
--   # which key migrate .nvim $HOME/.config/nvim/keys/which-key.vim
keymap("n", "<localleader>q", ":q<CR>", { desc = "Close", noremap = true, silent = true })
keymap("n", "<localleader>w", ":w<CR>", { desc = "Save file" })
keymap("n", "<localleader>X", ":qall!<CR>", { desc = "Close All" })
-- files
keymap("n", "<localleader>rl", ":luafile %<CR>", { desc = "Reload Lua file" })
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
keymap("n", "<leader>bR", rename_buffer, { desc = "Rename Buffer", noremap = true, silent = true })

local open_command = "xdg-open"
if vim.fn.has("mac") == 1 then
  open_command = "open"
end

local function url_repo()
  local cursorword = vim.fn.expand("<cfile>")
  -- __AUTO_GENERATED_PRINT_VAR_START__
  print([==[url_repo cursorword:]==], vim.inspect(cursorword)) -- __AUTO_GENERATED_PRINT_VAR_END__
  if string.find(cursorword, "^[a-zA-Z0-9-_.]*/[a-zA-Z0-9-_.]*$") then
    cursorword = "https://github.com/" .. cursorword
  end
  print(cursorword or "")
  return cursorword or ""
end

keymap({ "n", "v" }, "gx", function()
  local url_or_word = url_repo()
  -- copy to register + if not empty
  vim.fn.jobstart({ open_command, url_or_word }, { detach = true }) -- not work in tmux
  if url_or_word ~= "" then
    vim.fn.setreg("+", url_or_word)
  end
  -- fallback to send gx if not a link or files
  -- vim.cmd("normal! gx")
  -- print("!" .. open_command .. " " .. url_repo())
  -- vim.cmd("!" .. open_command .. " " .. url_repo())
end, { silent = true, desc = "Copy word / Open url" })
