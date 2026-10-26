-- Arch-native equivalent of modules/programs/nvim.nix (an nvf config,
-- https://nvf.notashelf.dev/options.html). nvf is a NixOS module that
-- *generates* a full Neovim config from declarative options -- there's
-- no underlying dotfile to copy, so this tree reimplements the same
-- settings with plain lua + lazy.nvim (https://github.com/folke/lazy.nvim).
--
-- Package-manager-level nvf options (languages.*.enableFormat/enableDAP/
-- enableExtraDiagnostics) each wire up a specific formatter/DAP-adapter/
-- linter per language internally; those exact tool choices live inside
-- nvf itself and aren't visible from nvim.nix alone, so lua/plugins/*
-- below picks the standard/most common tool for each language instead
-- of guaranteeing a byte-for-byte match. See each plugin file's header
-- comment for specifics.

require("config.options")
require("config.keymaps")
require("config.lazy")
