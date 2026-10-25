# AGENTS.md — Working rules for KallyeRaidFrames

Guidance for AI agents (and humans) modifying **KallyeRaidFrames** (`KRF`), a World of Warcraft
UI addon written in **Lua 5.1 + XML**. It is not a web/JS project: there is no build, no package
manager, no test runner and no CI. Everything ships as plain source files that the WoW client loads
directly. The only automation is a Python syntax gate in `tools/` (see §1).

Deep dives:

- [docs/PROJECT_CONTEXT.md](docs/PROJECT_CONTEXT.md) — product scope, addon family, workflow
- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) — load order, namespace contract, options/module systems
- [docs/TECHNICAL_DEBT.md](docs/TECHNICAL_DEBT.md) — known weak spots and how to avoid making them worse
- [tools/README.md](tools/README.md) — offline checks (`validate_lua.py`, the Lua 5.1 syntax gate)

---

## 1. Ground truth

| Item | Value |
| --- | --- |
| Addon folder / TOC | `KallyeRaidFrames/` + `KallyeRaidFrames.toc` |
| Declared version | `## Version: 12.1.504` (TOC), `## Version: 12.1.502` (top `ChangeLog.txt` entry) |
| Saved variables | `KallyeRaidFramesOptions` (account-wide; `## LoadSavedVariablesFirst: 1`) |
| Slash commands | `/krf`, `/kallye`, `/kallyeraidframes`, plus `/clear` (chat clear) and a key binding in `Bindings.xml` |
| Runtime | WoW Lua 5.1, secure frames, `hooksecurefunc`, XML templates |
| Interface IDs | `120100, 120105, 120107, 16001, 50504, 38002, 20506, 11509` (retail 12.1.x + classic-era clients) |
| Localization | 9 locale files + English fallback, embedded in `Core/localization.*.lua` |
| License | Addon: **All Rights Reserved**. `Modules/RaidFrameAuras/` is vendored **Apache-2.0** (© Anahkas). `Libs/LibEditModeOverride-1.0` is **MIT** |
| Git | branches `main` (release) and `develop`; history uses gitmoji-style commits; tags look like `12.1.502` |
| Packaging | BigWigs-style packager: `.pkgmeta` (+ `externals` for `LibEditModeOverride`), `ChangeLog.txt`, `License.txt` |

### What you may run

- `rtk git status`, `rtk git log`, `rtk git diff` — always useful before/after an edit (see *Tooling*
  below; drop to plain `git` only when you need byte-exact output).
- `python tools/validate_lua.py` — the syntax gate; run it after **every** Lua edit.
- `rtk read` / `rtk find` / `rtk err` for reading and searching; PowerShell (`Select-String`,
  `Get-Content`) where rtk has no equivalent.
- **Do not** invent `npm test`, `pytest`, `luacheck`, `make`, etc. They do not exist here — no Lua
  interpreter is installed either, `tools/validate_lua.py` is the substitute.
- `.release.bat`, `.release.live.bat`, `.release.xcopylibs.bat` and `.copy_shared.sh` / `.copy_shared.bat`
  **mutate state outside this repository** (they copy/overwrite sibling addon folders and build a
  release zip). Never run them unless the user explicitly asks.
- Static analysis is only whatever the editor Lua language server reports
  (`.vscode/settings.json`: Lua 5.1, `ketho.wow-api` annotations, `duplicate-set-field` disabled),
  plus `tools/validate_lua.py` for syntax.

### Tooling installed on this machine

Two helpers are available and are expected to be used. There is still **no** Lua interpreter
(`lua`, `luac`, `luacheck` are all absent), so Lua is only ever checked by `tools/validate_lua.py`.

| Tool | What is installed | Use it for |
| --- | --- | --- |
| `rtk` | `rtk 1.0.1`, WinGet package `rtk-ai.rtk` (config written on first use to `%APPDATA%\rtk\config.toml`) | a token-filtering proxy in front of normal commands: **always prefer `rtk <cmd>`** |
| `python` | Python 3.14 at `%LOCALAPPDATA%\Programs\Python\Python314\python.exe`, on the user PATH (`python`, `py`) | temporary scripts and `tools/validate_lua.py` |

If a terminal was opened *before* the install its `PATH` is stale; refresh it in that session:

```powershell
$env:PATH = [Environment]::GetEnvironmentVariable('PATH', 'Machine') + ';' +
            [Environment]::GetEnvironmentVariable('PATH', 'User')
```

