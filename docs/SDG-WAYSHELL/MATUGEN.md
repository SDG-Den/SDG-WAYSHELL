# Matugen Integration

Wayshell bars support dynamic Material You theming via matugen.

## Template Configuration

`~/.local/SDG-WAYSHELL/MATUGEN.toml`:

```toml
[templates.wayshellbars]
input_path = '~/.local/SDG-WAYSHELL/colors.css'
output_path = '~/.config/SDG-WAYSHELL-CONFIGS/colors.css'
```

## Template

`~/.local/SDG-WAYSHELL/colors.css` is a Jinja2 template:

```css
@define-color {{name}} {{value.default.hex}};
```

Matugen renders this to `~/.config/SDG-WAYSHELL-CONFIGS/colors.css`, injecting Material You color variables.

## Usage

All Waybar bar CSS files import `colors.css` via:

```css
@import "colors.css";
```

This means bar colors update dynamically whenever matugen regenerates the output file — no manual CSS changes needed when the wallpaper or accent color changes.
