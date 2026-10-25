# Architecture — KallyeRaidFrames

> How the addon is wired: load order, namespaces, the home-made module/options/widget frameworks,
> the three aura implementations, and the cross-addon sharing scheme.
> For *what* the addon does see [PROJECT_CONTEXT.md](PROJECT_CONTEXT.md); for *what to avoid*
> see [TECHNICAL_DEBT.md](TECHNICAL_DEBT.md).

## 1. Layered overview

```
                +-----------------------------------------------------------+
   Blizzard UI  |  CompactUnitFrame API · Settings · Edit Mode · AuraContainer|
                +-----------------------------------------------------------+
                                     ^  hooks / direct config
+-------------------+   +-------------------------+   +-----------------------+
| Core (application)|   | Shared framework        |   | Modules (features)    |
| globals, API,     |<->| Module.lua (module      |<->| AddonCompartmentFilter|
| options shell,    |   |   registry/lifecycle)   |   | NameplatesColor       |
| slash commands    |   | OptionsAPI.lua (values, |   | RaidIcons             |
|                   |   |   batching, controls)   |   | SoloRaidFrames        |
|                   |   | Widgets*.lua/xml (UI)   |   | UnitDebuffs           |
+-------------------+   +-------------------------+   | RaidFrameAuras (vend.)|
         ^                          ^                 +-----------------------+
         |                          |
         +-------- Core/localization.*.lua (ns.I18N) ----------+
```

Three rules hold the design together:

1. **One namespace object per addon.** Every Lua file starts with `local addonName, ns = ...`; XML
   files see it through the second `<Script>`/`<Include>` return value. There are no per-file module
   globals.
2. **XML is declarative only.** Templates live in `Shared/WidgetsKRF.xml`; behaviour lives in
   `Shared/Widgets.lua` as `K_SHARED_UI.*` handlers referenced from `<Scripts>`.
3. **Templates are bound to options by name.** A control whose key is `MaxBuffs` drives the option
   `MaxBuffs`. No mapping tables, no registration calls — the name *is* the contract.

## 2. Directory map

| Path | Lines (approx.) | Responsibility |
| --- | --- | --- |
| `KallyeRaidFrames.toc` | 46 | metadata, interface versions, **load order** |
| `Core/KallyeRaidFrames.globals.lua` | 110 | `ns` constants, feature flags, colour table, `ns.AddMsg*`, `KRFUI`, `KRF_TITLE` |
| `Core/localization.en.lua` | 226 | English strings + `l.UpdateLocales` (implemented per locale) |
| `Core/localization.{fr,de,es,it,ko,pt,ru,zh}.lua` | ~215–230 each | translations + sibling-project blocks |
| `Core/KallyeRaidFrames.lua` | 435 | `defaultOptions`, event loop, init, slash commands, reset dialog, `KRFUI.*` XML entry points, options container setup, reload-required baseline |
| `Core/KallyeRaidFramesAPI.lua` | 660 | compact-frame hooks: names, health colour, role icons, range alpha, textures, debug/test |
| `Core/KallyeRaidFrames.xml` | 554 | settings panel(s), scroll container, `Options1/2/3`, shared option includes, handlers |
| `Shared/Module.lua` | 103 | `ns.Module` class + `ns.MODULES` registry |
| `Shared/OptionsAPI.lua` | 357 | defaults merge, control lookup/read/write, change batching, refresh, enable/disable helpers, reset |
| `Shared/Widgets.lua` | 470 | widget handlers (checkbox, colour, slider, heading, text, dropdown), tooltips, label localisation |
| `Shared/Widgets_SpellList.lua` | 374 | scrollable spell-ID list widget (excluded buffs) |
| `Shared/WidgetsKRF.xml` | 130 | the widget templates (`KRFUI_*Widget`) |
| `Shared/OptionsNameplatesColorKRF.xml` / `.lua` | 363 / 56 | nameplate panel + its visibility logic |
| `Shared/OptionsUnitDebuffsKRF.xml` / `.lua` | 358 / 59 | buffs/debuffs panel + its visibility logic |
| `Shared/OptionsRaidIconsKRF.xml` / `.lua` | 85 / 11 | raid-icon panel |
| `Modules/modules.xml` | 9 | module load order |
| `Modules/*.lua` | 16–901 | the five modules |
| `Modules/RaidFrameAuras/**` | ~7 300 | vendored third-party Raid Frame Auras engine (classic path) — **frozen, to be deleted** (TD-02) |
| `Libs/LibEditModeOverride-1.0`, `Libs/LibStub` | — | external libraries (packaged, not versioned here) |
| `Files/`, `Logo32.tga`, `.logo.png` | — | textures and artwork |

