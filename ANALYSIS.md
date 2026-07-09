# SDG-WAYSHELL — Analysis

## Function

SDG-WAYSHELL provides the `wayshell` event daemon for mangoWM — a trailing-edge debounced event manager that bridges mangoWM IPC events to external actions (Waybar popups, scripts, widget toggles).

Three event types are supported, each with a dedicated event-source module:

| Type | Module | Source |
|------|--------|--------|
| **zone** — cursor enters/exits screen-edge bounding box | `zone.sh` | Polls `mmsg get cursorpos` every 100ms |
| **layout** — tag layout activates/deactivates | `layout.sh` | Watches `mmsg watch all-tags` |
| **focused** — app gains/loses focus | `focused.sh` | Watches `mmsg watch focusing-client` |

The daemon reads a config file (debounce timings + zone buffer) and a modules file (pipe-delimited name\|on_exec\|off_exec\|type\|args), then spawns each module as a subprocess. Events are processed through a state machine: `disabled → pending_on → enabled → pending_off → disabled` with per-type debounce delays.

**Entrypoint:** `~/.local/SDG-WAYSHELL/wayshell.sh` → symlinked to `/usr/bin/wayshell`

---

## Dependencies

### Runtime (installed via `install.sh:4-6`)
| Dependency | Purpose | Declared at |
|-----------|---------|-------------|
| `waybar` | Bar instances (volume, brightness, screenshot, monocle, bottom bar) | `install.sh:4` |
| `jq` | JSON parsing of mmsg IPC output | `install.sh:5` |
| `procps-ng` | Process management (pkill/pgrep in ON/OFF actions) | `install.sh:6` |

### Runtime (IPC, from mangoWM)
| Dependency | Purpose | Declared at |
|-----------|---------|-------------|
| `mmsg` | mangoWM IPC client — get cursorpos/monitors/tags, watch events, dispatch commands | `docs/…/DEPENDENCIES-updated.md:3` |

### Config scripts (separate package)
The ON/OFF actions in `wayshell.modules` reference scripts and Waybar configs from **SDG-WAYSHELL-CONFIGS** at `~/.config/SDG-WAYSHELL-CONFIGS/`. This is a separate repo (`sdg-wayshell-conf` in SDG-PKG). Examples: `volume/volume.json`, `brightness/brightness.css`, `screenshot/ss-capture.sh`, `bottom-bar/elevated-show.sh`.

### Optional
`wpctl` (audio), `brightnessctl` (backlight), `grim`/`slurp` (screenshots), `wl-copy` (clipboard), `satty` (screenshot editor), `notify-send` (notifications), `zenity` (dialogs), `nvidia-smi` (GPU monitoring) — all listed in `docs/…/DEPENDENCIES-updated.md:6-15`.

---

## Dependents

| Package | File | How SDG-WAYSHELL is used |
|---------|------|--------------------------|
| **SDG-MANGO-CORE** | `config/mango/autostart.conf:18` | `exec-once=~/.local/SDG-WAYSHELL/wayshell.sh` — launches daemon on WM start |
| **SDG-WAYSHELL-CONFIGS** | `install.sh:4` | `unipkg install any sdg-wayshell` — declares wayshell as a prerequisite |
| **SDG-OS-META** | `install.sh:11-12` | `sdgpkg install sdg-wayshell` + `sdgpkg install sdg-wayshell-conf` — meta-package pulls in both |
| **SDG-DOCS** | Multiple files under `docs/` | References wayshell paths in path-conventions, architecture-overview, config-modules docs |
| **GLOBAL-MIGRATION-GUIDE** | `GLOBAL-MIGRATION-GUIDE.md:240-256` | Documents old→new path migration for wayshell configs and modules |

---

## Use / Configuration

