-- languages.enableDAP from nvim.nix. Only go/python/C have common,
-- well-maintained nvim-dap adapters in the ecosystem; bash/json/lua/
-- markdown/nix/yaml have no meaningful debugger and are skipped.
return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"leoluz/nvim-dap-go",
			"mfussenegger/nvim-dap-python",
		},
		config = function()
			require("dapui").setup()
			require("dap-go").setup()
			require("dap-python").setup("python")

			local dap = require("dap")
			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = "codelldb",
					args = { "--port", "${port}" },
				},
			}
			dap.configurations.c = {
				{
					name = "Launch",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
				},
			}
			dap.configurations.cpp = dap.configurations.c
		end,
	},
}
