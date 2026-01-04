#!/usr/bin/env fish

set cache_file "/tmp/system-theme-cache"
set cache_max_age 5  # seconds

# Check if cache exists and is fresh
if test -f $cache_file
    set cache_age (math (date +%s) - (stat -c %Y $cache_file 2>/dev/null; or stat -f %m $cache_file 2>/dev/null; or echo 0))
    if test $cache_age -lt $cache_max_age
        # Cache is fresh, return it
        /usr/bin/cat $cache_file
        exit 0
    end
end

# Cache is stale or doesn't exist, query registry
if test -f /proc/version; and grep -qi microsoft /proc/version
    set theme_value (reg.exe query "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v AppsUseLightTheme 2>/dev/null | string match -r "0x[0-9]" | string replace "0x" "")

    if test -n "$theme_value"
        if test "$theme_value" = "1"
            set result "light"
        else
            set result "dark"
        end
    else
        set result "dark"
    end
else
    set result "dark"
end

# Write to cache and output
echo $result | tee $cache_file