## 3. Load order (the most important section)

`KallyeRaidFrames.toc` loads, in this exact order:

| # | Entry | Notes |
| --- | --- | --- |
| 1 | `Modules\RaidFrameAuras\RaidFrameAuras.xml` `[AllowLoadGameType classic]` | **first thing loaded**; its own XML includes `Core.lua`, `Shared.lua`, `Config/*`, `Modules/*`, `UI/Frames.lua`, and `Wrapper.lua` **last** |
| 2 | `Core\KallyeRaidFrames.globals.lua` | creates `ns.VERSION`, `ns.I18N`, `KRFUI`, feature flags |
| 3 | `Core\localization.en.lua` | seeds `ns.I18N` |
| 4–11 | `Core\localization.{fr,de,es,it,ko,pt,ru,zh}.lua` | each gated by `[AllowLoadTextLocale xxXX]` |
| 12–13 | `Libs\LibEditModeOverride-1.0\LibStub\LibStub.lua`, `LibEditModeOverride.lua` | library registration |
| 14 | `Shared\WidgetsKRF.xml` → `Include Widgets.lua` | defines `K_SHARED_UI` table + widget handlers, then the templates |
| 15 | `Shared\Widgets_SpellList.lua` | `SpellList` widget implementation |
| 16 | `Core\KallyeRaidFramesAPI.lua` | `ns.Hook_*`, `K_Global_Vars` helpers |
| 17 | `Modules\modules.xml` | `Shared/Module.lua` (defines `ns.Module`, `ns.MODULES`), then `AddonCompartmentFilter`, `NameplatesColor`, `RaidIcons`, `SoloRaidFrames`, `UnitDebuffs` |
| 18 | `Core\KallyeRaidFrames.xml` → `Include` shared options XMLs, `Include KallyeRaidFramesAPI.lua`(already loaded), panels | creates the options frames and calls `KRFUI.OptionsContainer_OnLoad` |

Consequences that are easy to get wrong:

- **`Modules/RaidFrameAuras/*` runs before `ns.I18N` exists**, so its top-level `local l = ns.I18N` is
  `nil`. Nothing dereferences `l` there (verified: zero `l.` accesses) and the subtree localizes through
  `Util.T()`, which reads `ns.L` — itself never assigned, so RFA-side strings are **English
  fallbacks**. That is harmless today and becomes moot when the subtree is deleted; just never add
  `l.x` there. No consequence for the rest of the addon: KRF's own strings are localized normally.
- **RFA's `Wrapper.lua` defines `ns.LoadRaidFramesAuras` / `ns.SyncRaidFramesAuras` very early**, which
  is why `Core/localization.*.lua` can test `ns.LoadRaidFramesAuras` while building the debuff
  option tooltip (it appears only on classic-style clients), and why `UnitDebuffs` can branch on it.
- **`ns.Module` only exists from entry #17 onwards.** Anything that calls `ns.Module:new` must be
  loaded after `Modules/modules.xml`; anything that *uses* `ns.Module.cacheOptions` must run after
  `ADDON_LOADED`.
- **`SoloRaidFrames.lua` defines `ns.CanEditActiveLayout` / `ns.GetUseRaidStylePartyFrames`**, used by
  `Modules/UnitDebuffs.lua` and by `Core/KallyeRaidFrames.lua`. It must stay **before** `UnitDebuffs.lua`
  in `modules.xml` (the Core file is loaded later anyway).
- **`K_SHARED_UI` is created by `Widgets.lua`, not by the Core.** `Shared/OptionsAPI.lua` (functions
  on `K_SHARED_UI`) is a separate file that is *not* in the TOC — it is `Include`d from
  `Core/KallyeRaidFrames.xml` (last), so `K_SHARED_UI.NotifyControlChanged` etc. exist before the
  options frames finish loading, but **not** before `Widgets.lua`.
- **`[AllowLoadGameType classic]`** on the RFA XML and `[AllowLoadTextLocale …]` on locales are the
  only conditional-loading mechanisms; everything else is runtime feature detection.

## 4. Namespace contract

### 4.1 `ns` — created in `Core/KallyeRaidFrames.globals.lua`

