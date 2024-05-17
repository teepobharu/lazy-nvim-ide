-- " Mapping guide
-- " Mapping References"
-- : nvchad: https://github.com/NvChad/NvChad/blob/2e54fce0281cee808c30ba309610abfcb69ee28a/lua/nvchad/mappings.lua
-- ====================================

local opts = { noremap = true, silent = true }

-- local keymap = vim.api.nvim_set_keymap
local map = vim.keymap.set
local telescope_pickers = require("config.telescope_pickers")

--
-- -- HANDLE tab cmp completion in lua : https://github.com/nanotee/nvim-lua-guide#tips-4

-- ==============================
-- Windows ======================
-- ==============================

local function toggle_fold_or_clear_highlight()
  if vim.fn.foldlevel(".") > 0 then
    vim.api.nvim_input("za")
  else
    vim.cmd("nohlsearch")
  end
end
map("n", "<Esc>", toggle_fold_or_clear_highlight, { expr = true, silent = true, noremap = true })

-- Terminal ==================
vim.api.nvim_create_user_command("OpenTerminalInSplitWithCwd", function()
  local cwd = vim.fn.expand("%:p:h")

  vim.api.nvim_command("split | lcd " .. cwd .. " | terminal")
end, {})
map("n", "<Leader>t.", ":OpenTerminalInSplitWithCwd<CR>", { noremap = true, silent = true })

-- =========================
-- Editing =====================
-- =========================

-- Duplicate line and preserve previous yank register
map("n", "<A-d>", function()
  local saved_unnamed = vim.fn.getreg('"')
  local saved_unnamedplus = vim.fn.getreg("+")
  local current_line = vim.fn.getline(".")
  -- Save previous yank registers in a safe place
  -- propmt inform to choose reg to save
  -- print("Choose register to save")
  -- local temp_register = vim.fn.nr2char(vim.fn.getchar()) -- choose char
  local temp_register = "m"
  vim.fn.setreg(temp_register, saved_unnamed, "a")
  vim.fn.setreg('"', current_line, "a")
  vim.fn.setreg("+", current_line, "a")
  -- Duplicate the current line
  -- vim.cmd('normal! yyp')
  vim.api.nvim_input("yyp")
  -- Restore previous yank registers
  vim.fn.setreg('"', saved_unnamed, "a")
  vim.fn.setreg("+", saved_unnamedplus, "a")
  vim.fn.setreg(temp_register, "", "a")
end, { desc = "Duplicate line and preserve yank register" })

-- " Copy to system clipboard
-- vnoremap <leader>y "+y
-- nnoremap <leader>Y "+yg_
-- nnoremap <leader>y "+y
-- nnoremap <leader>yy "+yy

vim.opt.clipboard = ""

map("n", "Y", '"+y', { desc = "Copy to system clipboard" })
map("n", "YY", '"+yy', { desc = "Copy to system clipboard" })
map("v", "Y", '"+y', { desc = "Copy to system clipboard" })
map("v", "<C-c>", '"+y', { desc = "Copy to system clipboard" })
-- copy to nvim only not system clipboard

-- ========================
-- TO BE MIGRATED ============
-- =====================
--
-- Menu navigation

-- " THE EXISTING Key bindings cannot be remap again"
-- C-J, C-E cannot be used to map again

-- My mappings from Chadv2

map("i", "jk", "<ESC>", { desc = "Escape insert mode" })
map("n", "<C-S-Left>", "<C-W>+", { desc = "Resize window up +2" })
map("n", "<C-S-Right>", "<C-W>-", { desc = "Resize window down -2" })
map("n", ",c", ":lcd%:p:h <CR>", { desc = "CD to current dir" })

opts.desc = "Move up"
-- map("n", "<A-k>", ":m .-2<cr>==", opts)
-- map("n", "<A-j>", ":m .+1<cr>==", { desc = "Move down" })
-- map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
-- map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

map("v", ">", ">gv", { desc = "Better Indent right" })
map("v", "<", "<gv", { desc = "Better Indent left" })
map("v", "//", "y/\\V<C-R>=escape(@\",'/\\')<CR><CR>", { desc = "Search selected visual" })

