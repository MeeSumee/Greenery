-- treesitter.enable + languages.enableTreesitter from nvim.nix. Parser
-- list mirrors the languages.* block enabled there (bash, clang, go,
-- json, lua, markdown, nix, python, yaml).
return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"cpp",
				"go",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"nix",
				"python",
				"yaml",
				"vim",
				"vimdoc",
			},
			highlight = { enable = true },
			indent = { enable = true },
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
}