| Field | Meaning |
| --- | --- |
| `ADDON_NAME`, `TITLE`, `VERSION`, `VERSIONNR`, `ICON`, `OPTIONS_NAME`, `SLASHCMD` | identity, read from TOC metadata |
| `IS_RETAIL`, `IS_FOREVER`, `HAS_SECRETS`, `HAS_AURACONTAINER`, `HAS_colorNameBySelection` | client feature flags |
| `DEFAULT_MAXBUFFS`, `DEFAULT_MAXDEBUFFS`, `DEFAULT_RAIDICON_SIZE`, `DEFAULT_ALPHA_OUTOFRANGE` | flavour-dependent defaults |
| `I18N` | the localization table (`l` everywhere) |
| `AddMsg`, `AddMsgWarn`, `AddMsgErr`, `AddMsgDebug` | chat output respecting user verbosity options |
| `CONFLICT`, `CONFLICT_WITH`, `CONFLICT_RFA` | conflict guards; when set, every module/UI file returns early |
| `MODULES`, `Module` | module registry + class (`Shared/Module.lua`) |
| `SetDefaultOptions`, `RefreshOptions`, `FindControl`, `ReadControlValue`, `WriteControlValue`, `SetOptionValue`, `BindOptionControls`, `NotifyOptionsChanged`, `FlushOptionsChanges`, `ResetOptions` | options pipeline (`Shared/OptionsAPI.lua` and Core) |
| `OptionsEnable`, `OptionsSetShownAndEnable`, `OptionsSiblingsEnable`, `IsModuleEnabled`, `SetGradientBg` | options UI helpers |
| `ApplyFuncToRaidFrames`, `Hook_*`, `RaidFrames_ResetHealth`, `HasCustomAuraLayout`, `CompactUnitFrame_UpdateAurasInternal` | raid-frame/aura implementation |
| `LoadRaidFramesAuras`, `SyncRaidFramesAuras` | RFA bridge (may be `nil`) |
| `optionsFrame`, `containerFrame`, `scrollFrame` | the constructed options UI |
| `_optionByControl`, `_pendingChanges`, `_isFlushScheduled`, `_loadingControls`, `_InRangeHooked`, `_UnitDebuffsHooked` | internal state |

### 4.2 Global tables (deliberately global — shared across the 5 addons)

| Global | Owner | Role |
| --- | --- | --- |
| `K_SHARED_UI` | `Shared/Widgets.lua` | widget handlers, `AddRefreshOptions`, `RefreshOptions`, `NotifyControlChanged`, tooltip helpers; survives the prefix rewrite |
| `K_SHARED_UI.I18N` | `Shared/Widgets.lua` | `[ns.ADDON_NAME] = ns.I18N` registry so shared widgets can translate labels of *any* loaded K* addon |
| `KRFUI` | `Core/KallyeRaidFrames.globals.lua` | functions called from XML `<OnLoad>`/`<OnClick>`; also `KRFUI.l`, `KRFUI.scrollBarX` |
| `K_Global_Vars` | `Core/KallyeRaidFramesAPI.lua` | cross-addon helpers (`GetUnitNameSafe`, …) |
| `KRF_TITLE` | globals | duplicate of `ns.TITLE` used for conflict detection |
| `KRF` | globals, `--@do-not-package@` | dev shortcut (`KRF = ns`) for `/dump KRF…`; stripped from releases |

## 5. Startup sequence

1. **File load**: all files execute top-level code. Files that must not run on conflict start with
   `if ns.CONFLICT then return; end`. `Core/KallyeRaidFrames.lua` immediately creates an anonymous
   event frame and registers `ADDON_LOADED` (`InitAddon`).
2. **`ADDON_LOADED` for `KallyeRaidFrames`** (`OnEvent` in `Core/KallyeRaidFrames.lua`), in order:
   1. `l.UpdateLocales()` — the locale file finalizes strings that depend on runtime capabilities;
   2. `ns.SetDefaultOptions(defaultOptions)` — creates `KallyeRaidFramesOptions`, or merges missing
      keys into it after `ns.RemoveOldOptions`;
   3. `ns.RefreshOptions(defaultOptions)` — pushes saved values into every bound control;
   4. `ns.BindOptionControls(defaultOptions, RequiredReloadOptionsString)` — hooks `OnClick` on each
      discovered control and captures the reload baseline;
   5. secure hooks installed once: `CompactUnitFrame_UpdateName`, `_UpdateRoleIcon`,
      `_UpdateHealthColor` and (retail) `_UpdateHealPrediction` / (classic) `_UpdateHealth`;
      `EnsureInRangeHooks()` conditionally hooks `_UpdateInRange` + `_UpdateHealthColor`;
   6. `foreach(ns.MODULES, module:Init(options))` — every module gets `onInit` once, in load order;
   7. version check → "what's new" chat message when `options.Version ~= defaultOptions.Version`;
   8. debug mode paints the options panels with a red gradient.
