local function printVariables()
  local n = { 1, 2 }
  print([==[ n:]==], vim.inspect(n))
  print(123123)
  print(n[2])

  local current_file_path = vim.fn.expand("%:p")
  print([==[ current_file_path:]==], vim.inspect(current_file_path))
  local current_dir = vim.fn.expand("%:p:h")
  print([==[ current_dir:]==], vim.inspect(current_dir))

  fname = vim.fn.expand("%:p")
  print("dir from filename: " .. fname .. "  dir=" .. vim.fn.fnamemodify(fname, ":h"))
end

-- local keymap = vim.api.nvim_set_keymap
local function handleMode(mode)
  return function()
    if vim.fn.mode() == mode then
      vim.cmd("normal! y")
    else
      vim.cmd("normal! gv")
    end
  end
end

local function testKeyMap()
  local opts = { noremap = true, silent = true }
  local keymap = vim.keymap.set
  keymap("v", "v", handleMode("v"), opts)
  keymap("v", "V", handleMode("V"), opts)
end

local function checkLspClients()
  local lspconfig = require("lspconfig")
  local lspclient_f = lspconfig.util.get_lsp_clients({ name = "typescript-tools" })
  local lspclient_f2 = lspconfig.util.get_lsp_clients({ name = "denols" })
  local lspclient_ft = lspconfig.util.get_active_clients_list_by_ft("typescript")
  print([==[ lspclient_ft:]==], vim.inspect(lspclient_ft))
  print([==[ lspclient:]==], vim.inspect(lspclient_f))
  print([==[ lspclient:]==], vim.inspect(lspclient_f2))
end

local function main()
  printVariables()
  checkLspClients()
  testKeyMap()
  return nil
end

main()
