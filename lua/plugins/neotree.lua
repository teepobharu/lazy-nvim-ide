-- editor.lua in Lazy override

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
        filesystem = {
          window = {
            width = 30,
            mappings = {
              ["<Esc>"] = "clear_filter",
              ["/"] = "none",
              ["f"] = "fuzzy_finder",
              ["F"] = "filter_on_submit",
            },
          },
          buffers = {
            window = {
              mappings = {
                ["X"] = "buffer_delete",
              },
            },
          },
        },
      })
      return opts
    end,
  },
}