### Files installed to user home
| Source path | Installed to | Purpose |
|-------------|-------------|---------|
| `config/SDG-WAYSHELL/wayshell.conf` | `~/.config/SDG-WAYSHELL/wayshell.conf` | Debounce timings (ms) + zone buffer (px) |
| `config/SDG-WAYSHELL/wayshell.modules` | `~/.config/SDG-WAYSHELL/wayshell.modules` | Module definitions (name\|on\|off\|type\|args) |
| `local/SDG-WAYSHELL/wayshell.sh` | `~/.local/SDG-WAYSHELL/wayshell.sh` | Main daemon script (symlinked to `/usr/bin/wayshell`) |
| `local/SDG-WAYSHELL/modules/zone.sh` | `~/.local/SDG-WAYSHELL/modules/zone.sh` | Cursor zone detection |
| `local/SDG-WAYSHELL/modules/layout.sh` | `~/.local/SDG-WAYSHELL/modules/layout.sh` | Layout change detection |
| `local/SDG-WAYSHELL/modules/focused.sh` | `~/.local/SDG-WAYSHELL/modules/focused.sh` | Focus change detection |
| `local/SDG-WAYSHELL/MATUGEN.toml` | `~/.local/SDG-WAYSHELL/MATUGEN.toml` | Matugen template config: input `colors.css` → output `~/.config/SDG-WAYSHELL-CONFIGS/colors.css` |
| `local/SDG-WAYSHELL/colors.css` | `~/.local/SDG-WAYSHELL/colors.css` | Matugen Jinja2 template with Material You color variables |
| `docs/SDG-WAYSHELL/*` | `~/.local/docs/SDG-WAYSHELL/*` | Documentation files |
| `tips/SDG-WAYSHELL/*` | `~/.local/tips/SDG-WAYSHELL/*` | Tips (empty — see issues) |

### Wayshell state files
Runtime state is stored in `$XDG_CACHE_HOME/wayshell/` (defined in SDG-WAYSHELL-CONFIGS scripts):
- `bottom_elevated.state`, `bottom_elevated_visible`, `bottom_elevated_pinned`
- `bottom_focused.state`, `bottom_focused_visible`, `bottom_focused_pinned`
- Temporary FIFO: `/tmp/wayshell-fifo-$$` (cleanup on EXIT/INT/TERM at `wayshell.sh:170`)

### Signal protocol (from SDG-WAYSHELL-CONFIGS scripts)
- `SIGRTMIN+1` — refresh elevated modules in bottom bar
- `SIGRTMIN+2` — refresh focused modules
- `SIGRTMIN+3` — refresh FPS/GPU

---

## Deprecation / Outdated Items

### 1. CRITICAL: SDG-MONOCLE referenced but does not exist — 9 dangling entries
`config/SDG-WAYSHELL/wayshell.modules` lines 28–40 reference `$HOME/.config/SDG-MONOCLE/monocle.sh` and `$HOME/.config/SDG-MONOCLE/config-*` / `style.css`. There is **no SDG-MONOCLE package** in the SDG-OS monorepo. These 9 entries will all fail at runtime:

| Line | Module name | Layout | Monitor |
|------|------------|--------|---------|
| 28 | `monocle` | M | HDMI-A-1 |
| 29 | `monocle-dp1` | M | DP-1 |
| 30 | `monocle-dp3` | M | DP-3 |
| 33 | `deck-hdmi` | K | HDMI-A-1 |
| 34 | `deck-dp1` | K | DP-1 |
| 35 | `deck-dp3` | K | DP-3 |
| 38 | `vdeck-hdmi` | VK | HDMI-A-1 |
| 39 | `vdeck-dp1` | VK | DP-1 |
| 40 | `vdeck-dp3` | VK | DP-3 |

