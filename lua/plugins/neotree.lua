-- editor.lua in Lazy override
-- setup examples
-- open spectre search and live grep telescope : https://www.reddit.com/r/neovim/comments/17o6g2n/comment/k7wf2wp/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button

local Util = require("lazyvim.util")
return {

  -- file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    -- https://github.com/LazyVim/LazyVim/blob/b601ade71c7f8feacf62a762d4e81cf99c055ea7/lua/lazyvim/plugins/editor.lua
    -- original config: https://github.com/nvim-neo-tree/neo-tree.nvim?tab=readme-ov-file#quickstart
    opts = function(_, opts)
      -- use function to merge config (behiovr = force/override  )
      Util.merge(opts, {
        commands = {
          copy_selector = function(state)
            local node = state.tree:get_node()
            local filepath = node:get_id()
            local filename = node.name
            local modify = vim.fn.fnamemodify

            local results = {
              filepath,
              modify(filepath, ":."),
              modify(filepath, ":~"),
              filename,
              modify(filename, ":r"),
              modify(filename, ":e"),
            }

            vim.ui.select({
              "1. Absolute path: " .. results[1],
              "2. Path relative to CWD: " .. results[2],
              "3. Path relative to HOME: " .. results[3],
              "4. Filename: " .. results[4],
              "5. Filename without extension: " .. results[5],
              "6. Extension of the filename: " .. results[6],
            }, { prompt = "Choose to copy to clipboard:" }, function(choice)
              if choice then
                local i = tonumber(choice:sub(1, 1))
                if i then
                  local result = results[i]
                  vim.fn.setreg('"', result)
                  vim.notify("Copied: " .. result)
                else
                  vim.notify("Invalid selection")
                end
              else
                vim.notify("Selection cancelled")
              end
            end)
          end,
          copy_file_name_current = function(state)
            local node = state.tree:get_node()
            local filename = node.name
            vim.fn.setreg('"', filename)
            vim.notify("Copied: " .. filename)
          end,
          copy_abs_file = function(state)
            local node = state.tree:get_node()
            local filepath = node:get_id()
            vim.fn.setreg('"', filepath)
            vim.notify("Copied: " .. filepath)
          end,
        },
        -- https://github.com/nvim-neo-tree/neo-tree.nvim/discussions/370
        filesystem = {
          window = {
            width = 30,
            mappings = {
              ["<Esc>"] = "clear_filter",
              ["/"] = "none",
              ["f"] = "fuzzy_finder",
              ["F"] = "filter_on_submit",
              ["<tab>"] = "toggle_node",
              ["YY"] = "copy_selector",
              ["Yp"] = "copy_file_name_current",
              ["YP"] = "copy_abs_file",
            },
          },
        },
        buffers = {
          window = {
            mappings = {
              ["X"] = "buffer_delete",
            },
          },
        },
      })
      return opts
    end,
  },
}
