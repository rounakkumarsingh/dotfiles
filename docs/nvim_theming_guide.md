# Writing Application Configurations for Omarchy Theming

This guide will walk you through the process of writing and managing application configurations that synchronize with Omarchy's dynamic theming system. By the end of this guide, you will be able to create custom themes, add themed configurations for any application, and understand how hot-reloading works.

## 1. Understanding Omarchy's Theming Engine

Omarchy's theming is designed to be both powerful and easy to customize. The core components are:

*   **Theme Directories**:
    *   `~/.local/share/omarchy/themes/`: This directory contains the stock themes that come with Omarchy. You should not edit these files directly, as they can be overwritten by updates.
    *   `~/.config/omarchy/themes/`: This is where you should store your custom themes. Files in this directory will not be overwritten.

*   **The `omarchy-theme-set` Command**:
    When you run `omarchy-theme-set <theme-name>`, the script performs several actions:
    1.  It finds the specified theme in your custom themes directory, falling back to the stock themes directory if it's not found.
    2.  It copies the theme's files to a central location (`~/.config/omarchy/current/theme/`).
    3.  It restarts several key applications (like Waybar and terminals) to apply the new theme immediately (hot-reloading).
    4.  It runs the `theme-set` hook script, which is the key to custom integrations.

*   **The `theme-set` Hook**:
    This is a script located at `~/.config/omarchy/hooks/theme-set`. Omarchy executes this script every time a theme is changed, passing the name of the new theme as the first argument (`$1`). You can use this script to perform any custom actions, such as linking configuration files for your applications.

## 2. Creating a Custom Theme

The easiest way to create a custom theme is to copy an existing one and modify it.

1.  **Choose a Base Theme**:
    Pick a theme you like from `~/.local/share/omarchy/themes/`. Let's use `catppuccin` as an example.

2.  **Create Your Custom Theme Directory**:
    ```bash
    mkdir -p ~/.config/omarchy/themes/my-theme
    ```

3.  **Copy the Base Theme**:
    ```bash
    cp -r ~/.local/share/omarchy/themes/catppuccin/* ~/.config/omarchy/themes/my-theme/
    ```

Now you have a new theme called "my-theme" that you can safely modify. Inside the theme's directory, you'll find files like `colors.toml` (which defines the color palette) and configuration files for supported applications like `neovim.lua`.

## 3. Theming Supported Applications

For some applications, Omarchy handles theming automatically. If you provide a configuration file with the correct name in your theme's directory, Omarchy will use it.

**Example: Theming Neovim**

1.  Open the `neovim.lua` file in your custom theme directory (`~/.config/omarchy/themes/my-theme/neovim.lua`).
2.  Modify the file to use a different theme or to add custom highlight groups.
3.  Apply your theme with `omarchy-theme-set "my-theme"`.

Omarchy's Neovim configuration is set up to automatically reload this file when the theme changes.

## 4. Theming Unsupported Applications

For applications that Omarchy doesn't support out of the box, you can use the `theme-set` hook to link your own configuration files.

**Step-by-Step Example: Theming `starship`**

Let's create a themed configuration for the `starship` prompt.

1.  **Create the Application's Config File**:
    Create a `starship.toml` file inside your custom theme directory: `~/.config/omarchy/themes/my-theme/starship.toml`. Populate this file with your desired `starship` configuration, using the colors from your theme's `colors.toml`.

2.  **Create the `theme-set` Hook Script**:
    If you don't already have one, create the `theme-set` hook script:
    ```bash
    cp ~/.config/omarchy/hooks/theme-set.sample ~/.config/omarchy/hooks/theme-set
    chmod +x ~/.config/omarchy/hooks/theme-set
    ```

3.  **Edit the Hook Script**:
    Open `~/.config/omarchy/hooks/theme-set` and add the following lines. This script will create a symbolic link from your theme's `starship.toml` to the location where `starship` expects its configuration file.

    ```bash
    #!/bin/bash

    THEME_NAME=$1
    THEME_DIR="$HOME/.config/omarchy/themes/$THEME_NAME"

    # Symlink starship config if it exists in the theme
    if [ -f "$THEME_DIR/starship.toml" ]; then
      ln -sf "$THEME_DIR/starship.toml" "$HOME/.config/starship.toml"
    fi
    ```
    The `ln -sf` command is important: it creates a symbolic link (`-s`) and forces the overwrite if a link already exists (`-f`).

4.  **Apply Your Theme**:
    Run `omarchy-theme-set "my-theme"`. This will execute your hook script and create the symbolic link. The next time you open a terminal, `starship` will use your new themed configuration.

## 5. Understanding Hot-Reloading Mechanisms

Hot-reloading is the process of applying a new theme to running applications without a full system restart. Omarchy uses several techniques to achieve this.

### A. Service Restarts

For many applications, the most reliable way to apply a new theme is a quick restart. The `omarchy-theme-set` command automatically does this for:
*   Waybar
*   SwayOSD
*   Terminals (Alacritty, Kitty, Ghostty)
*   btop
*   Mako (notifications)

You can add your own restart commands to the `theme-set` hook for other applications.

### B. Inter-Process Communication (IPC)

More advanced applications can be told to reload their configuration without restarting. This is faster and less disruptive.
*   **Hyprland**: Reloaded with `hyprctl reload` to apply changes to borders, gaps, and colors instantly.
*   **Neovim**: Uses a custom `LazyReload` event to trigger a script that reapplies the theme (see below).
*   **Your own scripts**: You can add commands like `tmux source-file ...` to your `theme-set` hook to reload other IPC-aware applications.

### C. Application-Specific Scripts

Omarchy includes dedicated scripts to handle theming for popular GUI apps that have unique configuration methods, such as VS Code, GNOME apps, and browsers. You can see these being called in the `omarchy-theme-set` script.

### D. The `theme-set` Hook: Your Custom Engine

The `~/.config/omarchy/hooks/theme-set` script is your personal space to implement hot-reloading for any application that Omarchy doesn't handle natively. You can combine all the techniques above in this script.

## 6. Advanced: Neovim's Hot-Reloading Engine

Omarchy's integration with Neovim is a prime example of advanced IPC-based hot-reloading.

1.  **Symbolic Link**: Your Neovim configuration contains a symbolic link: `lua/plugins/theme.lua` -> `~/.config/omarchy/current/theme/neovim.lua`.
2.  **Theme Change**: When you run `omarchy-theme-set`, the `neovim.lua` file in `~/.config/omarchy/current/theme/` is replaced with the one from the new theme.
3.  **Hot-Reload Script**: The `omarchy-theme-set` command also triggers a `LazyReload` event in Neovim. A special script (`lua/plugins/omarchy-theme-hotreload.lua`) listens for this event and:
    *   Tells Lua to "forget" the old theme file.
    *   Reloads the `plugins.theme` module, now pointing to the new theme file.
    *   Clears all existing syntax highlighting.
    *   Applies the new colorscheme.
    *   Forces a redraw of the Neovim UI.

This mechanism ensures that your Neovim theme is always in sync with your Omarchy theme. When building your own Neovim configuration, including a similar hot-reloading script is essential.

This concludes the guide. You now have the knowledge to fully integrate any application with Omarchy's powerful theming system.
