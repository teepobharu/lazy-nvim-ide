local n = { 1, 2 }
-- __AUTO_GENERATED_PRINT_VAR_START__
print([==[ n:]==], vim.inspect(n)) -- __AUTO_GENERATED_PRINT_VAR_END__

print(123123)
print(n[2])

local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap
local function handleMode(mode)
  return function()
    if vim.fn.mode() == mode then
      vim.cmd("normal! y")
    else
      vim.cmd("normal! gv")
    end
  end
end

keymap("v", "v", handleMode("v"), opts)
keymap("v", "V", handleMode("V"), opts)
local keymap = vim.keymap.set
