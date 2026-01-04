function tmpcd_cleanup --on-event fish_exit
    if set -q __tmpcd_dir
        rm -rf $__tmpcd_dir
    end
end

function tmpcd_cleanup_start
    if test (count $argv) -gt 0
        set -g __tmpcd_dir (mktemp -d (or $TMPDIR /tmp)/$argv[1].XXXXXXXXXX)
    else
        set -g __tmpcd_dir (mktemp -d)
    end

    or begin
        echo "mktemp failed" >&2
        return 1
    end

    printf "%s\t%s\n" (date --iso-8601=seconds ^/dev/null; or date) $__tmpcd_dir
    cd $__tmpcd_dir
    pwd
end
