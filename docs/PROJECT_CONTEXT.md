# Project context — KallyeRaidFrames

> Scope: what the addon is, who it is for, what it does, how it is built and shipped, and where the
> project stands today. For internal structure see [ARCHITECTURE.md](ARCHITECTURE.md); for weak
> points see [TECHNICAL_DEBT.md](TECHNICAL_DEBT.md).

## 1. One-line summary

**KallyeRaidFrames** (`KRF`) is a World of Warcraft UI addon that reworks Blizzard's compact
raid/party frames (health colouring, inverted bars, names, role icons, range alpha, buff/debuff size
and layout, raid-target icons) and adds a few quality-of-life features such as "always show raid
frames", all of it optional and configurable in a single options window.

- Author: **Kallye of Elune (EU)** — published as "KaspOu" on GitHub.
- Repository: <https://github.com/KaspOu/KallyeRaidFrames>
- License: **All Rights Reserved** (see `License.txt`); vendored code is licensed separately.
- Category: `Raid Frames, Interface Enhancements`.

## 2. Product philosophy

Read from `README.md`, `ChangeLog.txt` and the code:

1. **Personal preferences, made shareable.** The description is literally "Modifications to
   Blizzards default raid/party frames according to my own preferences".
2. **Non-destructive.** The addon never replaces Blizzard frames; it hooks
   (`hooksecurefunc`) and adjusts (`SetPoint`, `SetScale`, `SetAlpha`, textures). Disabling the
   addon restores the default UI.
3. **Everything optional.** Each behaviour has a checkbox; defaults are the author's own setup.
4. **Multi-flavour.** One codebase serves retail 12.x *and* classic-era clients, with three
   different aura implementations behind feature detection.
5. **No dependencies.** Only one bundler library (`LibEditModeOverride-1.0`) plus `LibStub`, pulled
   by the packager. The options system, module system and widget toolkit are home-made
   (`Shared/Module.lua`, `Shared/OptionsAPI.lua`, `Shared/Widgets*`).

## 3. Feature inventory

Mapped to the module that implements it (see `Modules/`).

### 3.1 Raid / party frame enhancements — Core (`Core/KallyeRaidFramesAPI.lua`)

| Feature | Notes |
| --- | --- |
| Health-based background colour | three thresholds `LimitLow` / `LimitWarn` / `LimitOk`, colours `BGColor*` |
| Inverted health bar ("sRaidFrames like") | `RevertBar`, `RevertColor*`, `Limit*` reused as width |
| Skull marker on dead players | `IconOnDeath`, prefix in unit name |
| Out-of-range / out-of-combat transparency | `AlphaInRange`, `AlphaNotInRange`, `AlphaNotInCombat`, hooks `CompactUnitFrame_UpdateInRange` + `UpdateHealthColor` |
| Role icons | moved top-left (`MoveRoleIcons`), DPS icons hidden (`HideDamageIcons`) |
| Realm name removal | `HideRealm` ("Illidan" instead of "Illidan - Varimathras") |
| Health bar texture | `Bar_Texture`, palette of bundled `Files/*` textures |
| Dispel overlay alpha | `AlphaDispelOverlay` |

### 3.2 Buffs & debuffs — `Modules/UnitDebuffs.lua` + `Modules/RaidFrameAuras/`

| Feature | Notes |
| --- | --- |
| Scale, max count, per-line count | buffs and debuffs separately, `Buffs*` / `Debuffs*` options |
| Orientation / anchor offsets / spacing | 4 orientations per aura type; retail 12 adds X/Y spacing |
| Filter selection (`auto`, `all`, `raid`, …) | `BuffsFilter`, `DebuffsFilter` |
| **Excluded buffs** (12.1.502) | `BuffsExcluded` set of spell IDs, edited via the `SpellList` widget |
| Hide tooltip on hover | `BuffsHideTooltip`, `DebuffsHideTooltip` |
| Hide Blizzard default auras | `HideBlizzardAuras` (also toggles the `raidFramesDisplay*` CVars) |
| Master switch | `ActiveUnitDebuffs` |

### 3.3 Nameplates + friendly unit text — `Modules/NameplatesColor.lua`

Class-colour or custom colour for name and health bar, health-bar texture, PvP/faction icon,
player level display with under/over-level colours, separately configured for friends and enemies.

### 3.4 Raid target icons — `Modules/RaidIcons.lua`

Anchor, size and offsets of the raid-target marker on compact frames (`RaidsIcons_*`).

### 3.5 Always-visible raid frames — `Modules/SoloRaidFrames.lua`

Shows raid/party frames while solo (also while in a raid), drives Blizzard's "use raid style party
frames" edit-mode setting through `LibEditModeOverride-1.0` with retry, and opens the Edit Mode UI
(`/krf edit`).

### 3.6 Shell features

