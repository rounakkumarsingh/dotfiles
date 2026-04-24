# Neovim Tools Quick Reference

Run these commands inside Neovim for tool management.

## Check Tool Status

```vim
:ConformStatus          " Check formatter availability
:LintStatus             " Check linter availability
:Mason                  " Check/manage LSP servers
```

## Install Missing Tools (Terminal)

```bash
# From terminal in nvim config directory
cd ~/.config/nvim
./install-tools.sh check     " Check what's missing
./install-tools.sh install   " Install everything
./install-tools.sh list      " Show all tools
```

## Cache Management

```vim
:LintClearCache          " Clear tool availability cache
" Useful after installing new tools without restarting nvim
```

## Manual Tool Installation (if script fails)

### Oxc (Recommended - Ultra Fast)
```bash
npm install -g oxc@latest
# or
cargo install oxc_cli
```

### Biome (Fallback - Also Fast)
```bash
npm install -g @biomejs/biome
# or macOS
brew install biome
```

### Prettier Ecosystem
```bash
# Daemonized (faster)
npm install -g @fsouza/prettierd

# Classic
npm install -g prettier
```

## Troubleshooting

**"No formatter available" error:**
1. Run `:ConformStatus` - see what's available
2. Install at least one: `npm install -g @biomejs/biome`
3. Run `:LintClearCache` to refresh

**Formatting works but not preferred tool:**
- Check priority in `lua/utils/tool_check.lua`
- First available tool in chain wins

**Want to use only LSP formatting:**
- Edit `lua/plugins/conform.lua`
- Change to: `javascript = { lsp_format = "fallback" }`

## Tool Priority Chains

```
Formatters:  oxfmt → biome → prettierd → prettier → dprint → LSP
Linters:     oxlint → biomejs → eslint_d → eslint
```

## Mason vs Manual

| What | How | Command |
|------|-----|---------|
| LSP Servers | Mason | `:Mason` |
| oxfmt/oxlint | Manual | `./install-tools.sh` |
| biome | Manual | `npm install -g @biomejs/biome` |
| prettier | Manual | `npm install -g prettier` |

## Platform-Specific Notes

### Linux
All npm commands work. Some distros package these:
- Arch AUR: `oxc-bin`, `biomejs`
- Nix: `oxc`, `biome`

### macOS
```bash
brew install biome          # Biome
npm install -g oxc          # Oxc (no homebrew yet)
```

### Windows
Use WSL2. Native Windows may have path issues.
