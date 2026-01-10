# Watch for theme changes from WezTerm and reload shell if needed

function _theme_watcher --on-event fish_prompt
    set -l theme_file "$HOME/.cache/theme_mode"
    
    # Only proceed if the state file exists
    if test -f "$theme_file"
        set -l new_theme (string trim (cat "$theme_file"))
        
        # If THEME_MODE isn't set yet, just set it without reloading
        if not set -q THEME_MODE
            set -gx THEME_MODE "$new_theme"
            return
        end
        
        # If the theme has changed, update variable and reload shell
        if test -n "$new_theme"; and test "$new_theme" != "$THEME_MODE"
            set -gx THEME_MODE "$new_theme"
            # exec fish replaces the current process with a new one,
            # ensuring a completely clean state for the new theme.
            exec fish
        end
    end
end