| Feature | Where |
| --- | --- |
| Options window (Blizzard Settings category + scrollable panels) | `Core/KallyeRaidFrames.xml`, `KRFUI.OptionsContainer_OnLoad` |
| Real-time application of settings (batched, no reload) | `Shared/OptionsAPI.lua` |
| Reload-required detection for the few options that need it | `RequiredReloadOptionsString()` |
| Addon-compartment button | `Modules/AddonCompartmentFilter.lua` |
| Chat feedback with normal/warning/error verbosity | `Core/KallyeRaidFrames.globals.lua` (`ns.AddMsg*`) |
| Reset-to-defaults confirmation dialog | `StaticPopupDialogs["KallyeRaidFrames_CONFIRM_RESET"]` |
| Test/debug mode (`/krf test`, `/krf debug`) | `Core/KallyeRaidFramesAPI.lua` |

## 4. Supported clients

`KallyeRaidFrames.toc` declares eight interface versions:

```
## Interface: 120100, 120105, 120107, 16001, 50504, 38002, 20506, 11509
```

| Interface | Interpretation |
| --- | --- |
| `120100`, `120105`, `120107` | Retail 12.1.x ("Midnight") — `120105` = 12.1.5 per the changelog; the code path is the `AuraContainer` API |
| `50504` | MoP Classic (5.5.4) |
| `20506` | TBC Classic (2.5.6) |
| `11509` | Classic Era (1.15.9) |
| `38002`, `16001` | Further classic/seasonal builds. **Unconfirmed** — do not guess when bumping; verify against the client build the author actually targets |

Three aura implementations exist and are chosen at runtime, not at load:

1. **Retail 12+** — `AuraContainer` support detected via `IsAuraContainer_Supported()` /
   `ns.HAS_AURACONTAINER`; `UnitDebuffs` configures Blizzard's aura container directly
   (sorting, spacing, filters, exclusions).
2. **Classic-era clients** — `Modules/RaidFrameAuras/` (vendored third-party addon, Apache-2.0) is
   loaded (`RaidFrameAuras.xml` carries `[AllowLoadGameType classic]`) and drives the aura display;
   `Wrapper.lua` maps KRF options onto the RFA database. This subtree is **frozen**: it is not
   maintained, not patched and not localised, and it will be deleted as soon as every supported client
   exposes `AuraContainer` (see `docs/TECHNICAL_DEBT.md` TD-02).
3. **Fallback (pre-12 clients without RFA)** — in-place `hooksecurefunc` on
   `CompactUnitFrame_SetMaxBuffs` / `SetMaxDebuffs` / `DefaultCompactUnitFrameSetup`.

A standalone **Raid Frame Auras** addon is explicitly detected and wins: KRF then disables its own
debuff feature instead of fighting with it.

## 5. The Kallye addon family

`Shared/` is deliberately addon-agnostic because the same files are copied into four sibling addons
(KRF is the reference copy; propagation is one-way, see below):

| Addon | Code | Purpose |
| --- | --- | --- |
| **KallyeRaidFrames** | `KRF` | this repository — raid/party frames |
| KBigDebuffs | `KBD` | larger, prioritised debuffs on unit frames |
| KNameplateColor | `KNC` | nameplate colouring |
| KRaidFade | `KF` | RaidFade-like fading |
| KRaidIcons | `KRI` | raid target icons |

Sharing mechanism:

- **Code**: `.copy_shared.sh` (run through `.copy_shared.bat` → WSL) copies
  `Shared/WidgetsKRF.xml` and the relevant `Shared/Options*KRF.xml` into the sibling repos and
  rewrites the `KRF` prefix with `sed` (`→ KBD`, `→ KNC`, `→ KF`, `→ KRI`).
- **Translations**: within each `Core/localization.<lang>.lua`, the strings that belong to a sibling
  addon are delimited by comment markers `-- KBD START` … `-- KBD END`, `-- KNC START` … etc.
  The script extracts those blocks from the KRF files (`sed -n` range) and replaces the
  corresponding range in each sibling file (`sed -i` delete + insert).
- KRF itself is **not** modified by the script: it is the reference copy, and the direction is strictly
  one-way (KRF → siblings). A sibling repository is never edited by hand and never syncs back; a fix
  made there would be silently overwritten by the next propagation.

Practical consequence: `Shared/` and `Core/localization.*.lua` changes are *cross-project* changes.
The author runs the script manually after a batch of changes; nothing in this repo records whether
the siblings are currently in sync.

## 6. Distribution, licensing, packaging

- Channels: **CurseForge** (`X-Curse-Project-ID: 410566`), **WoWInterface** (`X-WoWI-ID: 26755`),
  **Wago** (`X-Wago-ID: bGoMQr60`), plus the GitHub repository.
