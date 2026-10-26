# Arch-native equivalent of modules/system/fish.nix.
# Place at ~/.config/fish/config.fish.
#
# Packages this config assumes are already installed (pacman/AUR as noted):
#   fish eza fzf zoxide vivid                  (pacman, core/extra)
#   fish-lsp babelfish                         (AUR)
#   fisher + plugins listed in ./fish_plugins  (see that file)
#
# Setting fish as your login shell is a system-level step, not a dotfile:
#   chsh -s /usr/bin/fish
#
# `programs.command-not-found.enable = false` on the Nix side just means
# "don't install pkgfile" -- nothing to replicate here; simply don't
# install/enable Arch's pkgfile hook.

if status is-interactive
    # man-cache disabling has no fish-side equivalent to port; it's a
    # NixOS build-time option (documentation.man.cache.enable), not
    # something fish itself does.

    # --- nix.nix's rebuildCommand doesn't apply outside NixOS; the
    # nrb/snowball/snowfall/etc. abbreviations below are dropped since
    # they all shell out to `nixos-rebuild`, which doesn't exist here.

    # --- abbreviations (fish's `abbr`, expand on space/enter) ---
    abbr -a ns 'nix shell nixpkgs#'
    abbr -a nr 'nix run nixpkgs#'
    abbr -a nb 'nix build nixpkgs#'

    abbr -a gaa 'git add --all'
    abbr -a ga 'git add'
    abbr -a gs 'git status'
    abbr -a gc 'git commit'
    abbr -a gcm 'git commit -m'
    abbr -a gck 'git checkout -b'
    abbr -a gp 'git push'
    abbr -a gpu 'git pull'
    abbr -a gsw 'git switch'
    abbr -a gca 'git commit --amend'
    abbr -a gcp 'git cherry-pick'
    abbr -a grsa 'git restore --staged .'
    abbr -a grs 'git restore --staged'
    abbr -a gr 'git restore'
    abbr -a gra 'git restore .'
    abbr -a gd 'git diff'
    abbr -a gds 'git diff --staged'
    abbr -a gl 'git log'

    abbr -a ts 'tailscale status'
    abbr -a te 'tailscale set --exit-node='
    abbr -a tek 'tailscale set --exit-node=kaolin'
    abbr -a teg 'tailscale set --exit-node=greenery'

    abbr -a n 'nvim'

    # --- aliases ---
    alias ls 'eza --icons --group-directories-first -1'
    alias lt 'eza -l -a --icons --group-directories-first -T'
    alias schizo 'ssh sumee@greenery'
    alias libre 'ssh sumee@kaolin'
    alias dream 'ssh sumee@verdure'
    alias prarie 'sudo borg create -s --progress /mnt/prarie::prarie-$(date) /run/media/sumee/emerald/'
    alias grass 'sudo borg create -s --progress /mnt/grass::grass-$(date) /var/lib/2fauth /var/lib/private/anki-sync-server /var/lib/davis /var/lib/hass /var/lib/postgresql'
    # snowball/snowfall/snowstorm/snowshed/deploy/remote all wrapped
    # `nixos-rebuild --flake ~/green# --elevate=sudo` -- no equivalent on
    # Arch, dropped along with the other nix-rebuild abbreviations above.

    # --- zoxide / fzf (nix: programs.zoxide.enable / programs.fzf.keybindings) ---
    zoxide init fish | source
    source /usr/share/fzf/key-bindings.fish

    # --- everything below is copied verbatim from fish.nix's
    # interactiveShellInit; it's plain fish script, no Nix in it other
    # than the vivid binary path, switched to a bare `vivid` on $PATH ---

    set sponge_purge_only_on_exit true
    set fish_greeting
    set fish_cursor_insert line blink

    # Environment Color Association
    set -Ux LS_COLORS (vivid generate rose-pine)
    set -Ux FZF_DEFAULT_OPTS --color=fg:#908caa --color=bg:-1 --color=hl:#ebbcba --color=fg+:#e0def4 --color=bg+:#26233a --color=hl+:#ebbcba --color=border:#403d52 --color=header:#31748f --color=gutter:#191724 --color=spinner:#f6c177 --color=info:#9ccfd8 --color=pointer:#c4a7e7 --color=marker:#eb6f92 --color=prompt:#908caa

    # Set theme (requires ./themes/Rosé Pine.theme, see that directory)
    fish_config theme choose "Rosé Pine"

    # Bindings
    function fish_user_key_bindings
        bind --mode insert alt-c 'cdi; commandline -f repaint'
        bind --mode insert alt-f 'fzf-file-widget'
    end

    # Overrides rose pine colors for transparency
    set -g fish_color_search_match
    set -g fish_pager_color_background
    set -g fish_pager_color_selected_background

    # hydro (prompt) stuff
    set -g hydro_symbol_start
    set -U hydro_symbol_git_dirty "*"
    set -U fish_prompt_pwd_dir_length 0
    set -U hydro_color_pwd $fish_color_pine
    set -U hydro_color_git $fish_color_foam
    set -U hydro_color_start $fish_color_iris
    set -U hydro_color_error $fish_color_love
    set -U hydro_color_prompt $fish_color_pine
    set -U hydro_color_duration $fish_color_iris
    function fish_mode_prompt; end;

    # Sets package in nix shell prompt -- harmless outside a nix shell,
    # `in_nix_shell` just stays empty and hydro_symbol_start is never set.
    set in_nix_shell "$(echo $PATH | awk '{i=1; while($i ~ /store/){ if($i !~ /(-man|-doc)\//){print $i} i++ }}' | cut -d'-' -f2- | rev | cut -d'-' -f2- | rev | tr '\n' ' ')"
    function update_nshell_indicator --on-variable in_nix_shell
        if test -n "$in_nix_shell";
            set -g hydro_symbol_start "$in_nix_shell"
        else
            set -g hydro_symbol_start
        end
    end
    update_nshell_indicator

    # smoll script to get the store path given an executable name --
    # harmless outside Nix, just never finds a /nix/store path to resolve.
    function store_path -a package_name
        which $package_name 2> /dev/null | path resolve | read -l package_path
        if test -n "$package_path"
            echo (path dirname $package_path | path dirname)
        end
    end
end