3. **Standalone Raid Frame Auras**: if `C_AddOns.GetAddOnInfo("RaidFrameAuras")` is `nil`, the frame
   unregisters `ADDON_LOADED`; otherwise a later `ADDON_LOADED == "RaidFrameAuras"` sets
   `ns.CONFLICT_RFA`, nulls `ns.LoadRaidFramesAuras`, disables `ActiveUnitDebuffs` and warns.
4. **`PLAYER_ENTERING_WORLD`** (optional, per module): modules that passed a third `onEnterWorld`
   argument to `ns.Module:new` get a one-shot event frame from `registerEnterWorld`
   (see `Shared/Module.lua`).
5. **The options window** is created by the XML at load time (`OptionsContainer_OnLoad`), i.e. before
   `ADDON_LOADED`; it registers its settings category immediately.

## 6. Options subsystem

### 6.1 Widget layer (`Shared/WidgetsKRF.xml` + `Shared/Widgets.lua`)

| Template | Type | Value accessors | Notes |
| --- | --- | --- | --- |
| `KRFUI_CheckboxWidget` | `CheckButton` (UICheckButtonTemplate) | `GetChecked`/`SetChecked` | boolean options; `Text` FontString declared as `parentKey` |
| `KRFUI_ColorWidget` | `CheckButton` extending the checkbox | `GetColor`/`SetColor`, `type = "color"` | opens `ColorPickerFrame`; swatch tinted |
| `KRFUI_SliderWidget` | `Slider` (`MinimalSliderTemplate,UISliderTemplate`) | `GetValue`/`SetValue`, `type = CONTROLTYPE_SLIDER` | replaces Blizzard's buggy slider template on retail/classic/anniversary |
| `KRFUI_DropDownWidget` | `Frame` (UIDropDownMenuTemplate) | `GetValue`/`SetValue`, `type = "dropdown"` | options list built from the `values` attribute |
| `KRFUI_HeadingWidget` | `CheckButton` | — | section header; may double as a module on/off toggle |
| `KRFUI_TextWidget` | `CheckButton` | — | plain text row (warnings, credits) |
| `KRFUI_SpellListWidget` | `Button` + popup (`Widgets_SpellList.lua`) | `GetValue`/`SetValue`, `type = "spellList"` | set of spell IDs (`BuffsExcluded`) with search/add/remove |

Widget `OnLoad` reads attributes from the control (`label`, `tooltip`, `default`, `min`/`max`,
`values`). Label resolution is `K_SHARED_UI.I18N[anyAddon][key]` → `_G[key]` → raw key, which is why
a Blizzard global such as `NONE` can be used directly as a label.

### 6.2 Binding and change detection (`Shared/OptionsAPI.lua`)

```
XML control (parentKey == option name)
        |  ns.FindControl(name): ns.optionsFrame[name], then Options1..N[name]
        v
ns.BindOptionControls(defaults, reloadBaseline)
        |  sets control._optionName / control._ns and hooks OnClick
        |  -> K_SHARED_UI.NotifyControlChanged(ns, control)
        v
K_SHARED_UI.NotifyControlChanged   ->  ns._pendingChanges[optionName] = true
        |                              C_Timer.After(0, ns.FlushOptionsChanges)  (batched)
        v
ns.FlushOptionsChanges
        |  for each pending name: read the control value, compare with the stored value
        |  (valuesAreEqual, colour-table aware), write into _G[OPTIONS_NAME],
        |  collect `changed`, warn once if the reload-required baseline differs
        v
ns.NotifyOptionsChanged(changed)
        |- ns.OnCoreOptionsChanged(options, changed)   Core: thresholds, hooks, re-apply
        |- each module:OnOptionsChanged(options, changed)
        '- K_SHARED_UI.RefreshOptions()                every registered refresh callback
                                                       (ManageOptionsVisibility + per-panel ones)
```

Design points to preserve:

- **Batching.** Sliders fire continuously; changes collapse into one flush per frame so expensive
  work happens once.
- **Live reads.** Hooks and modules read `options.X` at use time instead of caching, which is what
  makes real-time application safe.
- **`_loadingControls` guard.** `ns.WriteControlValue` during `RefreshOptions` must not look like a
  user change; the flag suppresses notifications.
- **Reload baseline.** `RequiredReloadOptionsString()` concatenates the options that still require a
  reload; `BindOptionControls` stores the initial string and `checkReloadRequired` warns exactly once
  when it changes.
- **Refresh callbacks.** `K_SHARED_UI.AddRefreshOptions(fn)` registers `fn(options)` to run on every
  UI refresh; each panel uses that to grey out dependent controls (`ns.OptionsEnable`,
  `ns.OptionsSiblingsEnable`, `ns.IsModuleEnabled`).
- **Reset.** `ns.ResetOptions(names, defaults, forced)` resets a subset (panel "Reset" buttons);
  `KRFUI.ConfirmReset` / `StaticPopupDialogs["KallyeRaidFrames_CONFIRM_RESET"]` resets everything and
  calls `ReloadUI()`.

## 7. Module subsystem (`Shared/Module.lua`)

A module is a plain table created by `ns.Module:new(onInit, name, onEnterWorld)`; the constructor
pushes it into `ns.MODULES`, so **registration order == `Modules/modules.xml` order**.

| Member | Called by | Purpose |
| --- | --- | --- |
| `onInit(self, options)` | Core at `ADDON_LOADED` | install hooks, apply current settings once |
| `onOptionsChanged(self, options, changed)` | `ns.NotifyOptionsChanged` | apply a batched change; `changed` is a set of option names |
| `onEnterWorld(self, options)` | one-shot `PLAYER_ENTERING_WORLD` frame | work that requires the world to exist |
| `getInfo(self)` | standalone builds / diagnostics | report module state in chat |
| `isLoaded` | Core | set to `true` by `Init`; `OnOptionsChanged` warns if a change arrives earlier |

Callbacks can also be attached after construction: `module:SetOnOptionsChanged(fn)` and
`module:SetGetInfo(fn)` exist because `UnitDebuffs` needs helpers defined further down the file.
Calling `OnOptionsChanged` / `GetInfo` before `Init` only emits `l.INIT_FAILED` and returns, so a
module is never asked to apply settings before it is loaded.

`ns.Module.cacheOptions` is a **live reference** to `KallyeRaidFramesOptions`, refreshed on every
`Init` / `OnOptionsChanged`; `self:GetCacheOptions()` exposes it outside callbacks.

Modules never call each other directly: every cross-module need goes through `ns.*`
(`ns.LoadRaidFramesAuras`, `ns.HasCustomAuraLayout`, `ns.ApplyFuncToRaidFrames`, …).

## 8. Raid-frame enhancement pipeline (`Core/KallyeRaidFramesAPI.lua`)

`hooksecurefunc` on Blizzard's compact-frame updaters; each hook reads live options:

| Hook target | Handler | Effect |
| --- | --- | --- |
| `CompactUnitFrame_UpdateName` | `ns.Hook_UpdateName` | realm removal, skull on death, friends class colour, level/PvP suffix |
| `CompactUnitFrame_UpdateRoleIcon` | `ns.Hook_UpdateRoleIcon` | move icon top-left, hide DPS icon |
| `CompactUnitFrame_UpdateHealthColor` | `ns.Hook_UpdateHealth` | three-colour background thresholds |
| `CompactUnitFrame_UpdateHealPrediction` (retail) / `CompactUnitFrame_UpdateHealth` (classic) | `ns.Hook_UpdateHealth` | inverted bar, bar texture, alpha |
| `CompactUnitFrame_UpdateInRange` + `CompactUnitFrame_UpdateHealthColor` | `ns.Hook_UpdateInRange` | out-of-range / out-of-combat alpha (installed lazily by `EnsureInRangeHooks`) |

`ns.ApplyFuncToRaidFrames(func, …)` is the bulk re-apply helper: it walks `CompactRaidFrame1..80`,
`CompactPartyFrameMember1..5`, `CompactPartyFramePet1..5` and `CompactRaidGroup1..8Member1..5`,
skipping hidden frames. Because Blizzard recreates frames, "apply now" actions must go through it
instead of caching frame references.

