local Path = require("utils.path")

--- Open selected file in vertical split
local function open_selected_file_in_vertical()
  local entry = require("telescope.actions.state").get_selected_entry()
  require("telescope.actions").close(entry)
  vim.cmd("vsplit " .. entry.path)
end

local function find_files_from_project_git_root()
  local opts = {}
  if Path.is_git_repo() then
    opts = {
      cwd = Path.get_git_root(),
    }
  end
  require("telescope.builtin").find_files(opts)
end

local function live_grep_from_project_git_root()
  local opts = {}

  if Path.is_git_repo() then
    opts = {
      cwd = Path.get_git_root(),
    }
  end

  require("telescope.builtin").live_grep(opts)
end
-- Custom function to run fd command and get results
local function run_fd_command(cmd)
  local handle = io.popen(cmd)
  local result = handle:read("*a")
  handle:close()
  return vim.split(result, "\n")
end

local context_options = { "home", "shallow home + config", ".config deep" }
local current_index = 1

local function toggle_context(prompt_bufnr)
  local actions = require("telescope.actions")

  -- cycle between options
  current_index = current_index % #context_options + 1
  current_context = context_options[current_index]

  -- close the current picker
  actions.close(prompt_bufnr)

  -- re-run the picker with the new context
  find_files_in_home_and_config()
end

-- custom picker function
function find_files_in_home_and_config()
  local commands_option = {
    "fd --type f --hidden --max-depth 1 . ~",
    "fd --type f --max-depth 1 . ~ ~/.config ",
    "fd --type f --max-depth 14 . ~/.config -E '*.xml' -E 'coc/*' -E 'raycast' -E 'neovim' -E 'nvim' -E 'alfred' -E 'karabiner/automatic_backups'",
  }

  local finders = require("telescope.finders")
  local pickers = require("telescope.pickers")
  local previewers = require("telescope.previewers")
  local conf = require("telescope.config").values
  local all_files = {}

  all_files = run_fd_command(commands_option[current_index])
  -- all_files = run_fd_command("fd --type f --max-depth 2 . ~/.config")
  -- all_files = run_fd_command("fd --type f --max-depth 14 . ~/.config -E '*.xml' -E 'coc/*' -E 'raycast' -E 'neovim' -E 'nvim' -E 'alfred' -E 'karabiner/automatic_backups'")
  -- end

  -- Sort the combined list of files alphabetically
  table.sort(all_files)

  pickers
    .new({}, {
      prompt_title = "["
        .. current_index
        .. "/"
        .. #context_options
        .. "]"
        .. " Find config in . . . "
        .. context_options[current_index],
      finder = finders.new_table({
        results = all_files,
      }),
      previewer = previewers.cat.new({}),

      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr, map)
        -- Bind Ctrl-Space to toggle the search context
        map({ "i", "n" }, "<C-Space>", function()
          toggle_context(prompt_bufnr)
        end)
        return true
      end,
    })
    :find()
end

function find_dot_config_files()
  -- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#having-a-factory-like-function-based-on-a-dict - configure factory like dict differenet find cmds
  -- if current path is ~ only limit to depth = 1  with prompt = find HOME files include hidden files and folders
  -- if vim.fn.getcwd() == vim.fn.expand("~") then
  -- check if path is not inside ~/.config
  -- if not then find files in ~ and .config
  if vim.fn.getcwd() ~= vim.fn.expand("~/.config") then
    require("telescope.builtin").find_files({
      prompt_title = "Find $HOME and .config files",
      cwd = "~",
      find_command = { "fd", "--type", "f", "--hidden", "--max-depth", "1" },
      -- fd -H -d 1 -t d . ~ ~/.config
      search_dirs = { "~", ".config" },

      -- find_command = { "fd", "--type", "f", "--hidden", "--max-depth", "1", ".", "~", ".config" },
      -- # generate fd command to find in both dir ~ and ~/.config with max depth 1
    })
    return
  end
  require("telescope.builtin").find_files({ prompt_title = "Find .Config files", cwd = "~/.config" })
end
vim.api.nvim_create_user_command("FindConfig", find_dot_config_files, {})

