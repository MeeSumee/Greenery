-- vim.syntaxHighlighting, viAlias, vimAlias, options.shiftwidth,
-- undoFile.enable from nvim.nix's vim.* settings.
vim.cmd("syntax on")
-- viAlias/vimAlias just mean `vi`/`vim` on $PATH also launch nvim --
-- that's a shell-alias/package concern, not an in-editor option. On
-- Arch: `alias vi=nvim` / `alias vim=nvim` (see dots/fish/config.fish).

vim.opt.shiftwidth = 2
vim.opt.undofile = true

-- diagnostics.config.virtual_lines = true
vim.diagnostic.config({ virtual_lines = true })

vim.g.mapleader = " "
