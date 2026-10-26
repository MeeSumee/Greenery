-- theme (catppuccin/mocha/transparent), statusline.lualine, tabline.nvimBufferline,
-- utility.trouble-nvim, git.enable (gitsigns) from nvim.nix.
return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			flavour = "mocha",
			transparent_background = true,
		},
		config = function(_, opts)
			require("catppuccin").setup(opts)
			vim.cmd.colorscheme("catppuccin")
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = { theme = "auto" },
		},
	},

	{
		"akinsho/bufferline.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				diagnostics = false,
				indicator = { style = "none" },
				show_close_icon = false,
				show_buffer_close_icons = false,
				numbers = "none",
			},
		},
		keys = {
			{ "<leader>x", "<Cmd>bdelete<CR>", desc = "Close current buffer" },
			{ "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
			{ "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Previous buffer" },
		},
	},

	{
		"lewis6991/gitsigns.nvim",
		opts = {},
	},

	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
		keys = {
			{ "<leader>lx", "<Cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics (loclist)" },
			{ "<leader>lq", "<Cmd>Trouble qflist toggle<CR>", desc = "Quickfix" },
			{ "<leader>ly", "<Cmd>Trouble symbols toggle<CR>", desc = "Symbols" },
		},
	},

	{
		"kosayoda/nvim-lightbulb",
		event = "LspAttach",
		opts = { autocmd = { enabled = true } },
	},
}
