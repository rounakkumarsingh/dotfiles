if command -q gemini
    set -l settings_file "/home/rounakkumarsingh/.gemini/settings.json"
    if set -q THEME_MODE
        set -l theme "rose-pine"
        if test "$THEME_MODE" = "light"
            set theme "rose-pine-dawn"
        end
        
        set -l tmp_file (mktemp)
        if jq --arg theme "$theme" '.ui.theme = $theme' "$settings_file" > "$tmp_file"
            mv "$tmp_file" "$settings_file"
        else
            rm "$tmp_file"
        end
    else
        set -l tmp_file (mktemp)
        if jq '.ui.theme = "rose-pine"' "$settings_file" > "$tmp_file"
            mv "$tmp_file" "$settings_file"
        else
            rm "$tmp_file"
        end
    end
end
