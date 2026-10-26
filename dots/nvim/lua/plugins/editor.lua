-- autopairs.nvim-autopairs, binds.whichKey, visuals.indent-blankline,
-- utility.oil-nvim, telescope from nvim.nix.
return {
	{ "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },

	{ "folke/which-key.nvim", event = "VeryLazy", opts = {} },

	{ "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },

	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			delete_to_trash = true,
			skip_confirm_for_simple_edits = true,
			prompt_save_on_select_new_entry = true,
			use_default_keymaps = false,
			keymaps = {
				["?"] = { "actions.show_help", mode = "n" },
				["<CR>"] = { "actions.select", mode = { "n", "v" } },
				["<BS>"] = { "actions.parent", mode = "n" },
				["."] = "actions.toggle_hidden",
				["t"] = "actions.toggle_trash",
				["q"] = "actions.close",
				["<Tab>"] = "actions.open_cwd",
				["`"] = "actions.cd",
				["<S-CR>"] = { "actions.open_external", mode = "n" },
			},
		},
	},

	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			defaults = {
				pickers = { find_command = { "fd", "-H" } },
			},
			pickers = {
				find_files = { find_command = { "fd", "--type=file", "-H" } },
			},
		},
		keys = {
			{ "<leader>gb", "<Cmd>Telescope git_branches<CR>", desc = "Git branches" },
			{ "<leader>gbc", "<Cmd>Telescope git_bcommits<CR>", desc = "Git buffer commits" },
			{ "<leader>gc", "<Cmd>Telescope git_commits<CR>", desc = "Git commits" },
			{ "<leader>gf", "<Cmd>Telescope git_files<CR>", desc = "Git files" },
			{ "<leader>gx", "<Cmd>Telescope git_stash<CR>", desc = "Git stash" },
			{ "<leader>gs", "<Cmd>Telescope git_status<CR>", desc = "Git status" },
		},
	},
}