`RaidFrames_ResetHealth`, `DebugFrames` and `LoopDebug` implement `/krf test`, `/krf debug` and the
test-mode data used to preview colours without a real raid.

## 9. Aura subsystem (buffs / debuffs)

Three mutually exclusive implementations, chosen at runtime in `Modules/UnitDebuffs.lua`:

```
isEnabled(options)
  |- IsAuraContainer_Supported()        -> retail 12+ path
  |     ApplyAuraContainer(options)       configures Blizzard's aura container
  |                                       (sort method/direction, spacing, filters,
  |                                        exclusions, tooltip suppression)
  |- ns.LoadRaidFramesAuras (classic)   -> vendored RaidFrameAuras path
  |     ns.LoadRaidFramesAuras(options)   first enable, then
  |     ns.SyncRaidFramesAuras(options)   every later change
  '- otherwise (pre-12 clients)         -> legacy hooks
        hooksecurefunc("CompactUnitFrame_SetMaxBuffs" / "SetMaxDebuffs"
                        or "DefaultCompactUnitFrameSetup",
                        ns.Hook_ManageBuffs / ns.Hook_ManageDebuffs)
        + "CompactUnitFrame_UpdateAuras" hook when max counts changed
        + PLAYER_REGEN_ENABLED frame deferring work out of combat
```

`Modules/UnitDebuffs.lua` is therefore an **adapter**: it translates KRF's flat option table into
whichever backend is available and is the only place that knows about all three.

### 9.1 RaidFrameAuras bridge (`Modules/RaidFrameAuras/Wrapper.lua`)

- `ns.LoadRaidFramesAuras(options)` initialises `RaidFrameAuras.db` from KRF options, applies the
  aura CVars (`raidFramesDisplayBuffs`, `raidFramesDisplayDebuffs`, …) and starts the RFA modules;
  `ns.SyncRaidFramesAuras(options)` re-applies on later changes.
- Only the rendering-relevant part of RFA is used: `AuraScanner`, `RaidFrames`, `PrivateAuras`,
  `ObjectiveCarriers`, `Tooltip`, `Masque`. RFA's own options UI is **not** included (its
  `UI/Options/*.lua` entries are commented out in `RaidFrameAuras.xml`); `ChatCommands.lua` is
  included but its UI entry points are bypassed.
- **Namespace collision worth knowing:** the RFA subtree shares the *same* `ns` table and writes
  `ns.RaidFrameAuras`, `ns.addonName`, `ns.ADDON_VERSION`, `ns.DB_VERSION`, `ns.frameNameCounter`.
  `ns.addonName` / `ns.ADDON_VERSION` therefore describe RFA, not KRF — never use them for KRF
  identity (use `ns.ADDON_NAME` / `ns.VERSION`).

### 9.2 Other RFA-powered behaviours

`Core.lua`'s `RaidFrameAuras:Initialize()` optionally calls `self:InitializeMasque()` (icon skinning
integration) and `self:InitializeObjectiveCarriers()` (flag-carrier tracking); `PrivateAuras.lua` adds
private-aura handling to the scanner; `Database.lua` and `Config/Defaults.lua` define RFA's own DB
schema and defaults, which `Wrapper.lua` overwrites from KRF options on every sync. All of this only
runs on clients where the RFA XML is allowed to load (classic-era).

## 10. Options window composition (`Core/KallyeRaidFrames.xml`)

```
KRFUI_OptionsContainer            <- OnLoad = KRFUI.OptionsContainer_OnLoad
 |- Title / FooterNote (FontStrings, localized by iterating children)
 |- UIPanelInfoButton (tooltip = subtitle + description)
 '- KRFUI_OptionsScrollFrame      (ScrollFrameTemplate, gradient background)
     '- KRFUI_OptionsFrame         (fixed 550 x 830)
         |- core controls, each anchored to the previous one via relativeKey="$parent.X"
         |- Frame parentKey="Options1" inherits="KRFOptionsUnitDebuffs"
         |- Frame parentKey="Options2" inherits="KRFOptionsNameplatesColor"
         |- Frame parentKey="Options3" inherits="KRFOptionsRaidIcons"
         '- WhatsNew button ("/krf new")
```

- `KRFUI.OptionsContainer_OnLoad` stores `ns.containerFrame` / `ns.scrollFrame` / `ns.optionsFrame`,
  sets `okay = ns.FlushOptionsChanges` (values are saved live) and `refresh = ns.RefreshOptions`,
  then registers the canvas through `ns.InterfaceOptions_AddCategory`, which wraps
  `Settings.RegisterCanvasLayoutCategory` + `Settings.RegisterAddOnCategory` on modern clients
  (`ns.CATEGORY_ID` is captured there; classic falls back to `InterfaceOptions_AddCategory`).
