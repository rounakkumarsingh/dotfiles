function tmpcd
    if test (count $argv) -gt 0
        set dir (mktemp -d (or $TMPDIR /tmp)/$argv[1].XXXXXXXXXX)
    else
        set dir (mktemp -d)
    end

    or begin
        echo "mktemp failed" >&2
        return 1
    end

    printf "%s\t%s\n" (date --iso-8601=seconds ^/dev/null; or date) $dir
    cd $dir
    pwd
end
