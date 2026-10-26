-- Top-level keymaps.keymaps entry from nvim.nix.
vim.keymap.set("n", "<A-o>", function()
	require("oil").toggle_float()
end, { silent = true })

-- Rest of the leader keymaps (trouble, telescope git pickers, bufferline)
-- are set from each plugin's own lazy.nvim `keys` spec in lua/plugins/,
-- matching where nvf itself wires them up (per-module `mappings`).