--==========================
-- TELESCOPE ---
--==========================
-- map("n", "<leader>ft", "<cmd>Telescope<CR>", { desc = "Telescope" })
-- map("n", "<leader>e", "<cmd>Telescope buffers<CR>", { desc = "Telescope Buffers" })
-- map("n", "<leader>fr", function()
--   require("telescope.builtin").lsp_references()
-- end, { desc = "LSP Find References" })

-- map("n", "<leader>fg", function()
--   local is_inside_work_tree = {}
--   local opts = {} -- define here if you want to define something
--
--   local cwd = vim.fn.getcwd()
--   if is_inside_work_tree[cwd] == nil then
--     vim.fn.system("git rev-parse --is-inside-work-tree")
--     is_inside_work_tree[cwd] = vim.v.shell_error == 0
--   end
--
--   if is_inside_work_tree[cwd] then
--     require("telescope.builtin").git_files(opts)
--   else
--     require("telescope.builtin").find_files(opts)
--   end
-- end, { desc = "LSP Find Files Git" })
--
local custom_pickers = nil

local setCustomPickersAndRunPickers = function(cb)
  if not custom_pickers then
    print("Custom pickers not set")
    custom_pickers = telescope_pickers.telescope.getPickers()
  end
  custom_pickers[cb]()
end
--  =======================================
-- Other mappings for telescopes
-- =======================================
-- Telescope helper functions
local function is_git_repo()
  vim.fn.system("git rev-parse --is-inside-work-tree")

  return vim.v.shell_error == 0
end

local function get_git_root()
  local dot_git_path = vim.fn.finddir(".git", ".;")
  return vim.fn.fnamemodify(dot_git_path, ":h")
end

function live_grep_from_project_git_root()
  local opts = {}
  if is_git_repo() then
    opts = {
      cwd = get_git_root(),
    }
  end
  require("telescope.builtin").live_grep(opts)
end

vim.api.nvim_create_user_command("FindConfig", function()
  -- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#having-a-factory-like-function-based-on-a-dict - configure factory like dict differenet find cmds
  -- if current path is ~ only limit to depth = 1  with prompt = find HOME files include hidden files and folders
  if vim.fn.getcwd() == vim.fn.expand("~") then
    require("telescope.builtin").find_files({
      prompt_title = "Find $HOME files",
      cwd = "~",
      find_command = { "fd", "--type", "f", "--hidden", "--max-depth", "1" },
    })
    return
  end
  require("telescope.builtin").find_files({ prompt_title = "Find .Config files", cwd = "~/.config" })
end, {})

-- Telescope custom pickers
map("n", "<leader>fs", function()
  setCustomPickersAndRunPickers("session_pickers")
end, { desc = "Startify Sessions" })
map("n", "<leader>nz", function()
  setCustomPickersAndRunPickers("test_pickers")
end, { desc = "Telescope Test Picker" })
-- map("n", "<leader>go", function()
--   setCustomPickersAndRunPickers("open_git_pickers")
-- end, { desc = "Git Open remote" })
map("n", "<leader>fZ", "<cmd>FindConfig<CR>", { desc = "Find Config files" })

