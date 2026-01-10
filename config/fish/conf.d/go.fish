# Go toolchain
fish_add_path /usr/local/go/bin

# User-installed Go binaries (modern default)
fish_add_path $HOME/go/bin

# GOPATH (only if go exists)
if command -q go
    set -l gopath (go env GOPATH 2>/dev/null)
    if test -n "$gopath"
        fish_add_path $gopath/bin
    end
end