- **Vertical stacking is manual.** Every control names its predecessor in `relativeKey`. Inserting a
  control in the middle of the core panel means re-anchoring the following control — a common source
  of overlapping widgets.
- The three plugin panels are *virtual* frames (`KRFOptionsUnitDebuffs`, …); each defines its own
  `Options1..n` sub-frames and is inserted as a `parentKey="OptionsN"` child. `ns.FindControl` looks
  in `ns.optionsFrame` first, then `Options1..OptionsN`, so widget names must be unique per render.
- `ManageOptionsVisibility` (registered via `K_SHARED_UI.AddRefreshOptions`) is the single place that
  decides visibility/enabled state of dependent core controls, including client-specific branches
  (`EditModeManagerFrame.UseRaidStylePartyFrames` vs classic CVars).
- FontStrings are localized in bulk by iterating children and mapping `l[child:GetText()]`, i.e. the
  XML `text="KEY"` value doubles as the lookup key.

## 11. Localization

| Layer | Mechanism |
| --- | --- |
| String table | `ns.I18N = {}` created in `Core/KallyeRaidFrames.globals.lua`; every file does `local l = ns.I18N` |
| Default language | `Core/localization.en.lua` always loads and defines the English values |
| Other languages | one file per locale, gated in the TOC by `[AllowLoadTextLocale xxXX]` (frFR, deDE, esES+esMX, itIT, koKR, ptBR, ruRU, zhCN+zhTW) |
| Lookup | `l.KEY` at runtime; a key missing from a locale file keeps the English text because `en` loads first and later files only overwrite the keys they define |
| Runtime fix-ups | `l.UpdateLocales()` (called at `ADDON_LOADED`) adjusts strings that depend on client capabilities |
| Widget labels | XML attributes store **keys**; `Shared/Widgets.lua` resolves `K_SHARED_UI.I18N[addon][key]` → `_G[key]` → raw key and registers `K_SHARED_UI.I18N[ns.ADDON_NAME] = ns.I18N` |

**The RaidFrameAuras subtree does not participate in this system.** `Modules/RaidFrameAuras/*` is
loaded *before* `Core/KallyeRaidFrames.globals.lua` (see §3), so its top-level `local l = ns.I18N`
captures `nil`, and `Util.T` falls back to `ns.L or {}`, which is never assigned. Net effect: RFA-side
strings are English-only inside KRF. Nothing is broken — no RFA code reads `l` — and this whole
paragraph disappears with the subtree (TD-02). KRF-side strings for the same features are localized
normally.

Rules when adding text:

1. Add the key to `Core/localization.en.lua` **and** use the same key in code/XML.
2. Add the same key to every locale file present in the repo, or accept the English fallback.
3. Never build user-visible strings by concatenation of translated fragments with different word
   order; prefer `string.format` with a complete translated pattern (some locales already use
   `%s`/`%d` patterns).
4. Keep `local l = ns.I18N` at the top of every new Core/Shared/Modules file loaded *after*
   `globals.lua`.

## 12. `K_SHARED_UI` and cross-addon synchronisation

`K_SHARED_UI` is the **only** global this addon creates on purpose. It is a plain table shared by the
whole K* family; KRF *appends* to it and never owns it:

| Member | Defined in | Purpose |
| --- | --- | --- |
| `K_SHARED_UI.I18N[addon]` | `Shared/Widgets.lua` | per-addon string tables, so a widget from any sibling resolves its own labels |
| `*.Checkbox/Color/Slider/DropDown/Text/Heading/SpellListWidget_On*` | `Shared/Widgets.lua`, `Shared/Widgets_SpellList.lua` | XML script handlers shared by every sibling |
| `K_SHARED_UI.NotifyControlChanged(_NS, control)` | `Shared/OptionsAPI.lua` | receives the namespace explicitly, so one implementation serves all siblings |
| `K_SHARED_UI.AddRefreshOptions(func)` / `.RefreshOptions()` | `Shared/OptionsAPI.lua` | registry of refresh callbacks (KRF adds `ManageOptionsVisibility` + panel-specific ones) |

Because the handlers take `_NS` as a parameter instead of closing over `ns`, the same file can be
copied verbatim into a sibling addon.

