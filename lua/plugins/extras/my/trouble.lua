return {
  {
    "folke/trouble.nvim",
    -- see class from help or web / lazynvim :  https://www.lazyvim.org/extras/editor/trouble-v3#troublenvim
    ---@class trouble.Config
    opts = {
      keys = {
        go = { -- example of a custom action that toggles the active view filter
          action = function(view)
            view:filter({ buf = 0 }, { toggle = true })
          end,
          desc = "Toggle Current Buffer Filter",
        },
        s = { -- example of a custom action that toggles the severity
          action = function(view)
            local f = view:get_filter("severity")
            local severity = ((f and f.filter.severity or 0) + 1) % 5
            view:filter({ severity = severity }, {
              id = "severity",
              template = "{hl:Title}Filter:{hl} {severity}",
              del = severity == 0,
            })
          end,
          desc = "Toggle Severity Filter",
        },
      },
    },
  },
}
