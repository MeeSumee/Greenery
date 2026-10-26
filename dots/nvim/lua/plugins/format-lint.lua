-- languages.enableFormat + lsp.formatOnSave, and languages.enableExtraDiagnostics
-- from nvim.nix. Formatter/linter-per-language picks below are the
-- standard tool for each language, not guaranteed to match nvf's exact
-- internal choice. Install the underlying CLI tools separately (AUR/pacman):
--   shfmt shellcheck clang-format gofmt(part of go) jq stylua
--   nixpkgs-fmt-or-alejandra statix prettier(markdown) ruff
return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			formatters_by_ft = {
				sh = { "shfmt" },
				bash = { "shfmt" },
				c = { "clang-format" },
				cpp = { "clang-format" },
				go = { "gofmt" },
				json = { "jq" },
				lua = { "stylua" },
				markdown = { "prettier" },
				nix = { "alejandra" },
				python = { "ruff_format" },
				yaml = { "prettier" },
			},
			format_on_save = { timeout_ms = 2000, lsp_fallback = true },
		},
	},

	{
		"mfussenegger/nvim-lint",
		event = { "BufWritePost", "BufReadPost", "InsertLeave" },
		config = function()
			require("lint").linters_by_ft = {
				sh = { "shellcheck" },
				bash = { "shellcheck" },
				go = { "staticcheck" },
				nix = { "statix" },
				python = { "ruff" },
				yaml = { "yamllint" },
			}
			vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
				callback = function()
					require("lint").try_lint()
				end,
			})
		end,
	},
}
