-- editor.lua in Lazy override
-- setup examples
-- open spectre search and live grep telescope : https://www.reddit.com/r/neovim/comments/17o6g2n/comment/k7wf2wp/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button

local Util = require("lazy.core.util")
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
                  vim.notify("Copied: " .. result .. " to vim clipboard")
                else
                  vim.notify("Invalid selection")
                end
              else
                vim.fn.setreg('"', results[4])
                vim.notify("Copied: " .. results[4] .. " to vim clipbard by default")
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
          telescope_livegrep_cwd = function(state)
            local node = state.tree:get_node()
            local filepath = node:get_id()
            local cwdPath = vim.fn.fnamemodify(filepath, ":h")
            local extra_opts = node.type == "file" and { "-d=1" } or {}
            require("telescope.builtin").live_grep({ cwd = cwdPath, additional_args = extra_opts })
          end,
          telescope_find_files = function(state)
            local node = state.tree:get_node()
            local filepath = node:get_id()
            local cwdPath = vim.fn.fnamemodify(filepath, ":h")
            local extra_opts = node.type == "file" and { "-d=1" } or {}
            require("telescope.builtin").find_files({ cwd = cwdPath, opts = extra_opts })
          end,
          telescope_cd = function(state)
            local node = state.tree:get_node()
            local filepath = node:get_id()
            local cwdPath = vim.fn.fnamemodify(filepath, ":h")
            vim.notify("Changing directory to: " .. cwdPath)
            vim.cmd("cd " .. cwdPath)
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
              -- custom binding
              ["YY"] = "copy_selector",
              ["Yp"] = "copy_file_name_current",
              ["YP"] = "copy_abs_file",
              ["Tg"] = "telescope_livegrep_cwd",
              ["Tf"] = "telescope_find_files",
              -- git copied from git mapping
              -- https://github.com/nvim-neo-tree/neo-tree.nvim/blob/main/README.md#L302
              ["gu"] = "git_unstage_file",
              ["ga"] = "git_add_file",
              ["gr"] = "git_revert_file",
              ["gc"] = "git_commit",
              ["Tc"] = "telescope_cd",
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
