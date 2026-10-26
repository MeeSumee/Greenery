-- lsp.enable/formatOnSave + autocomplete.nvim-cmp + the languages.*.enable
-- block from nvim.nix. nvf wires up a specific LSP server per enabled
-- language internally; the mapping below (one lspconfig server per
-- language) is the standard choice for each, not necessarily nvf's exact
-- internal pick:
--   bash -> bashls, clang -> clangd, go -> gopls, json -> jsonls,
--   lua -> lua_ls, markdown -> marksman, nix -> nixd, python -> pyright,
--   yaml -> yamlls
-- formatOnSave is handled by conform.nvim instead -- see format-lint.lua.
return {
	{
		"williamboman/mason.nvim",
		opts = {},
	},

	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		opts = {
			ensure_installed = {
				"bashls",
				"clangd",
				"gopls",
				"jsonls",
				"lua_ls",
				"marksman",
				"nixd",
				"pyright",
				"yamlls",
			},
		},
	},

	{
		"neovim/nvim-lspconfig",
		dependencies = { "mason-lspconfig.nvim", "hrsh7th/cmp-nvim-lsp" },
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local servers = {
				"bashls",
				"clangd",
				"gopls",
				"jsonls",
				"lua_ls",
				"marksman",
				"nixd",
				"pyright",
				"yamlls",
			}
			for _, server in ipairs(servers) do
				require("lspconfig")[server].setup({ capabilities = capabilities })
			end
		end,
	},

	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
					{ name = "path" },
				}),
			})
		end,
	},
}
