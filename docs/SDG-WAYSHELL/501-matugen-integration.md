# Matugen Integration

Wayshell bars support dynamic Material You theming via matugen. There are two matugen-related files with different roles.

## Package-level MATUGEN template

`~/.local/SDG-WAYSHELL/MATUGEN.toml` defines how matugen renders waybar colours:

```toml
[templates.wayshellbars]
input_path = '~/.local/SDG-WAYSHELL/colors.css'
output_path = '~/.config/SDG-WAYSHELL-CONFIGS/colors.css'
```

`~/.local/SDG-WAYSHELL/colors.css` is a Jinja2 template:

```css
@define-color {{name}} {{value.default.hex}};
```

Matugen renders this to `~/.config/SDG-WAYSHELL-CONFIGS/colors.css`, injecting Material You color variables.

## System-level matugen config

`~/.local/matugen/01-wayshell.toml` is installed by the package into the system matugen config directory:

```toml
[templates.wayshellbars]
input_path = '~/.config/matugen/templates/InioX/colors.css'
output_path = '~/.config/SDG-WAYSHELL-CONFIGS/colors.css'
```

This config allows matugen's system-wide compilation to also regenerate the wayshell colour file.

## Usage

All Waybar bar CSS files import `colors.css` via:

```css
@import "colors.css";
```

This means bar colours update dynamically whenever matugen regenerates the output file — no manual CSS changes needed when the wallpaper or accent colour changes.