local session_pickers = function()
  local finders = require("telescope.finders")
  local pickers = require("telescope.pickers")
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local opts = {}

  local session_dir = vim.g.startify_session_dir or "~/.config/session"
  -- Logic to handle session previews using the session directory
  -- You can customize this to display session information or previews
  -- Example: Display session files in the specified directory
  local results = {}
  --
  -- for file in io.popen('ls ' .. session_dir):lines() do
  -- find to format output as filename only not the full path
  --p[[:alnum:]_].*find $(pwd) -name '
  --for more format see man re_format
  for file in
    io.popen(
      "find " .. session_dir .. ' -maxdepth 1 -type f -name "[[:alpha:][:digit:]][[:alnum:]_]*" -exec basename {} +'
    )
      :lines()
  do
    -- file that starts with alpahnumerical
    table.insert(results, { value = file })
  end

  -- add key map for loadding with SLoad when press C-enter
  -- actions.select_default:replace(function(prompt_bufnr)
  --  local entry = actions.get_selected_entry(prompt_bufnr)
  --  if entry this_offset_encoding
  --

  -- Return the results for display in Telescope
  return pickers
    .new(opts, {
      prompt_title = "Startify Sessions",
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()

          if selection then
            vim.cmd("SLoad " .. selection.value)
          end
        end)
        map("i", "<C-CR>", function(_prompt_bufnr)
          local entry = action_state.get_selected_entry()
          if entry then
            vim.cmd("SLoad " .. entry.value)
          end
        end)

        local saveSession = function(_prompt_bufnr)
          local picker = action_state.get_current_picker(_prompt_bufnr)
          local firstMultiSelection = picker:get_multi_selection()[1]

          local current_line = action_state.get_current_line()
          -- trim right the current_line
          current_line = current_line:gsub("%s+$", "")

          local session_name = firstMultiselection or current_line

          if firstMultiSelection then
            print("Save session from first multi selected " .. firstMultiSelection.value)
          else
            print("Save session from input prompt .. " .. current_line)
          end

          if current_line ~= "" then
            vim.cmd("SSave! " .. session_name)
          end
        end

        map("i", "<C-s>", function()
          saveSession(prompt_bufnr)
        end)
        map("n", "<C-s>", function()
          saveSession(prompt_bufnr)
        end)
        map("n", "X", function()
          local entry = action_state.get_selected_entry()
          -- confirming

          local user_input = vim.fn.confirm("Confirm Delete Session" .. entry.value, "yesno", 2)
          if user_input == 1 then
            vim.cmd("SDelete! " .. entry.value)
            -- local picker = action_state.get_current_picker(_prompt_bufnr)
            -- picker.refresh()
          end
        end)

        --- end ---
        return true
      end,
      finder = finders.new_table({
        results = results,
        entry_maker = function(entry)
          return {
            display = entry.value,
            value = entry.value,
            ordinal = entry.value,
          }
        end,
      }),
      sorter = require("telescope.config").values.generic_sorter(opts),
      -- })
    })
    :find()
  -- return require("telescope").register_extension{
  --   exports = { startify = session_picker }
  -- }
end

return {
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        prompt_prefix = "   ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
            results_width = 0.8,
          },
          vertical = {
            mirror = false,
          },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },
        path_display = { "truncate" },
        mappings = {
          i = {
            -- ["C-v"] = open_selected_file_in_vertical,
            ["<C-p>"] = require("telescope.actions.layout").toggle_preview,
          },
          n = {
            ["X"] = require("telescope.actions").delete_buffer,
            ["<C-p>"] = require("telescope.actions.layout").toggle_preview,
          },
        },
      },
    },
    keys = {
      -- add <leader>fa to find all, including hidden files
      {
        "<leader>sc",
        "<cmd> Telescope command_history <CR>",
        mode = "v",
        desc = "Command History",
      },
      {
        "<leader>fa",
        "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>",
        desc = "Find All Files (including hidden)",
      },
      -- add <leader>fl to live grep from git root
      {
        "<leader>fl",
        function()
          live_grep_from_project_git_root()
        end,
        desc = "Live Grep From Project Git Root",
      },
      -- add <leader>fg to find files from project git root
      {
        "<leader>fg",
        function()
          find_files_from_project_git_root()
        end,
        desc = "Find Files From Project Git Root",
      },
      -- {
      --   "<leader>fz",
      --   find_dot_config_files,
      --   desc = "Find my dotconfig files",
      -- },
      {
        "<leader>fz",
        find_files_in_home_and_config,
        desc = "Find my dotconfig files in home and config",
      },
      {
        "<leader>fs",
        session_pickers,
        desc = "Find Sesssions",
      },
    },
  },
}