#### `rtk` — the default way to run git and to read files

`rtk` is a CLI proxy that filters and summarises command output before it reaches the agent context
(same information, a fraction of the tokens). **Use `rtk <cmd>` whenever an equivalent exists**, and
drop to the plain command only when rtk cannot do it or when byte-exact output matters.

| Task | Use this | Instead of |
| --- | --- | --- |
| working tree | `rtk git status` | `git status` |
| recent history | `rtk git log -5` | `git log -5` |
| changed lines | `rtk git diff`, `rtk git diff --staged` | `git diff` |
| one commit | `rtk git show <rev>` | `git show` |
| branches | `rtk git branch` | `git branch` |
| file content | `rtk read -n <file>` | `cat` / `Get-Content` |
| head/tail of a file | `rtk read --head-lines 40 <file>` | `Get-Content -First 40` |
| locate files | `rtk find . -name "*.lua"` | `Get-ChildItem -Recurse -Filter` |
| only the errors of a command | `rtk err <cmd…>` | `2>&1 \| Select-String error` |
| anything else | `rtk run <cmd…>` or `rtk run -c "<shell string>"` | the raw command |
| savings report | `rtk gain` | — |

Verified failures on this Windows box — the filter proxies a Unix binary that is not installed, so do
not waste a call: `rtk ls`, `rtk tree`, `rtk wc`, `rtk grep`, `rtk rg`. Use `Get-ChildItem`,
`Select-String` or `rtk find` instead. Toolchain filters (`rtk npm`, `rtk dotnet`, `rtk cargo`,
`rtk docker`, …) are irrelevant for this repository.

Two cautions:

- filtered output is **not** byte-exact: never copy code out of `rtk git diff` or `rtk read --level`;
  read the real file before editing it.
- never let rtk wrap the state-changing scripts (`.release*.bat`, `.copy_shared.*`) — and run those
  only when explicitly asked, whatever the wrapper.

#### `python` — temporary scripts and the syntax gate

- Python 3.14 is on the user PATH (`python`, `py`). **Standard library only**: no `pip install`, no
  virtualenv — this repository must stay dependency-free and reproducible.
- Throw-away helpers: write them to `tools/_tmp_<topic>.py`, use them, then **delete** them before you
  finish (they must not end up in a commit or in a diff you report). Anything worth keeping goes into
  `tools/` with a module docstring, a `--selftest`, and a mention in this file.
- Pass explicit encodings (`open(path, "rb")`, or `encoding="utf-8"`): sources are UTF-8 without BOM
  while the console is cp1252. Print ASCII only, or the output gets mangled.

### Lua syntax gate: `python tools/validate_lua.py`

The repository's only automatic check. Run it **after every edit** of a `.lua` file, before you report
back:

```powershell
python tools/validate_lua.py                              # whole repo (.git/.release/.sfdx/docs skipped)
python tools/validate_lua.py Modules/UnitDebuffs.lua Core # only what you touched
python tools/validate_lua.py -v                           # + one line per clean file
python tools/validate_lua.py --selftest                   # prove the checker itself still works
```

It prints `path:line:col: error: message` and exits `1` if anything failed (`0` clean, `2` bad
invocation), so it can be wired into a pre-commit hook or CI as-is. What it checks:

