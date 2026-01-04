set -gx EDITOR nvim
set -gx VISUAL nvim

set -gx BROWSER firefox
set -gx TERM xterm-256color

if set -q THEME_MODE
    if test "$THEME_MODE" = "light"
        fish_config theme choose "Rosé Pine Dawn"
    else
        fish_config theme choose "Rosé Pine"
    end
else
    fish_config theme choose "Rosé Pine"
end

starship init fish | source
