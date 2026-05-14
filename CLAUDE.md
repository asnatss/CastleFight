# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Castle Fight EU v2.0.40 Lexa 1.3.1** — a Warcraft 3 PvP Castle Defense map. Two teams of up to 3 players (Western Force: players 1-3, Eastern Force: players 7-9) build defenses and train units to destroy the opposing castle.

All editable source lives in `CF_CUSTOM/` (tracked in git). The compiled binary output is `CF_CUSTOM/CF_CUSTOM.w3x` (MPQ archive).

## Toolchain: w3x2lni (LNI Format)

This map uses the **w3x2lni** tool to convert between binary `.w3x` and editable LNI source. The tool is external to this repo.

```
# Compile LNI source → .w3x (run from the map's parent directory)
w3x2lni pack CF_CUSTOM

# Extract .w3x → LNI source
w3x2lni unpack CF_CUSTOM.w3x CF_CUSTOM
```

The `CF_CUSTOM/w3x2lni/version/lml` file marks the LNI format version (v2).

## Source Layout

```
CF_CUSTOM/
  trigger/          # Jass (.j) game logic
    catalog.lml     # Ordered list of trigger files (LNI catalog)
    1-triggers/
      1-init.j            # ~14k lines: globals, initialization, core systems
      2-grid.j            # -grid command: visual grid overlay
      3-commands.j        # Additional player commands
      4-InfoBoard.j       # QR code info display
      6-UltimateBuilder.j # Advanced building placement system
  table/            # Game balance data (INI format)
    unit.ini        # ~38k lines: all unit stats and definitions
    ability.ini     # ~14k lines: all ability configs
    buff.ini        # Buff/effect definitions
    item.ini        # Item definitions
    w3i.ini         # Map metadata (version, players, forces, camera)
  map/              # Compiled binary map files (terrain, pathing, doodads)
  resource/         # Custom assets: .blp textures, .mdx models
```

## Language: Jass

All trigger logic is written in **Jass** (Warcraft 3's scripting language). Key traits:
- Statically typed, C-like syntax
- `globals` / `endglobals` blocks declare shared state
- Functions use `function`/`endfunction`, calls use `call`
- Native WC3 API: `CreateUnit`, `TriggerRegisterAnyUnitEvent`, `GetTriggerUnit`, etc.
- No modules or namespacing — globals in `1-init.j` use short obfuscated names (single/double letters); `6-UltimateBuilder.j` uses readable names like `PlayerBuilder`, `UltimateCheck`

The `catalog.lml` defines trigger load order — files are compiled and merged in the listed sequence.

## Game Data (INI Tables)

Unit, ability, buff, and item data in `table/*.ini` use a section-per-object format:

```ini
[hfoo]                  # WC3 unit rawcode
_parent = "hfoo"        # Inherits from base WC3 unit
HP = 250
Hotkey = "Q"
Ubertip = "..."         # Tooltip supports |cffRRGGBB color codes
```

`_parent` specifies the WC3 base object to inherit from. Only overridden fields need to be listed. Rawcodes are 4-character WC3 identifiers (e.g., `hfoo` = Human Footman, `hcas` = Castle).

## Map Metadata

`table/w3i.ini` controls map-level settings: player slots, force alliances, camera bounds, loading screen text, and map flags. Edit this file to change map name, version string, or player configuration.

## Ability System Patterns

Building abilities in `1-init.j` are registered with `aI('rawcode', function handler)`. To find the logic for a building, search for its rawcode:

```
aI('h01F', function yD)   -- Volcano → yD handles the eruption
```

Unit cast abilities use `EI('unit_rawcode', 'ability_rawcode', function handler)` instead:

```
EI('e007', 'A07P', function jg)   -- Druid → jg handles Entangle cast
EI('e00J', 'A07R', function kg)   -- Sage Druid → kg handles Mass Entangle cast
```

The handler function typically creates a dummy unit (`e008`) and adds a damage ability to it. The actual damage values live in `ability.ini`, not in the Jass.

**ACpa + AEer two-ability entangle pattern** — cast ability (ACpa, e.g. `A07P`) is the clickable spell; it fires the Jass handler, which spawns a dummy `e008`, attaches the real AEer ability (e.g. `A07A`), and issues the entangle order on the target. Duration and dps live in the AEer entry, not the ACpa entry (`DataA = 0.0` in ACpa is normal).

**Flame Strike (`AHfs`) damage fields** — used by most AoE damage abilities:

| Field | Meaning |
|---|---|
| `DataA` | Damage per tick |
| `DataB` | Tick interval (seconds) |
| `DataE` | Building damage fraction (e.g. `0.4` = 40%) |
| `DataF` | Max damage per tick across all units — divide by `DataA` to get max unit cap |

Example: `DataA=15, DataB=0.25, DataF=60` → 60 dps, max 4 units (60/15).

## Workflow Notes

- Edit `.j` files for logic changes, `.ini` files for balance/data changes, `.blp`/`.mdx` for visual assets.
- Update `table/w3i.ini` loading screen `text` block for changelog entries visible in-game.
- After edits, repack with w3x2lni to produce a testable `.w3x`.
- Test by opening the `.w3x` in Warcraft 3 (1.26–1.31 recommended for LNI-format maps).
- The `map/war3map.j` file is the compiled output of all trigger files — do not edit it directly.
