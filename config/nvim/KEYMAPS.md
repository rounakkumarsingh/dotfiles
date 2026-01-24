# Neovim Keymaps

## Philosophy

> Keymaps are an API to your brain.
> Motions stay native. Actions go under `<leader>`.
> Group by intent, not plugins.
> First key = domain, second = action.
> If you need which-key to remember it, the map is wrong.
> Contextual actions (LSP) exist only when valid.
> One concept, one binding.
> Boring beats clever. Predictable beats fast.

---

## Domains

| Key | Domain | Description |
| :-- | :--- | :--- |
| `t` | Toggles | Toggling UI elements and features |
| `f` | Find | Finding files and text with Telescope |
| `c` | Code | LSP actions like renaming and code actions |
| `x` | Diagnostics | Managing and viewing diagnostics |
| `h` | Harpoon | Managing the Harpoon list |
| `g` | Git | Git operations with Fugitive and Gitsigns |
| `d` | Debug | Debugging actions |
| `l` | LSP / Lint | General LSP information and linting |
| `y` / `p`| Yank/Paste | System clipboard operations |

---

## Mappings

### Toggles (`<leader>t`)

| Keymap | Action |
| :--- | :--- |
| `<leader>te` | Toggle file **E**xplorer |
| `<leader>tu` | Toggle **U**ndotree |
| `<leader>ti` | Toggle **I**nlay hints |

### Find (`<leader>f`)

| Keymap | Action |
| :--- | :--- |
| `<leader>ff` | **F**ind **F**iles |
| `<leader>fg` | **F**ind **G**it files |
| `<leader>fw` | **F**ind **W**ord (grep) |

### Code (`<leader>c`)

| Keymap | Action |
| :--- | :--- |
| `<leader>cr` | **C**ode **R**ename |
| `<leader>ca` | **C**ode **A**ction |
| `<leader>cs` | **C**ode **S**ignature help |

### Diagnostics (`<leader>x`)

| Keymap | Action |
| :--- | :--- |
| `<leader>xd` | Show **D**iagnostics at cursor |

### Harpoon (`<leader>h`)

| Keymap | Action |
| :--- | :--- |
| `<leader>ha` | **H**arpoon **A**dd file |
| `<leader>hm` | **H**arpoon **M**enu |
| `<leader>hp` | **H**arpoon **P**revious |
| `<leader>hn` | **H**arpoon **N**ext |
| `<leader>h1` - `<leader>h4` | Jump to file 1-4 |

### Git (`<leader>g`)

| Keymap | Action |
| :--- | :--- |
| `<leader>gg` | **G**it status |

### LSP / Lint (`<leader>l`)

| Keymap | Action |
| :--- | :--- |
| `<leader>ll` | **L**int file |

### Debug (`<leader>d`)

| Keymap | Action |
| :--- | :--- |
| `<leader>dv` | Toggle **V**irtual text |

### General

| Keymap | Action |
| :--- | :--- |
| `<leader>y` | Yank to system clipboard |
| `<leader>p` | Paste from system clipboard |
| `K` | Hover documentation |
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | Go to references |
