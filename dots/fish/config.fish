# Configure Dracula Theme
if status is-interactive
    fish_config theme choose "Dracula Official"
    set -U hydro_color_pwd $fish_color_param
    set -U hydro_color_git --dim $fish_color_escape
    set -U hydro_color_start $fish_color_comment
    set -U hydro_color_error $fish_color_error
    set -U hydro_color_prompt $fish_color_param
    set -U hydro_color_duration $fish_color_comment
    set -U fish_prompt_pwd_dir_length 0
    set -g fish_color_search_match
    set -g fish_pager_color_background
    set -g fish_pager_color_selected_background
end
