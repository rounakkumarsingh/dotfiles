function __bun_print_package_scripts
    set -l cwd "."
    for i in (seq (count $argv))
        if test "$argv[$i]" = "--cwd"
            set cwd "$argv[(math $i + 1)]"
            break
        end
    end

    if test -f "$cwd/package.json"
        string match -r '"scripts"\s*:\s*\{([^}]*)\}' (cat "$cwd/package.json") | string replace -r '^\s*"' '' | string replace -r '"\s*:\s*".*' '' | string trim
    end
end

complete -c bun -f

complete -c bun -n __fish_use_subcommand -a "dev bun create run install add remove upgrade completions discord help init pm x test repl update outdated link unlink build" -d "Subcommand"

complete -c bun -n "__fish_seen_subcommand_from dev" -l use -l cwd -l bunfile -l server-bunfile -l config -l disable-react-fast-refresh -l disable-hmr -l env-file -l extension-order -l jsx-factory -l jsx-fragment -l jsx-import-source -l jsx-production -l jsx-runtime -l main-fields -l no-summary -l version -l platform -l public-dir -l tsconfig-override -l define -l external -l help -l inject -l loader -l origin -l port -l dump-environment-variables -l dump-limits -l disable-bun-js -s c -s v -s d -s e -s h -s i -s l -s u -s p

complete -c bun -n "__fish_seen_subcommand_from bun" -l use -l cwd -l bunfile -l server-bunfile -l config -l disable-react-fast-refresh -l disable-hmr -l env-file -l extension-order -l jsx-factory -l jsx-fragment -l jsx-import-source -l jsx-production -l jsx-runtime -l main-fields -l no-summary -l version -l platform -l public-dir -l tsconfig-override -l define -l external -l help -l inject -l loader -l origin -l port -l dump-environment-variables -l dump-limits -l disable-bun-js -s c -s v -s d -s e -s h -s i -s l -s u -s p

complete -c bun -n "__fish_seen_subcommand_from create" -l force -l no-install -l help -l no-git -l verbose -l no-package-json -l open -a "next react"

complete -c bun -n "__fish_seen_subcommand_from run" -l version -l cwd -l help -l silent -s v -s h
complete -c bun -n "__fish_seen_subcommand_from run" -f -a "(__bun_print_package_scripts)"

complete -c bun -n "__fish_seen_subcommand_from install" -l config -l yarn -l production -l frozen-lockfile -l no-save -l dry-run -l force -l cache-dir -l no-cache -l silent -l verbose -l global -l cwd -l backend -l link-native-bins -l help -s c -s y -s p -s f -s g

complete -c bun -n "__fish_seen_subcommand_from add" -l development -l optional -l peer -l config -l yarn -l production -l frozen-lockfile -l no-save -l dry-run -l force -l cache-dir -l no-cache -l silent -l verbose -l global -l cwd -l backend -l link-native-bins -l help -s c -s y -s p -s f -s g -s d

complete -c bun -n "__fish_seen_subcommand_from remove" -l config -l yarn -l production -l frozen-lockfile -l no-save -l dry-run -l force -l cache-dir -l no-cache -l silent -l verbose -l global -l cwd -l backend -l link-native-bins -l help -s c -s y -s p -s f -s g

complete -c bun -n "__fish_seen_subcommand_from upgrade" -l version -l cwd -l help -s v -s h

complete -c bun -n "__fish_seen_subcommand_from pm" -l config -l yarn -l production -l frozen-lockfile -l no-save -l dry-run -l force -l cache-dir -l no-cache -l silent -l verbose -l no-progress -l no-summary -l no-verify -l ignore-scripts -l global -l cwd -l backend -l link-native-bins -l help -s c -s y -s p -s f -s g -a "bin ls cache hash hash-print hash-string"

complete -c bun -n "__fish_seen_subcommand_from repl" -l help -s h -l eval -s e -l print -s p -l preload -s r -l smol -l config -s c -l cwd -l env-file -l no-env-file

complete -c bun -n "__fish_seen_subcommand_from test" -l use -l cwd -l bunfile -l server-bunfile -l config -l disable-react-fast-refresh -l disable-hmr -l env-file -l extension-order -l jsx-factory -l jsx-fragment -l jsx-import-source -l jsx-production -l jsx-runtime -l main-fields -l no-summary -l version -l platform -l public-dir -l tsconfig-override -l define -l external -l help -l inject -l loader -l origin -l port -l dump-environment-variables -l dump-limits -l disable-bun-js -s c -s v -s d -s e -s h -s i -s l -s u -s p

complete -c bun -n "__fish_seen_subcommand_from build" -l use -l cwd -l bunfile -l server-bunfile -l config -l disable-react-fast-refresh -l disable-hmr -l env-file -l extension-order -l jsx-factory -l jsx-fragment -l jsx-import-source -l jsx-production -l jsx-runtime -l main-fields -l no-summary -l version -l platform -l public-dir -l tsconfig-override -l define -l external -l help -l inject -l loader -l origin -l port -l dump-environment-variables -l dump-limits -l disable-bun-js -s c -s v -s d -s e -s h -s i -s l -s u -s p

complete -c bun -n "__fish_seen_subcommand_from link" -l help -s h
complete -c bun -n "__fish_seen_subcommand_from unlink" -l help -s h

complete -c bun -l config -r -F
complete -c bun -l bunfile -r -F -a "!.bun"
complete -c bun -l server-bunfile -r -F -a "!.server.bun"
complete -c bun -l cwd -r -d "Working directory"
complete -c bun -l public-dir -r -d "Public directory"

complete -c bun -l backend -a "clonefile copyfile hardlink clonefile_each_dir symlink"

complete -c bun -l jsx-runtime -a "automatic classic"
complete -c bun -l target -a "browser node bun"

complete -c bun -l loader -x -a "jsx js json tsx ts css"

complete -c bun -l use -l env-file -l main-fields -l origin -l port -l dump-environment-variables -l dump-limits -l disable-bun-js
complete -c bun -l disable-react-fast-refresh -l disable-hmr -l no-summary -l help -s h -s v -l version
