
return {
		"jvgrootveld/telescope-zoxide",
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			local t = require("telescope")
			local z_utils = require("telescope._extensions.zoxide.utils")
			-- Configure telescope-zoxide
			t.setup({
				extensions = {
					zoxide = {
						prompt_title = "Zoxide ~ CD",
						mappings = {
							default = {
								after_action = function(selection)
									print("Update to (" .. selection.z_score .. ") " .. selection.path)
								end,
							},
							["<C-s>"] = {
								before_action = function(selection)
									-- print("before C-s")
								end,
								action = function(selection)
									vim.cmd.edit(selection.path)
								end,
							},
							["<C-q>"] = {
								action = z_utils.create_basic_command("split"),
							},
						},
					},
				},
				-- https://github.com/jvgrootveld/telescope-zoxide?tab=readme-ov-file
			})
			-- t.load_extension("zoxide") -- please add inside telescope instead
			map("n", "<leader>cd", t.extensions.zoxide.list, { desc = "Telescope Zoxide" })
		end,
	},