-- ===========================================
-- =============  GIT =============================
-- ===============================================
--
--  Sample workflow : https://www.youtube.com/watch?v=IyBAuDPzdFY&t=213s&ab_channel=DevOpsToolbox
--  gitsigns : https://github.com/lewis6991/gitsigns.nvim
--  fugitive :
--
-- ===============================
-- 1.  Git signs
-- ===============================
-- not work when inside tumx even no keys mapped ??
-- map('n', '<C-S-j>', function()

map("n", "<M-z>", function()
  require("gitsigns").reset_hunk()
end, { desc = "Reset hunk" })
map("v", "<M-z>", ":Gitsigns reset_hunk<cr>", { desc = "Reset hunk" })

-- ===============================
-- 2. Fugitive
-- ===============================
vim.cmd([[
  " Support worktree bare repo: https://github.com/tpope/vim-fugitive/issues/1841
  function! s:SetGitDir() abort
  " Check if Fugitive is loaded
  " Also check if it was terminal buffer 
  if !exists(':Git') || &buftype ==# 'terminal'
  return
  endif

  let l:cwd = getcwd()
  let l:home = $HOME

  " Check if the current directory is the home directory
  if l:cwd ==# l:home
  let b:test = 1
  let l:git_dir = l:home . '/.cfg'
  call FugitiveDetect(l:git_dir, l:cwd)
  echom 'Set FugitiveDetect in ' . l:git_dir
  endif
  endfunction

  augroup SetGitDir
  autocmd!
  autocmd DirChanged * call s:SetGitDir()
  augroup END
]])
-- above convert from whichkey vim to lua  settings
-- map("n", "<leader>gd", ":Gdiff<cr>", { silent = true, desc = "Diff" })
-- map("n", "<leader>gd", ":Gitsigns preview_hunk_inline<cr>", { desc = "Preview Hunk inline" })
-- map("n", "<leader>gd.", ":Gitsigns preview_hunk_inline<cr>", { desc = "Preview Hunk inline" })
-- map("n", "<leader>gdv", ":Gvdiffsplit<CR>", { desc = "V Diff" })
-- map("n", "<leader>gds", ":Gdiffsplit<CR>", { desc = "S Diff" })
-- mp("n", "<leader>gdm", ':Gitsigns diffthis "~"<CR>', { desc = "Diff master" })
map("n", "<leader>gbc", ":Telescope git_bcommits<cr>", { silent = true, desc = "Git BCommits" })
map("n", "<leader>gbr", ":Telescope git_branches<cr>", { silent = true, desc = "Git Branches" })
-- map("n", "<leader>gl", ":GlLog!<cr>", { silent = true, desc = "Git Log" })
-- map("n", "<leader>gL", ":Git log<cr>", { silent = true, desc = "Git Log" })
-- map("n", "<leader>gp", ":Git push<cr>", { silent = true, desc = "Git Push" })
--
-- map("n", "<leader>gr", ":Gitsigns reset_hunk<cr>", { silent = true, desc = "Git Reset Hunk" })
-- map("v", "<leader>gr", ":Gitsigns reset_hunk<cr>", { silent = true, desc = "Git Reset Hunk" })
-- map("n", "<leader>gs", ":Gitsigns stage_hunk<cr>", { silent = true, desc = "Stage Hunk" })
-- map("v", "<leader>gs", ":Gitsigns stage_hunk<cr>", { silent = true, desc = "Stage Hunk" })
-- map("n", "<leader>gg", ":Git<cr>", { silent = true })
--
-- map("n", "<leader>gz", ":Git<cr>", { silent = true, desc = "Git Status" })
-- map("n", "<leader>gc", ":Git commit<cr>", { silent = true, desc = "Git Commit" })
-- map("n", "<leader>gu", ":Gitsigns undo_stage_hunk<cr>", { silent = true, desc = "Stage Undo Hunk" })
-- map("n", "<leader>gf", ":Git fetch<cr>", { silent = true, desc = "Git Fetch" })
-- map("n", "[c", gitsigns_jump_prev_hunk, { silent = true, desc = "Next Hunk" })
-- map("n", "]c", gitsigns_jump_next_hunk, { silent = true, desc = "Prev Hunk" })
-- more git signs mapping here from NVCHAD : https://github.com/NvChad/NvChad/blob/2e54fce0281cee808c30ba309610abfcb69ee28a/lua/nvchad/configs/gitsigns.lua
-- map("n", "<leader>rh", gs.reset_hunk, opts "Reset Hunk")
-- map("n", "<leader>ph", gs.preview_hunk, opts "Preview Hunk")
-- map("n", "<leader>gb", gs.blame_line, opts "Blame Line")
map("n", "<leader>gbl", ":Gitsigns toggle_current_line_blame<cr>", { silent = true, desc = "Blame Inline Toggle" })
-- Gitsigns toggle_current_line_blame
map("n", "<leader>gbL", ":Git blame<cr>", { silent = true, desc = "Git Blame" })
map("n", "<leader>gbb", ":Git blame<cr>", { silent = true, desc = "Git Blame" })
-- Gitsigns diffthis
