return {
  "folke/noice.nvim",

  keys = {
    {
      "<leader>snx",
      function()
        require("noice").cmd("disable")
      end,
      desc = "Noice Disable",
    },
  },
}
