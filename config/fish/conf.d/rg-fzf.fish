alias grep 'rg --hidden --line-number'
set -Ux FZF_DEFAULT_COMMAND 'rg --files --hidden --follow -g "!.git/*"'
