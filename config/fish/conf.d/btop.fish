if test -f /home/rounakkumarsingh/.config/btop/btop.conf
    set -l btop_config "/home/rounakkumarsingh/.config/btop/btop.conf"
    set -l theme_path "/home/rounakkumarsingh/.config/btop/themes"
    
    if set -q THEME_MODE
        if test "$THEME_MODE" = "light"
            sed -i "s|color_theme = .*|color_theme = \"$theme_path/rose-pine-dawn.theme\"|" $btop_config
        else
            sed -i "s|color_theme = .*|color_theme = \"$theme_path/rose-pine.theme\"|" $btop_config
        end
    else
        sed -i "s|color_theme = .*|color_theme = \"$theme_path/rose-pine.theme\"|" $btop_config
    end
end
