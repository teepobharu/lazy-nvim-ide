local M = {}

M.treesitter = {
  ensure_installed = {
    "vim",
    "lua",
    "html",
    "css",
    "javascript",
    "typescript",
    "tsx",
    "c",
    "markdown",
    "markdown_inline",
    "python",
  },
  indent = {
    enable = true,
    -- disable = {
    --   "python"
    -- },
  },
}

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
}

M.telescope = {
  getOptions = function()
    local function copy_displayed_file_path(prompt_bufnr)
      local selection = require("telescope.actions.state").get_selected_entry()
      local file_path = selection.value
      -- print(vim.inspect(selection))
      vim.fn.setreg("+", file_path)
      print("Copied displayed file path: " .. file_path)
    end

    return {
      pickers = {
        find_files = {
          mappings = {
            n = {
              -- does not work not sure
              -- ref example recipe
              -- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#file-and-text-search-in-hidden-files-and-directories
              -- source code
              -- https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/mappings.lua#L97
            },
          },
        },
      },

      -- extensions = {
      -- 	zoxide = {
      -- 		prompt_title = "[ Walking on the shoulders of TJ ]",
      -- 		mappings = {
      -- 			default = {
      -- 				after_action = function(selection)
      -- 					print("Update to (" .. selection.z_score .. ") " .. selection.path)
      -- 				end,
      -- 			},
      -- 			["<C-s>"] = {
      -- 				before_action = function(selection)
      -- 					print("before C-s")
      -- 				end,
      -- 				action = function(selection)
      -- 					vim.cmd.edit(selection.path)
      -- 				end,
      -- 			},
      -- 			["<C-q>"] = { action = z_utils.create_basic_command("split") },
      -- 		},
      -- 	},
      -- },
      -- https://github.com/nvim-telescope/telescope.nvim#default-mappings
      --

      mappings = {
        -- to get desc (extract from object ?): https://github.com/nvim-telescope/telescope.nvim/blob/dc192faceb2db64231ead71539761e055df66d73/lua/telescope/mappings.lua#L208
        i = {
          ["<C-k>"] = function(...)
            require("telescope.actions").results_scrolling_down(...)
            -- require("telescope.actions").move_selection_previous(...)
          end,
          ["<C-j>"] = function(...)
            require("telescope.actions").results_scrolling_up(...)
            -- require("telescope.actions").move_selection_next(...)
          end,
          ["<C-h>"] = function(...)
            require("telescope.actions").results_scrolling_left(...)
          end,
          ["<C-l>"] = function(...)
            require("telescope.actions").results_scrolling_right(...)
          end,
          -- ["<C-d>"] = require("telescope.actions").results_scrolling_down,
          -- ["<C-u>"] = require("telescope.actions").results_scrolling_up,
          ["<C-u>"] = false,
          ["<C-p>"] = require("telescope.actions.layout").toggle_preview,
          -- alt + c : command not usable ?
          ["<M-c>"] = function(...)
            copy_displayed_file_path(...)
          end,
          -- ['<c-d>'] = require('telescope.actions').delete_buffer,
        },
        -- When the search text is focused
        n = {
          -- name appear when hit ? but not exectuable
          -- ["<esc>"] = mappingFunction.close_preview,
          -- ["cd"] = mappingFunction.lcd_preview,
          ["X"] = require("telescope.actions").delete_buffer,
          ["J"] = require("telescope.actions").results_scrolling_down,
          ["K"] = require("telescope.actions").results_scrolling_up,

          -- ["<C-d>"] = require("telescope.actions").results_scrolling_down,
          -- ["<C-u>"] = require("telescope.actions").results_scrolling_up,

          -- See default mappings / fn name here: https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/mappings.lua#L154
          ["<C-k>"] = function(...)
            require("telescope.actions").move_selection_previous(...)
          end,
          ["<C-j>"] = function(...)
            require("telescope.actions").move_selection_next(...)
          end,
          ["<C-h>"] = function(...)
            require("telescope.actions").results_scrolling_left(...)
          end,
          ["<C-l>"] = function(...)
            require("telescope.actions").results_scrolling_right(...)
          end,
          ["<esc>"] = function(...)
            require("telescope.actions").close(...)
          end,
          ["cd"] = function(prompt_bufnr)
            local selection = require("telescope.actions.state").get_selected_entry()
            local dir = vim.fn.fnamemodify(selection.path, ":p:h")
            -- require("telescope.actions").close(prompt_bufnr)

            -- print("lcd to " .. dir)
            -- Depending on what you want put `cd`, `lcd`, `tcd`
            vim.cmd(string.format("silent lcd %s", dir))
          end,
        },
      },
    }
  end,
}

return M
