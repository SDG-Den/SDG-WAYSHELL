# SDG-WAYSHELL Migration Plan

## Directory Mapping

| Source | Installed to |
|--------|-------------|
| `config/SDG-WAYSHELL/wayshell.sh` | `~/.local/SDG-WAYSHELL/wayshell.sh` |
| `config/SDG-WAYSHELL/wayshell.modules` | `~/.config/SDG-WAYSHELL/wayshell.modules` |
| `tips/` | `~/.local/tips/SDG-WAYSHELL/` |
| `docs/` | `~/.local/docs/SDG-WAYSHELL/` |

## Path Rewrites

### wayshell.sh — internal paths

| Old | New |
|-----|-----|
| `APP_FOLDER=~/.config/sdgos/wayshell` | `APP_FOLDER=~/.config/SDG-WAYSHELL` |
| `CONFIG_FOLDER=~/.config/sdgos/wayshell` | `CONFIG_FOLDER=~/.config/SDG-WAYSHELL` |

### wayshell.modules — critical hardcoded path fixes

This file has the **worst path inconsistency** in the entire monorepo. 14 references mix 4 different patterns:

```bash
# PATTERN 1: $HOME (correct, 2 references)
$HOME/.config/...

# PATTERN 2: ~ (works in shell, 5 references)
~/.config/...

# PATTERN 3: /home/den/ (BUG - hardcoded, 1 reference)
/home/den/.cache/sdgos/wallpapers/marker.sh

# PATTERN 4: /home/$(whoami)/ (works but fragile, 6 references)
/home/$(whoami)/.config/sdgos/...
```

All must become **consistent** with the new module paths:

| Old reference | New target | Correct new path |
|--------------|------------|------------------|
| `.../misc/marker.sh` | SDG-MANGO-SWAP | `$HOME/.local/SDG-MANGO-SWAP/marker.sh` |
| `.../misc/colors.sh` | SDG-UTILS | `$HOME/.local/SDG-UTILS/colors.sh` |
| `.../fastfetch/fetch.sh` | SDG-FETCH | `$HOME/.local/SDG-FETCH/fetch.sh` |
| `.../tuis/documentation.sh` | SDG-UTILS | `$HOME/.local/SDG-UTILS/documentation.sh` |
| `.../config-overview/menu.sh` | SDG-MANGO-CONF | `$HOME/.local/SDG-MANGO-CONF/menu.sh` |
| `.../tuis/project-select.sh` (or project.select.sh) | SDG-UTILS | `$HOME/.local/SDG-UTILS/project-select.sh` |
| `.../tuis/bar-presets.sh` | SDG-DMS-BARS | `$HOME/.local/SDG-DMS-BARS/bar-presets.sh` |
| `.../tuis/layout-switch.sh` | SDG-MANGO-LAYOUTS | `$HOME/.local/SDG-MANGO-LAYOUTS/layout-switch.sh` |
| `.../fastfetch/fetch-conf.sh` | SDG-FETCH | `$HOME/.local/SDG-FETCH/fetch-conf.sh` |
| `.../help/help.sh` | SDG-HELP | `$HOME/.local/SDG-HELP/help.sh` |
| `.../mango-config.sh` | SDG-MANGO-CONF | `$HOME/.local/SDG-MANGO-CONF/mango-config.sh` |
| `.../help/cmd-help.sh` | SDG-HELP | `$HOME/.local/SDG-HELP/cmd-help.sh` |
| `.../tuis/pkg-install.sh` | SDG-UTILS | `$HOME/.local/SDG-UTILS/pkg-install.sh` |
| `.../tuis/aur-install.sh` | SDG-UTILS | `$HOME/.local/SDG-UTILS/aur-install.sh` |
| `.../misc/swapmarked.sh` | SDG-MANGO-SWAP | `$HOME/.local/SDG-MANGO-SWAP/swapmarked.sh` |

## Missing Module: SDG-MONOCLE

The module list includes `SDG-MONOCLE` (line 30 in wayshell.modules), but **no SDG-MONOCLE directory exists** in the repo. Possible options:
1. Create the missing module
2. Remove the reference from wayshell.modules
3. Mark as optional with a pre-condition check

## Cross-Module References TO SDG-WAYSHELL

| From | Old Reference | New Reference |
|------|--------------|---------------|
| SDG-MANGO-CORE/binds.conf | `.../wayshell/wayshell.sh` | `~/.local/SDG-WAYSHELL/wayshell.sh` |
| SDG-MANGO-CORE/autostart.conf | `.../wayshell/wayshell.sh` | `~/.local/SDG-WAYSHELL/wayshell.sh` |

## Lifecycle Scripts

All four root-level scripts are empty. Implement:

- **install.sh**: Copy `config/SDG-WAYSHELL/wayshell.modules` → `~/.config/SDG-WAYSHELL/`, copy `config/SDG-WAYSHELL/wayshell.sh` → `~/.local/SDG-WAYSHELL/wayshell.sh`, copy docs/tips. Symlink: `sudo ln -sf ~/.local/SDG-WAYSHELL/wayshell.sh /usr/bin/wayshell`.
- **uninstall.sh**: Remove deps, remove symlink.
- **update.sh**: Re-deploy.
- **detect.sh**: Check `superctl` (for DMS).

## Modular Tips

- Create `tips/` with Wayshell module management tips.

## Modular Docs

- Create `docs/` documenting the Wayshell module system.

## Cleanup

- Remove empty `cache/`, `other/`, `tips/`