- Lua 5.1 lexing — short/long strings and comments, numbers, `\` escapes, unterminated literals, raw
  newlines inside `"…"`, characters Lua 5.1 rejects (`!=`, `&&`, `||`, `$`, non-ASCII identifiers);
- block structure — `function`/`if`/`for`/`while`/`do` closed by `end`, `repeat` closed by `until`,
  missing `then`/`do`, `elseif`/`else` outside an `if`, duplicate `else`, unbalanced `()`/`[]`/`{}`;
- Kallye specifics — UTF-8 **without BOM**, `--@do-not-package@` … `--@end-do-not-package@` pairing and
  `-- KBD|KNC|KF|KRI START|END` locale-block pairing (disable with `--no-extra`);
- vendored code is scanned on purpose (`Libs/`, `Modules/RaidFrameAuras/`): you must not *edit* it
  (§10), but its syntax still has to be valid — a syntax error there breaks the addon just as well.

What it does **not** check: XML, TOC entries, `parentKey` vs `defaultOptions`, `l.KEY` existence, load
order, `ns.*` availability, or any runtime behaviour. Those stay manual (see §4 and
`docs/TECHNICAL_DEBT.md` TD-08).

### Definition of "validated" here

Automation stops at syntax (the gate above). A change is validated when:

1. `python tools/validate_lua.py` (or `… <files you touched>`) reports 0 errors, and any new `.lua`
   file is listed in `KallyeRaidFrames.toc` (the gate does not read XML or the TOC — see item 2);
2. every new option has a matching XML control, a default value, and a locale entry;
3. every `ns.*` / `K_SHARED_UI.*` symbol it calls actually exists at the time it is called
   (see load order in `docs/ARCHITECTURE.md` §3);
4. the user tested it in game (`/reload`, `/krf`, `/console scriptErrors 1`).

State clearly in your final answer that in-game verification is required.

---

## 2. The five-addon family — the single biggest hazard

`Shared/` and `Core/localization.*.lua` in this repository are the **source of truth** for four
sibling addons:

| Addon | Code | What it shares from KRF |
| --- | --- | --- |
| **KallyeRaidFrames** (this repo) | `KRF` | reference copy — the source of truth |
| KBigDebuffs | `KBD` | `Shared/OptionsUnitDebuffsKRF.xml`, `Shared/WidgetsKRF.xml`, `-- KBD START/END` locale blocks |
| KNameplateColor | `KNC` | `Shared/OptionsNameplatesColorKRF.xml`, `Shared/WidgetsKRF.xml`, `-- KNC START/END` blocks |
| KRaidFade | `KF` | `Shared/WidgetsKRF.xml`, `-- KF START/END` blocks |
| KRaidIcons | `KRI` | `Shared/OptionsRaidIconsKRF.xml`, `Shared/WidgetsKRF.xml`, `-- KRI START/END` blocks |

Propagation is done by the author, manually, with `.copy_shared.sh` (invoked through
`.copy_shared.bat` under WSL). It `cp`s the shared XML files into `../KBigDebuffs`, `../KNameplateColor`,
`../KRaidFade`, `../KRaidIcons` and rewrites the prefix with `sed 's/KRF/KBD/g'` (etc.), then replaces
the marked localization blocks with `sed -n` / `sed -i` range extraction.

The direction is **strictly one-way**: KRF is the reference implementation and the other four are
generated downstream copies. Shared code is edited **here**, never in a sibling, and there is no
back-sync. If a sibling is wrong, KRF is wrong too (or the copy is stale) — fix it in KRF first, then
propagate. Never patch a sibling repository and never port a change back into KRF: the next
propagation would overwrite it silently.

Consequences you must respect:

1. **Editing `Shared/WidgetsKRF.xml`, `Shared/Options*KRF.xml`, `Shared/*.lua` or any
   `Core/localization.*.lua` file changes behaviour in up to 4 other addons** once propagated.
   Say so explicitly in your summary and tell the user to run `.copy_shared.bat` if propagation is wanted.
2. Keep the `KRF` prefix naming convention consistent. The `sed` rewrites are **blind text
   substitutions**: any literal `KRF` inside those files (template names, frame names, `<Include>`
   targets, comments, tooltip strings, even `Interface\AddOns\KallyeRaidFrames\...`) is rewritten
   in the siblings. When KNameplateColor needs `KallyeRaidFrames` → `KNameplateColor`, that is a
   separate `sed` line; nothing else gets that treatment.
3. Never rename or reflow the locale block markers `-- KBD START`, `-- KBD END`, `-- KNC START`,
   `-- KNC END`, `-- KF START`, `-- KF END`, `-- KRI START`, `-- KRI END`. They are the anchors the
   sync script matches. Put the marker on its own line, with that exact spelling and one space.
4. `Shared/` code must stay addon-agnostic: use `ns.*` / `K_SHARED_UI.*`, never hardcode
   `"KallyeRaidFrames"` or `KallyeRaidFramesOptions` there.
5. `.copy_shared.sh` and `.copy_shared.bat` must stay behaviourally identical (the `.bat` just runs
   the `.sh` through WSL). If you touch one, update the other.
6. Order of operations for a shared change: edit **here** → run the Lua gate (`python
   tools/validate_lua.py`) → propagate (`.copy_shared.bat`) → re-read the generated sibling files and
   confirm the prefix/asset paths were rewritten correctly. Never the other way round.

---

## 3. Where to change what

| I want to… | Touch these files |
| --- | --- |
| Add/change a core (non-module) option | `Core/KallyeRaidFrames.lua` (`defaultOptions`), `Core/KallyeRaidFrames.xml` (the control), `Core/KallyeRaidFramesAPI.lua` (behaviour), all `Core/localization.*.lua` (`OPTION_…` label + `OPTION_TOOLTIP_…`) |
| Add/change a buffs & debuffs option | `Core/KallyeRaidFrames.lua` (defaults), `Shared/OptionsUnitDebuffsKRF.xml` (control), `Shared/OptionsUnitDebuffs.lua` (visibility logic), `Modules/UnitDebuffs.lua` (behaviour), locales |
| Add/change a nameplate option | `Shared/OptionsNameplatesColorKRF.xml`, `Shared/OptionsNameplatesColor.lua`, `Modules/NameplatesColor.lua`, locales |
| Add/change a raid-icon option | `Shared/OptionsRaidIconsKRF.xml`, `Shared/OptionsRaidIcons.lua`, `Modules/RaidIcons.lua`, locales |
| Change health highlighting, names, role icons, range alpha | `Core/KallyeRaidFramesAPI.lua` |
| Change "always show raid frames" / edit-mode glue | `Modules/SoloRaidFrames.lua`, `KRFUI.SetUseRaidStylePartyFrames` in `Core/KallyeRaidFrames.lua` |
| Change the options window shell, scrolling, reset dialog | `Core/KallyeRaidFrames.lua` (`KRFUI.OptionsContainer_OnLoad`, `StaticPopupDialogs`), `Core/KallyeRaidFrames.xml` |
| Add a reusable widget | `Shared/WidgetsKRF.xml` (template) + `Shared/Widgets.lua` (handler) — **propagates to all 5 addons** |
| Change slash commands / chat output | `Core/KallyeRaidFrames.lua` (`SLASH_KRF_command`), `Core/KallyeRaidFrames.globals.lua` (`ns.AddMsg*`) |
| Change buff/debuff rendering internals | `Modules/UnitDebuffs.lua` (the `AuraContainer` path for retail 12+). Do **not** touch `Modules/RaidFrameAuras/*`: vendored, frozen, to be deleted (TD-02) |
| Change packaging/release | `KallyeRaidFrames.toc`, `.pkgmeta`, `ChangeLog.txt`, `License.txt`, `.release*.bat` |
| Change the offline syntax gate | `tools/validate_lua.py` (`SELFTEST_CASES` + the checkers) and `tools/README.md` |

The three XML options panels (`Options1/2/3` in `Core/KallyeRaidFrames.xml`) include the shared
option files. A control's **key** (`parentKey`) must equal the option name; that name is the only
link between XML and the options table.

---

## 4. Recipe: add a new option

1. **Default value** — add it to `defaultOptions` in `Core/KallyeRaidFrames.lua`
   (`local defaultOptions = {…}`), or to the module's own defaults if the module owns them.
   Types matter: `boolean` → checkbox, `number` → slider, `string` → dropdown, `{r,g,b,a}` → color.
2. **Control** — add it to the relevant options XML with:
   - `name="KRFUI_…"` unique global name (do not reuse names across panels),
   - `parentKey="MyOptionName"` **exactly equal** to the option name,
   - `inherits="KRFUI_CheckboxWidget"` / `KRFUI_SliderWidget` / `KRFUI_ColorWidget` /
     `KRFUI_DropDownWidget` / `KRFUI_SpellListWidget` (case must match `WidgetsKRF.xml` exactly),
   - `Attributes` holding the **localization key** of the label (`label`) and a `tooltip` attribute
     for the tooltip key. Widgets resolve `l(key) or _G[key] or key`, so a Blizzard global such as
     `NONE` also works.
3. **Behaviour** — read the value live (`options.MyOptionName`), not a cached copy, and re-apply it
   to already-displayed frames. For modules, do it in `onOptionsChanged(self, options, changed)`
   and use `changed` to skip work when your option was not touched.
4. **Localization** — add the label/tooltip key to `Core/localization.en.lua` **and** to the other
   locales (at minimum `fr`); if the option is shared, also inside the correct
   `-- KBD/KNC/KF/KRI START…END` block.
5. **Reload requirement** — if the option genuinely cannot be applied live, add it to
   `RequiredReloadOptionsString()` in `Core/KallyeRaidFrames.lua`. Do not mark reload-only what can
   be applied live (users complained; see ChangeLog 12.1.501 "Settings are now applied in real time").

Checklist: default ✔ control ✔ `parentKey` ✔ label key ✔ tooltip key ✔ locales ✔ applied live ✔
visibility/enabled-state logic (`ns.OptionsEnable`, `ns.IsModuleEnabled`) ✔.

---

## 5. Recipe: add a new module

1. Create `Modules/MyThing.lua` starting with the standard preamble:

   ```lua
   local addonName, ns = ...;
   local l = ns.I18N;

   -- * avoid conflict override
   if ns.CONFLICT then return; end
   ```

2. Register at the bottom: `local module = ns.Module:new(onInit, "MyThing")`, then
   `module:SetOnOptionsChanged(onOptionsChanged)` / `module:SetGetInfo(getInfo)` when relevant.
   `ns.Module:new` appends to `ns.MODULES`, so runtime order follows `Modules/modules.xml`.
3. Add `<Script file="MyThing.lua"/>` to `Modules/modules.xml` **after** anything it depends on.
   `SoloRaidFrames.lua` must stay loaded before `UnitDebuffs.lua`: it defines
   `ns.CanEditActiveLayout` / `ns.GetUseRaidStylePartyFrames`, used by the Core options UI and the
   debuff module.
4. Add its options to the appropriate XML panel and, if needed, a "module enabled" checkbox.
5. Localize its messages (`MSG_…`) in all locale files.

Never call `ns.Module:new` at a point where `ns.Module` may still be `nil`, and never assume
`ns.Module.cacheOptions` is populated before `Init` runs (it is set during `ADDON_LOADED`).

---

## 6. Localization rules

- `ns.I18N` is one flat table created in `Core/KallyeRaidFrames.globals.lua`; `Core/localization.en.lua`
  seeds English, and the 8 other files overwrite entries. Each locale file is gated in the TOC by
  `## AllowLoadTextLocale frFR` (etc.), so only the active language is loaded.
- Keys are `SHOUTY_SNAKE_CASE`. Colour helpers live beside them (`l.WH`, `l.YL`, `l.RD`, `l.GR`,
  `l.TB`, `l.YLD`, …): reuse them instead of writing raw `|cff…` escapes.
- Naming in use: `l.MSG_*`, `l.OPTION_*`, `l.OPTION_TOOLTIP_*`, `l.OPTION_GROUP_*`.
- `l.UpdateLocales` (defined in `Core/localization.en.lua`, overridden per locale) is called once on
  `ADDON_LOADED` for strings that need live API state (edit-mode availability, loaded engine…). If a
  string depends on runtime state, build it there — never at file load.
- Files must remain **UTF-8 without BOM** (checked: no BOM anywhere in the repo). Commit `541c29e`
  (`Fix char encoding`) exists because this broke once; keep accents and emoji intact.
- Strings passed to `ns.AddMsg*` go through `string.format`, so a literal `%` throws. Escape as `%%`.

---

## 7. Versioning, changelog, release

- Version has a **single source**: `## Version:` in `KallyeRaidFrames.toc`. `ns.VERSION` is read from
  the TOC metadata at load (`Core/KallyeRaidFrames.globals.lua`), together with `ns.VERSIONNR`; the
  value drives `defaultOptions.Version` and therefore the "what's new" message (`l.WHATSNEW`).
  Only the TOC and `ChangeLog.txt` need editing — but they must be kept in agreement (they currently
  are not, see `docs/TECHNICAL_DEBT.md`).
- Add a matching `v12.1.xxx` section at the top of `ChangeLog.txt` (shipped via `.pkgmeta`
  `manual-changelog` to CurseForge / WoWInterface / Wago).
- Releases are built locally by `.release.bat` / `.release.live.bat` / `.release.xcopylibs.bat`.
  `.pkgmeta` pulls `LibEditModeOverride-1.0` from GitHub as an external; `--@do-not-package@ …
  --@end-do-not-package@` blocks are stripped from the package.
- Do not create tags, commit, push or run release scripts unless asked.

---

## 8. Code conventions

- **Prefixes**: `ns.*` = addon-internal API; `K_SHARED_UI.*` = cross-addon shared UI API;
  `KRFUI.*` = entry points called from XML `<OnLoad>` / `<OnClick>`; `K_Global_Vars.*` = globals
  shared by all K* addons; `KRF.*` = dev/debug scratch namespace.
- **XML contains no logic.** It only calls `K_SHARED_UI.SomeWidget_OnLoad(self)` or
  `KRFUI.SomeHandler(self)`.
- **Do not reformat files.** Indentation is 4 spaces in most files but tabs in `UnitDebuffs.lua` and
  `Widgets.lua`; semicolons are used consistently in Core files and omitted in newer module code.
  Match the surrounding lines.
- **Comment markers are meaningful**: `-- !` important, `-- *` note, `-- ?` history/rationale,
  `--@ Class …` LuaLS annotation header, `--#region` / `--#endregion` sections in `Shared/*.lua`.
  Preserve them and their placement.
- **Dev-only code** belongs between `--@do-not-package@` and `--@end-do-not-package@` (e.g. the dev
  `defaultOptions` overrides in `Core/KallyeRaidFrames.lua`, the Plater reference notes at the end of
  `UnitDebuffs.lua`).
- `---@diagnostic` comments are intentional; keep them when moving code.
- WoW Lua is 5.1 **plus** Blizzard globals (`foreach`, `tContains`, `format`, `strsub`, `wipe`,
  `Mixin`, `CreateColor`, `GetUnitName`, …). New Blizzard globals must be added to
  `Lua.diagnostics.globals` in `.vscode/settings.json` to keep the editor quiet.
- Avoid new global variables; everything belongs on `ns`, `K_SHARED_UI` or `KRFUI`.
- Guard every secure-frame mutation with `InCombatLockdown()` and defer via `C_Timer.After` when
  needed (see `SoloRaidFrames.lua`, `ns.ApplyFuncToRaidFrames`).

---

## 9. Client-version rules (retail vs classic)

Several different aura/raid-frame implementations coexist. Branch on the existing helpers — never
hardcode a client check of your own:

- `ns.HAS_AURACONTAINER` / `IsAuraContainer_Supported()` → retail 12+ (`AuraContainer` API), handled
  by `Modules/UnitDebuffs.lua` → `ApplyAuraContainer`.
- `ns.LoadRaidFramesAuras` → the vendored RaidFrameAuras engine, used on classic-era clients
  (`RaidFrameAuras.xml` is `[AllowLoadGameType classic]`). Third-party, **frozen and unmaintained**:
  it will be deleted as soon as every supported client exposes `AuraContainer` (see
  `docs/TECHNICAL_DEBT.md` TD-02). Read it, do not edit it.
- neither → legacy `hooksecurefunc("CompactUnitFrame_SetMaxBuffs", …)` path (pre-12 clients).
- `ns.HAS_SECRETS` → retail "secret values" protections (`issecretvalue`); never compare or format a
  secret value directly, use the helpers.
- A standalone `RaidFrameAuras` addon is detected at `ADDON_LOADED`: `ns.LoadRaidFramesAuras` is
  nulled and `ActiveUnitDebuffs` forced to `false` (message + reload warning).

---

## 10. Do not touch

- `Libs/` — third-party, restored by `.pkgmeta` externals.
- `Modules/RaidFrameAuras/` — a third-party project vendored under Apache-2.0 (© Anahkas), **frozen and
  unmaintained here**. It is not a maintenance target: it exists only for classic-era clients and will
  be deleted as soon as every supported client exposes `AuraContainer` (`docs/TECHNICAL_DEBT.md`
  TD-02). Do not patch it, do not add options or strings, do not "fix" its TODOs/FIXMEs; keep `LICENSE`
  and the header comments. Anything KRF needs belongs in `Modules/UnitDebuffs.lua` (or in KRF's own
  files), never inside the subtree — `Wrapper.lua` is part of it and disappears with it. Its files load
  **before** `Core/KallyeRaidFrames.globals.lua`, so their top-level `local l = ns.I18N` is `nil` —
  never add `l` reads there; the subtree localizes through `Util.T` (`ns.L`, English fallback).
- `.release*.bat`, `.copy_shared.sh`, `.copy_shared.bat` — only when explicitly requested; they
  write outside this repository.
- Binary assets: `.logo.png`, `Logo32.tga`, `Files/*.blp|tga`, `Modules/RaidFrameAuras/LICENSE`.
- `--@do-not-package@` blocks and `.vscode/settings.json` globals ordering (keep it sorted-ish and
  append-only).
- Uncommitted user work: `git status` currently shows a modified `Core/localization.fr.lua`. Do not
  revert or overwrite it.


