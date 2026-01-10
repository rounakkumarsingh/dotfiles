if set -q THEME_MODE
    if test "$THEME_MODE" = "light"
        set -gx BAT_THEME "rose-pine-dawn"
    else
        set -gx BAT_THEME "rose-pine"
    end
else
    set -gx BAT_THEME "rose-pine"
end
