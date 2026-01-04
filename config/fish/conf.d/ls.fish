if command -q eza
    alias ls 'eza --icons --long --group-directories-first --git'
    alias lt 'eza --tree --icons --git --group-directories-first --level=2'
else if command -q exa
    alias ls 'exa --icons --long --group-directories-first --git'
    alias lt 'exa --tree --icons --git --group-directories-first --level=2'
end

