function sentSelectedToTerminal()
  local mode = vim.fn.mode()
  if mode == "V" then
    -- print("in V mode")
    require("toggleterm").send_lines_to_terminal("visual_lines", true, { args = vim.v.count })
  elseif mode == "\22" then -- "\22" is the ASCII representation for CTRL-V
    -- print("in ^V mode")
    require("toggleterm").send_lines_to_terminal("visual_selection", true, { args = vim.v.count })
  elseif mode == "v" then
    -- print("in v mode")
    require("toggleterm").send_lines_to_terminal("visual_selection", true, { args = vim.v.count })
  else
    -- print("other " .. mode)
    require("toggleterm").send_lines_to_terminal("visual_lines", true, { args = vim.v.count })
  end
end

return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      size = 20,
      open_mapping = [[<c-_>]],
      dir = "git_dir",
      hide_numbers = true,
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      close_on_exit = true,
      shell = vim.o.shell,
    },
    keys = {
      {
        "<c-_>",
        desc = "Toggle term",
      },
      -- https://github.com/akinsho/toggleterm.nvim?tab=readme-ov-file#custom-terminal-usage
      -- {
      --   "<localleader>tn",
      --   function()
      --     local Terminal = require("toggleterm.terminal").Terminal
      --     Terminal:new({ dir = vim.fn.expand("%:p:h") })
      --     Terminal:toggle()
      --     --  dir = "git_dir",
      --   end,
      --   desc = "Open new terminal in current file directory",
      -- },
      -- Send to terminal
      {
        "<leader><c-_>",
        "<cmd>:ToggleTermSendCurrentLine<cr>",
        desc = "Send current line to terminal",
      },
      {
        -- "<leader><c-_>",
        "<localleader>ta",
        function()
          set_opfunc(function(motion_type)
            require("toggleterm").send_lines_to_terminal(motion_type, false, { args = vim.v.count })
          end)
          vim.api.nvim_feedkeys("ggg@G''", "n", false)
        end,
        desc = "Send visual selection to terminal",
      },
      {
        "<localleader>t",
        sentSelectedToTerminal,
        desc = "Send visual selection to terminal",
        mode = "v",
      },
      {
        "<localleader>t",
        sentSelectedToTerminal,
        desc = "Send visual selection to terminal",
      },
      {
        "<localleader>tf",
        "<cmd>:ToggleTerm direction=float<cr>",
        desc = "Toggle term Float",
      },
      {
        "<localleader>th",
        "<cmd>:ToggleTerm direction=horizontal<cr>",
        desc = "Toggle term Horiz",
      },
      {
        "<localleader>tv",
        "<cmd>:ToggleTerm direction=vertical<cr>",
        desc = "Toggle term vertical",
      },
    },
  },
}