The ON action tries to spawn `$HOME/.config/SDG-MONOCLE/monocle.sh` (doesn't exist). The OFF action tries to `pkill` a waybar using SDG-MONOCLE config/style paths (nothing to kill). Migration plan (`migration-plan.md:28-29`) acknowledges this: *"currently no such package exists; hardcoded `/home/den/` paths there are also broken"*.

### 2. Hardcoded 1920×1080 zone coordinates
`config/SDG-WAYSHELL/wayshell.modules` uses hardcoded pixel values assuming a 1920×1080 display:
- `zone_left` — `0,300,40,780` (line 15)
- `zone_right` — `1880,300,1920,780` (line 16)
- `zone_topcenter` — `760,0,1160,40` (line 21)
- `elevated_bar` — `0,1030,350,1080` (line 50)
- `focused_bar` — `1570,1030,1920,1080` (line 51)

The `zone.sh` module (`local/SDG-WAYSHELL/modules/zone.sh:83-84`) correctly computes monitor-local coordinates, so the zone detection logic is resolution-aware. However, the bounding box values are hardcoded per-monitor 1920×1080. These will be wrong for monitors with different resolutions or multi-monitor setups where monitors have different sizes.

### 3. Docs reference non-existent `configs/` directory
`docs/SDG-WAYSHELL/README.md:19-25` shows a directory tree with a `configs/` subdirectory inside the wayshell daemon, listing scripts like `volume.sh`, `brightness.sh`, `ss-capture.sh`, etc. These config scripts are actually in the **SDG-WAYSHELL-CONFIGS** package at `~/.config/SDG-WAYSHELL-CONFIGS/`. The doc tree suggests they live alongside the daemon, which is misleading.

Also references to `configs/colors.css` at `docs/SDG-WAYSHELL/README.md:162` and `docs/SDG-WAYSHELL/MODULES-and-CONFIGS.md:4,219` use the same stale path.

### 4. `DEPENDENCIES.md` superseded by `DEPENDENCIES-updated.md`
Two dependency files exist:
- `docs/SDG-WAYSHELL/DEPENDENCIES.md` (16 lines) — older, lists `python3`, `obs-studio`, `pavucontrol`, `wireplumber` but **missing** `mmsg` (the primary IPC dependency).
- `docs/SDG-WAYSHELL/DEPENDENCIES-updated.md` (19 lines) — newer, lists `mmsg`, `waybar`, `wpctl`, `brightnessctl`, `grim`, `slurp`, `wl-copy`, `satty`, `notify-send`, `zenity`, `procps-ng`, `nvidia-smi`.

The older `DEPENDENCIES.md` should be removed to avoid confusion.

### 5. Empty tips
`tips/SDG-WAYSHELL/` contains only a `.placeholder` file. The migration plan (`migration-plan.md:76`) notes: *"exists but empty — placeholder file created"*. No actionable tips are provided to users.

### 6. Root `README.md` is empty
`/SDG-WAYSHELL/README.md` contains only the heading `# SDG-WAYSHELL` (line 1) with no further content. Users examining the repo root get no information about the package.

### 7. `migration-plan.md` references stale cleanup items
`migration-plan.md:80-81` mentions removing `cache/` and `other/` directories ("empty, remove"). These directories do not exist in the current repository. The migration plan was written while they still existed and has not been updated post-cleanup.

### 8. `update.sh` does not preserve user-modified modules
`update.sh:3` does `rm -rf $HOME/.local/SDG-WAYSHELL` then re-copies, meaning any user modifications to module scripts under `~/.local/SDG-WAYSHELL/modules/` are lost on update. Config (`~/.config/SDG-WAYSHELL/`) is preserved because update.sh only touches `local/*`, `docs/*`, and `tips/*`. This is intentional but worth noting.

### 9. `install.sh` does not create `config/SDG-WAYSHELL/` dir if missing
`install.sh:12` runs `cp -r $WORKDIR/config/* $HOME/.config` — this assumes `~/.config/` exists but does not explicitly create the `~/.config/SDG-WAYSHELL/` target directory. If `~/.config/` is missing (e.g., first run), this could silently fail or produce unexpected results.
