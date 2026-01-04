fish_add_path /usr/local/go/bin
fish_add_path $HOME/go/bin

if command -q go
    fish_add_path (go env GOPATH)/bin
end

