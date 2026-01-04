if status is-interactive
    # Case 1: batcat exists, bat does NOT
    if command -q batcat; and not command -q bat
        function bat --wraps batcat
            batcat $argv
        end

        function cat --wraps cat
            batcat --paging=never $argv
        end

    # Case 2: bat exists (preferred)
    else if command -q bat
        function cat --wraps cat
            bat --paging=never $argv
        end
    end
end

