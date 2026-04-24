# Neovim Configuration

A high-performance, modular Neovim configuration built for Go and Python development.

## 🚀 Architecture
- **Plugin Manager**: [lazy.nvim](https://github.com/folke/lazy.nvim)
- **LSP Engine**: Native Neovim 0.11+ `vim.lsp.config` (Modular server setup)
- **Autocomplete**: [blink-cmp](https://github.com/Saghen/blink.cmp)
- **Formatting**: [conform.nvim](https://github.com/stevearc/conform.nvim)
- **Linting**: [nvim-lint](https://github.com/mfussenegger/nvim-lint)
- **UI & Navigation**: [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim), [trouble.nvim](https://github.com/folke/trouble.nvim), and [snacks.nvim](https://github.com/folke/snacks.nvim)

## 🛠 Language Support

### Python
- **LSP**: `basedpyright` + `ruff`
- **Venv**: Automatic `.venv` detection and environment resolution.
- **Linting/Formatting**: `ruff` (Fast and aggressive).
- **Go-to-Definition**: Works for external libraries.

### Go
- **LSP**: `gopls` (Full features: Inlay hints, semantic tokens, codelenses).
- **Formatting**: `goimports-reviser` (Aggressive unused import removal and grouping) + `gofumpt`.
- **Linting**: `golangci-lint` via `nvim-lint`.

### C/C++
- **LSP**: `clangd` (Background indexing, clang-tidy integration).
- **Formatting**: `clang-format` (LLVM style).
- **Navigation**: Support for switching between source and header files.

### JS/TS (Web Stack)
- **Runtime**: `bun` centric (Prioritizes `bun.lockb` for root detection).
- **LSP**: `vtsls` (Source definition jumping, refactoring) + `oxlint` (Fast linting).
- **Formatting**: `oxfmt` (Oxc toolchain, ultra fast).
- **UI**: `tailwindcss` and `cssls` support.
- **Config Intelligence**: `jsonls` with `SchemaStore` (Autocompletions for over 400+ JSON/YAML schemas).

## ⌨️ Keymaps

### Navigation (LSP)
| Key | Action | Behavior |
| :--- | :--- | :--- |
| `gd` | Definition | Jump if unique, otherwise show Picker |
| `gr` | References | Jump if unique, otherwise show Picker |
| `gi` | Implementation | Jump if unique, otherwise show Picker |
| `gs` | Document Symbols | Open Telescope Picker |
| `gS` | Workspace Symbols | Open Telescope Picker |
| `K`  | Hover | Show documentation in float |
| `<leader>ch` | Switch Header | Toggle between .c/cpp and .h files |

### Code Actions (`<leader>c`)
| Key | Action | Description |
| :--- | :--- | :--- |
| `<leader>cr` | Rename | Project-wide rename via Snacks UI |
| `<leader>ca` | Code Action | Contextual fixes via Snacks/Telescope |
| `<leader>cs` | Signature | Show function signature help |
| `<leader>co` | Organize | Organize imports (JS/TS - vtsls) |
| `<leader>cI` | Add Imports | Add missing imports (JS/TS - vtsls) |
| `<leader>cf` | Oxc Fix | Apply all suggested linting fixes (Oxlint) |

### Diagnostics & Toggles
| Key | Action | Description |
| :--- | :--- | :--- |
| `<leader>xx` | Trouble | Toggle project diagnostic list |
| `<leader>ti` | Inlay Hints | Toggle LSP inlay hints (Global/Buffer) |

## 📂 Modular Structure
Adding support for a new language:
1. Install the server via `:Mason`.
2. Create `lua/config/lsp/servers/<server_name>.lua`.
3. The config is automatically loaded and enabled via `vim.lsp.enable`.
