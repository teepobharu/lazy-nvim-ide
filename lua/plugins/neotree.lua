-- editor.lua in Lazy override

return {

  -- file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    -- https://github.com/LazyVim/LazyVim/blob/b601ade71c7f8feacf62a762d4e81cf99c055ea7/lua/lazyvim/plugins/editor.lua
    opts = function(_, opts)
      table.insert(opts.filesystem.window.mappings, {
        ["<Esc>"] = "clear_filter",
        ["/"] = "none",
        ["f"] = "fuzzy_finder",
        ["F"] = "filter_on_submit",
      })

      table.insert(opts.filesystem.buffers.mappings, {
        ["x"] = "buffer_delete",
      })

      return opts
    end,
  },
}
