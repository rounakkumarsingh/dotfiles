# Neovim Configuration

A high-performance, modular Neovim configuration built for Go, Python, and modern web development.

## 🚀 Architecture
- **Plugin Manager**: [lazy.nvim](https://github.com/folke/lazy.nvim)
- **LSP Engine**: Native Neovim 0.11+ `vim.lsp.config` (Modular server setup)
- **Autocomplete**: [blink-cmp](https://github.com/Saghen/blink.cmp)
- **Formatting**: [conform.nvim](https://github.com/stevearc/conform.nvim) with intelligent fallbacks
- **Linting**: [nvim-lint](https://github.com/mfussenegger/nvim-lint) with availability checking
- **UI & Navigation**: [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim), [trouble.nvim](https://github.com/folke/trouble.nvim), and [snacks.nvim](https://github.com/folke/snacks.nvim)

---

## 📦 Installation

### Prerequisites

| Requirement | Purpose | Installation |
|-------------|---------|--------------|
| Neovim 0.11+ | Editor | [Install Guide](https://github.com/neovim/neovim/blob/master/INSTALL.md) |
| Node.js 18+ | JS/TS tooling | `npm` or [nvm](https://github.com/nvm-sh/nvm) |
| Go 1.21+ | Go development | [golang.org](https://golang.org/dl/) |
| Python 3.10+ | Python development | System package manager |
| Rust (optional) | Alternative Oxc install | [rustup.rs](https://rustup.rs/) |

### Quick Start

```bash
# 1. Clone the configuration
git clone <your-repo> ~/.config/nvim

# 2. Install non-Mason tools (formatters/linters)
cd ~/.config/nvim
./install-tools.sh install

# 3. Open Neovim and let lazy.nvim install plugins
nvim
# Wait for installation to complete, then restart

# 4. Install LSP servers via Mason
:Mason
# All required servers auto-install via ensure_installed
```

---

## 🔧 Tool Management Strategy

This configuration uses a **hybrid approach** for tool management:

### Mason-Managed (LSPs & DAPs)
Mason handles all **LSP servers** and debug adapters:

| Category | Tools |
|----------|-------|
| LSP Servers | `vtsls`, `basedpyright`, `gopls`, `clangd`, `ruff`, `tailwindcss-language-server`, `json-lsp`, `css-lsp` |
| Go Tools | `goimports-reviser`, `gofumpt`, `golangci-lint` |
| C/C++ | `clang-format` |

**Install/Update**: Run `:Mason` inside Neovim

### Non-Mason Tools (CLI Formatters/Linters)
These CLI tools **must be installed manually** (Mason doesn't support them):

| Tool | Purpose | Priority | Install |
|------|---------|----------|---------|
| **oxfmt** | JS/TS/JSON/CSS formatter | Primary | `npm install -g oxc@latest` |
| **oxlint** | JS/TS/JSON linter | Primary | `npm install -g oxc@latest` |
| biome | JS/TS formatter/linter | Fallback 1 | `npm install -g @biomejs/biome` |
| prettierd | Daemonized prettier | Fallback 2 | `npm install -g @fsouza/prettierd` |
| prettier | Universal formatter | Fallback 3 | `npm install -g prettier` |
| dprint | Pluggable formatter | Fallback 4 | See [dprint.dev](https://dprint.dev) |
| yamlfmt | YAML formatter | YAML | `go install github.com/google/yamlfmt/cmd/yamlfmt@latest` |
| yamllint | YAML linter | YAML | `pip install yamllint` |

### Automatic Fallback Chain

If `oxfmt`/`oxlint` are not installed, the config automatically falls back:

```
Formatter Priority:    oxfmt → biome → prettierd → prettier → dprint → LSP
Linter Priority:       oxlint → biomejs → eslint_d → eslint
```

The fallback happens **automatically at runtime** - no config changes needed.

---

## 🛠 Tool Installation Helper

Use the included script to check and install dependencies:

```bash
# Check status of all non-Mason tools
./install-tools.sh check

# Install all missing tools
./install-tools.sh install

# List all tools with install commands
./install-tools.sh list

# Show help
./install-tools.sh help
```

### Manual Installation

If you prefer manual control:

```bash
# Recommended: Oxc toolchain (ultra-fast, Rust-based)
npm install -g oxc@latest

# Or use Cargo (if you prefer Rust ecosystem)
cargo install oxc_cli

# Alternative: Biome (also Rust-based, great fallback)
npm install -g @biomejs/biome

# Alternative: Prettier (classic choice)
npm install -g prettier

# Faster alternative to prettier: prettierd (daemon)
npm install -g @fsouza/prettierd
```

---

## 🌐 Cross-Platform Support

### Linux
All npm/cargo commands work universally. Package manager alternatives:

```bash
# Arch Linux (AUR)
yay -S oxc-bin biomejs

# NixOS
nix-env -iA nixpkgs.oxc nixpkgs.biome

# Debian/Ubuntu (via npm/cargo recommended)
```

### macOS
```bash
# Homebrew options
brew install biome                    # Biome available
brew install fsouza/prettierd/prettierd  # Tap required

# npm works everywhere
npm install -g oxc @biomejs/biome @fsouza/prettierd
```

### Windows
- **Recommended**: Use [WSL2](https://docs.microsoft.com/en-us/windows/wsl/) with Ubuntu
- **Alternative**: Git Bash + [scoop](https://scoop.sh/)
- **PowerShell**: Most npm packages work, but paths may differ

---

## 🛠 Language Support

### Python
- **LSP**: `basedpyright` + `ruff` (Mason-managed)
- **Venv**: Automatic `.venv` detection via `utils/project.lua`
- **Linting/Formatting**: `ruff` (Ultra-fast Rust-based)
- **Go-to-Definition**: Works for external libraries with venv resolution

### Go
- **LSP**: `gopls` (Full features: Inlay hints, semantic tokens, codelenses)
- **Formatting**: `goimports-reviser` (Aggressive import management) + `gofumpt` (stricter gofmt)
- **Linting**: `golangci-lint` via `nvim-lint`

### C/C++
- **LSP**: `clangd` (Background indexing, clang-tidy integration)
- **Formatting**: `clang-format` (LLVM style)
- **Navigation**: `<leader>ch` switches between source and header files

### JS/TS (Web Stack)
- **Runtime**: Bun-centric (prioritizes `bun.lockb` for root detection)
- **LSP**: `vtsls` (Source definition jumping, refactoring)
- **Formatting**: `oxfmt` (Oxc toolchain, ultra-fast) with automatic fallbacks
- **Linting**: `oxlint` (fast) with `biome`/`eslint` fallbacks
- **CSS**: `tailwindcss-language-server` + `css-lsp`
- **JSON**: `json-lsp` with SchemaStore (400+ schemas)

---

## ⌨️ Keymaps

### Navigation (LSP)
| Key | Action | Behavior |
| :--- | :--- | :--- |
| `gd` | Definition | Jump if unique, otherwise show Picker |
| `gr` | References | Jump if unique, otherwise show Picker |
| `gi` | Implementation | Jump if unique, otherwise show Picker |
| `gy` | Type Definition | Jump if unique, otherwise show Picker |
| `gs` | Document Symbols | Open Telescope Picker |
| `gS` | Workspace Symbols | Open Telescope Picker |
| `K`  | Hover | Show documentation in float |
| `<leader>ch` | Switch Header | Toggle between .c/cpp and .h files |

### Code Actions (`<leader>c`)
| Key | Action | Description |
| :--- | :--- | :--- |
| `<leader>cr` | Rename | Project-wide rename |
| `<leader>ca` | Code Action | Contextual fixes |
| `<leader>cs` | Signature | Function signature help |
| `<leader>co` | Organize | Organize imports (JS/TS) |
| `<leader>cI` | Add Imports | Add missing imports (JS/TS) |
| `<leader>cf` | Fix All | Apply auto-fixes |

### Diagnostics & Toggles
| Key | Action | Description |
| :--- | :--- | :--- |
| `<leader>xx` | Trouble | Toggle project diagnostic list |
| `<leader>ti` | Inlay Hints | Toggle LSP inlay hints |

### Tool Status Commands
| Command | Description |
| :--- | :--- |
| `:ConformStatus` | Check which formatters are available |
| `:LintStatus` | Check which linters are available |
| `:LintClearCache` | Clear tool availability cache |

---

## 📂 Project Structure

```
~/.config/nvim/
├── init.lua                      # Entry point
├── install-tools.sh              # ⭐ Non-Mason tool installer
├── README.md                     # This file
├── lua/
│   ├── config/
│   │   ├── options.lua           # Neovim options
│   │   ├── keymaps.lua           # Global keymaps
│   │   ├── autocmds.lua          # Autocommands
│   │   ├── lazy.lua              # Plugin manager bootstrap
│   │   ├── harpoon.lua           # Harpoon configuration
│   │   └── lsp/
│   │       ├── init.lua          # LSP setup orchestrator
│   │       └── servers/          # Per-server configs
│   │           ├── vtsls.lua
│   │           ├── basedpyright.lua
│   │           ├── gopls.lua
│   │           ├── oxlint.lua    # ⭐ Oxlint configuration
│   │           └── ...
│   ├── plugins/
│   │   ├── conform.lua           # ⭐ Smart formatting with fallbacks
│   │   ├── nvim-lint.lua       # ⭐ Smart linting with fallbacks
│   │   ├── lsp.lua               # Mason + LSP config
│   │   └── ...                   # Other plugins
│   └── utils/
│       ├── project.lua           # Project root + venv detection
│       └── tool_check.lua        # ⭐ Runtime tool availability
```

---

## 🔧 Troubleshooting

### "Formatter not found" warnings

1. Check which tools are available:
   ```vim
   :ConformStatus
   :LintStatus
   ```

2. Install missing tools:
   ```bash
   cd ~/.config/nvim
   ./install-tools.sh install
   ```

3. Clear the cache after installing:
   ```vim
   :LintClearCache
   ```

### Prefer different formatters?

Edit `lua/utils/tool_check.lua` to change priority order:

```lua
-- Current priority (oxc → biome → prettier)
local js_formatters = { "oxfmt", "biome", "prettierd", "prettier", "dprint" }

-- Your preference (biome → oxc → prettier)
local js_formatters = { "biome", "oxfmt", "prettierd", "prettier" }
```

### Fallback to LSP formatting only

If you want to disable external formatters entirely:

```lua
-- In lua/plugins/conform.lua, change to:
javascript = { lsp_format = "fallback" }
```

### Oxc-specific issues

1. **oxfmt not formatting**: Check for `.oxc.json` config file issues
2. **oxlint false positives**: Add `.oxlintignore` or configure in `package.json`
3. **Performance**: Oxc is fast, but large monorepos may benefit from `dprint` instead

---

## 📦 Adding New Language Support

1. **Install LSP via Mason**: `:MasonInstall <lsp-name>`
2. **Create server config**: `lua/config/lsp/servers/<name>.lua`
3. **Add formatters** (if not Mason-managed):
   - Edit `lua/plugins/conform.lua`
   - Add entry to `formatters_by_ft`
   - Add to `./install-tools.sh` if CLI tool
4. **Add linters**:
   - Edit `lua/plugins/nvim-lint.lua`
   - Add to `linter_chains` table
5. Update this README with the new tools

The configuration auto-discovers server configs from `lua/config/lsp/servers/`.

---

## 📝 Mason vs Non-Mason Decision Tree

| Tool Type | Mason? | Reason | Example |
|-----------|--------|--------|---------|
| LSP Server | ✅ Yes | Protocol-based, editor-agnostic | vtsls, gopls |
| DAP Adapter | ✅ Yes | Debugging protocol | codelldb |
| Linter (LSP) | ✅ Yes | LSP-based diagnostics | ruff |
| **CLI Formatter** | ❌ No | stdout-based, Mason incompatible | **oxfmt, biome** |
| **CLI Linter** | ❌ No | stdout-based, Mason incompatible | **oxlint, eslint** |
| Build Tool | ❌ No | Build system integration | cargo, npm |

CLI tools write to stdout and are designed for terminal use - they don't speak LSP protocol, so Mason can't manage them.
