if status is-interactive
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
    alias l 'eza -l -a --icons --group-directories-first'
    alias ls 'eza --icons --group-directories-first -1'
    alias lt 'eza -l -a --icons --group-directories-first -T'
    alias schizo 'ssh sumee@greenery'
    alias libre 'ssh sumee@kaolin'
    alias dream 'ssh sumee@verdure'
    alias prarie 'sudo borg create -s --progress /mnt/prarie::prarie-$(date) /run/media/sumee/emerald/'
    alias grass 'sudo borg create -s --progress /mnt/grass::grass-$(date) /var/lib/2fauth /var/lib/private/anki-sync-server /var/lib/davis /var/lib/hass /var/lib/postgresql'

    # --- zoxide / fzf (nix: programs.zoxide.enable / programs.fzf.keybindings) ---
    zoxide init fish | source
    fzf --fish | source

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
end