- `.pkgmeta`: `package-as: KallyeRaidFrames`, external `Libs/LibEditModeOverride-1.0` from
  <https://github.com/plusmouse/LibEditModeOverride>, `manual-changelog: ChangeLog.txt`,
  `license-output: License.txt`, and an `ignore` list for library/VCS/dev artefacts.
- Licences — three layers:
  - addon code: **All Rights Reserved** (`License.txt`);
  - `Modules/RaidFrameAuras/`: **Apache-2.0**, © Anahkas (`Modules/RaidFrameAuras/LICENSE`, credit
    in `README.md`, full text in `COPYING`);
  - `Libs/LibEditModeOverride-1.0`: **MIT**.
- Assets: `Logo32.tga` (TOC icon), `.logo.png` (store artwork, 1.3 MB), `Files/` (bar textures and
  gradients offered as texture choices in the options UI).
- Release scripts (manual, local, Windows): `.release.bat`, `.release.live.bat`,
  `.release.xcopylibs.bat`. They stage a package and copy libraries; they are **not** CI.

## 7. Development workflow as observed

| Aspect | Reality |
| --- | --- |
| Branching | `main` (released) and `develop` (integration). Tags are bare versions (`12.1.502`). |
| Commit style | gitmoji prefix + English summary, e.g. `:fire: Buffs: Remove legacy display`, `:globe_with_meridians: Fix char encoding`, `:package: 12.1.5` |
| Changelog | hand-written `ChangeLog.txt`, user-facing, one section per published version |
| Versioning | `12.<major>.<build>`, e.g. `12.1.504` — derived from the WoW patch (`12.1.5`) plus a build increment |
| Build | none. Edit files, `/reload` in game. |
| Tests / CI | none — no workflow files, no lint config, no headless harness. The only offline check is `tools/validate_lua.py`, run by hand |
| Static checks | VS Code LuaLS + `ketho.wow-api` annotations (`duplicate-set-field` disabled) for semantics; `python tools/validate_lua.py` for syntax, UTF-8/BOM and marker pairing |
| Agent tooling | `rtk` 1.0.1 (token-filtering CLI proxy — preferred for git/read/find) and Python 3.14 are installed; usage rules in `AGENTS.md` §1 |
| Editor globals | `.vscode/settings.json` lists every Blizzard global the code uses — a handy inventory of touched APIs |
| Sync tooling | `.copy_shared.sh` / `.copy_shared.bat` (WSL), see §5 |

### Typical in-game loop

1. `/console scriptErrors 1` so Lua errors are visible.
2. `/reload` after changing Lua/XML.
3. `/krf` opens the options window; `/krf debug` toggles debug mode; `/krf test` toggles test mode
   (renders with forced health values); `/krf reset` opens the reset confirmation; `/krf edit` jumps
   to Edit Mode for party-frame styling.
4. On classic clients the RaidFrameAuras engine also registers its own chat commands
   (`Modules/ChatCommands.lua`, `/rfa …`); its standalone UI entry points are bypassed by
   `Wrapper.lua`.

## 8. Current state (audit snapshot)

- `main` @ `babbee6` — *":fire: Buffs: Remove legacy display"*; latest tag `12.1.502`.
- TOC declares `12.1.504` and `ns.VERSION` matches, but `ChangeLog.txt`'s newest section is still
  `v12.1.502` → version/changelog drift (tracked in TECHNICAL_DEBT).
- Working tree is dirty: `Core/localization.fr.lua` modified, uncommitted.
- Feature work in flight (from recent commits and changelog): real-time option application
  (12.1.501), `SpellList` widget + excluded-buff filtering (12.1.502), removal of the legacy aura
  display path.
- The vendored `Modules/RaidFrameAuras/` subtree (~7.3 k lines) is the largest body of code in the
  addon and is only exercised on classic-era clients.

## 9. Glossary

| Term | Meaning |
| --- | --- |
| **KRF** | KallyeRaidFrames — this addon; also the shared-code prefix rewritten by the sync script |
| **KBD / KNC / KF / KRI** | KBigDebuffs / KNameplateColor / KRaidFade / KRaidIcons — the sibling addons |
| **RFA** | Raid Frame Auras, the vendored aura engine in `Modules/RaidFrameAuras/` |
| **ns** | the addon-private namespace table (`local addonName, ns = ...`) |
| **`K_SHARED_UI`** | global table of shared widget/options helpers used by all five addons |
| **`KRFUI`** | global namespace of functions called from XML event handlers |
| **Options frame** | the single scrollable options container with `Options1/2/3` sub-panels |
| **AuraContainer** | Blizzard's retail-12 aura rendering API used by the retail code path |
| **Secret value** | retail-12 protected value (`issecretvalue`) that must not be compared or formatted |
| **Compact frames** | Blizzard `CompactUnitFrame` widgets used for the party/raid display |
| **Edit Mode** | Blizzard's UI layout editor, driven here through `LibEditModeOverride-1.0` |