**Direction: one-way, KRF → siblings.** KRF is the reference implementation; the four siblings are
generated downstream copies. Shared code is edited *here* and propagated outwards, never the reverse,
and no sibling is ever patched directly — a change made in a sibling is silently lost at the next
propagation.

**Sync tooling** (repo root, not shipped):

- `.copy_shared.sh` (bash) / `.copy_shared.bat` (Windows) copy `Shared/WidgetsKRF.xml` and the
  relevant `Shared/Options*KRF.xml` into `../KBigDebuffs`, `../KNameplateColor`, `../KRaidFade`,
  `../KRaidIcons` and rewrite the prefix with `sed 's/KRF/KBD/g'` (etc.), plus one
  `sed 's/KallyeRaidFrames/KNameplateColor/g'` for the nameplate panel.
- The same scripts slice the `-- KBD START/END`, `-- KNC START/END`, `-- KF START/END`,
  `-- KRI START/END` blocks out of every `Core/localization.<lang>.lua` and paste them into the
  sibling's localization file.

Consequences for edits:

- Changing a widget or an `OptionsAPI` function changes **all five addons**; it must stay
  namespace-agnostic (`_NS`, `control._ns`, no KRF-specific globals).
- Never rename a KRF block marker or a `KRF` prefix without updating both scripts and all siblings.
- The `sed` rewrite is **substring based**: `KRF` inside asset paths (`Interface\AddOns\KallyeRaidFrames\…`)
  and identifiers like `KRFUI` are rewritten blindly; review the generated sibling XML for broken
  texture paths before committing.
- `OptionsRaidFadeKRF.xml` is currently *commented out* in the `.sh` script (KRaidFade does not consume
  that panel) while line 19 still runs `sed` on it — the script is not idempotent and can fail on a
  missing file.

## 13. Packaging and artefacts in the tree

- `.pkgmeta` drives the CurseForge/WoWA packager: `package-as: KallyeRaidFrames`, one external
  (`Libs/LibEditModeOverride-1.0` from `plusmouse/LibEditModeOverride`, vendored in the repo),
  `manual-changelog: ChangeLog.txt`, `license-output: License.txt`, and an `ignore` list for lib
  metadata plus `.git*`, `.vscode`, `.release*`, `.icon*`, `.logo*`.
- Files wrapped in `--@do-not-package@` … `--@end-do-not-package@` are stripped from release builds
  (used in `Core/KallyeRaidFrames.lua` for the developer's personal default values). Never move code
  into or out of that block casually — it changes what end users get.
- A packaged copy of the addon lives in `.release/KallyeRaidFrames/` inside the working tree. It is a
  build output, **not** a source of truth: it contains its own `Core/KallyeRaidFrames.lua` that shows
  up in global searches and can be edited by mistake.
- Version string: single source is `## Version:` in `KallyeRaidFrames.toc`; `ns.VERSION` is read from
  the TOC metadata in `globals.lua`. It is compared with the saved `options.Version` to trigger the
  "what's new" message, so bumping the TOC is enough for behaviour — but `ChangeLog.txt`,
  `## Version` and the git tag must be kept in step manually.
- `.copy_shared.bat` is only a launcher: it calls `wsl dos2unix` then `wsl bash ./.copy_shared.sh`,
  so all sync logic lives in the bash script and Windows users need WSL.

## 14. Invariants to respect

1. `ns` fields are the public API between Core, Shared and Modules; every module reaches for `ns.*`,
   never for another module's locals.
2. Anything that runs at file scope in `Modules/RaidFrameAuras/**` cannot rely on `ns.I18N`,
   `ns.VERSION`, `ns.OPTIONS_NAME` or `ns.Module` — they do not exist yet.
3. Option values are read live; do not cache booleans from the options table across events.
4. Visual changes on Blizzard frames go through `hooksecurefunc` on the `CompactUnitFrame_*` family,
   never through `Frame:SetScript` overrides (other addons may also hook them).
5. Secure/restricted work (aura counts, frame creation) is deferred to `PLAYER_REGEN_ENABLED` when it
   could run in combat; see the legacy aura path in `UnitDebuffs.lua`.
6. A control's `parentKey` == the option name == `defaultOptions` key == the key in the panel XML;
   breaking that trio silently disables persistence.
7. `ns.CONFLICT` must remain the very first check in files that can conflict with the standalone
   RaidFrameAuras addon.






