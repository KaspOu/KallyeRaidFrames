# Technical debt — KallyeRaidFrames

> Everything below was observed in the working tree at commit `babbee6` (`main`, TOC `12.1.504`).
> Nothing here is a bug report: each item is a *structural* risk that makes future changes slower or
> more dangerous. See [ARCHITECTURE.md](ARCHITECTURE.md) for how the pieces fit together and
> [PROJECT_CONTEXT.md](PROJECT_CONTEXT.md) for the feature inventory.

Severity is about **cost of being wrong**, not about how ugly the code is:

| Level | Meaning |
| --- | --- |
| **P0** | Can break the addon in production or lose user configuration; fix before the next release that touches the area |
| **P1** | Will cause regressions or silent misbehaviour when someone edits nearby code; plan a fix |
| **P2** | Maintainability / onboarding cost; fix opportunistically |

## Summary

| ID | Area | Sev | One-liner |
| --- | --- | --- | --- |
| TD-01 | `Modules/UnitDebuffs.lua` | P1 | 901-line module hosting three aura backends and ~30 private helpers |
| TD-02 | `Modules/RaidFrameAuras/**` | P2 | Vendored third-party engine, frozen and unmaintained — to be deleted, never patched |
| TD-04 | `.copy_shared.sh/.bat` | P0 | One-way `sed` propagation to 4 siblings: fragile substring rewrites, hardcoded paths |
| TD-05 | Versioning | P1 | TOC, `ChangeLog.txt` and git tags are out of step and updated by hand |
| TD-06 | Working tree | P0 | Uncommitted personal hack in `Core/localization.fr.lua` |
| TD-07 | Build artefacts | P2 | `.release/`, `.sfdx/`, `../packager` scripts live in or next to the repo |
| TD-08 | Quality gates | P1 | No tests, no CI, no linter; only a hand-run syntax gate (`tools/validate_lua.py`) |
| TD-09 | Options layout | P1 | Widgets are positioned by manual `relativeKey` chains in a fixed-height frame |
| TD-10 | Options boilerplate | P2 | Panels/API duplicated in 5 addons; templates propagated by script, `Shared/*.lua` by hand |
| TD-11 | Client branching | P1 | Flavour conditions are inlined in UI and aura logic |
| TD-12 | Silent failure | P1 | `pcall`, `or {}` and nil-checks swallow real errors |
| TD-13 | Naming | P2 | `KRFUI_*` vs `KRFOptions*`, `KRF_TITLE`, `K_Global_Vars` |
| TD-14 | CVars | P1 | Writes Blizzard aura CVars and never restores them |
| TD-15 | Lifetime hooks | P2 | Permanent `hooksecurefunc` installed for a known workaround |
| TD-16 | Dev flags | P2 | `DebugMode` / `--@do-not-package@` blocks can leak into releases |

## TD-01 — `UnitDebuffs.lua` is a three-in-one monolith · P1

**Evidence.** `Modules/UnitDebuffs.lua` is 901 lines and contains, in one file scope:

- ~30 private helpers (`resolveFlowLayoutEnums`, `toFlowLayoutAxis`, `getOrCreateAuraContainerState`,
  `clearContainerGroups`, `addGroupIfNeeded`, `applyGroupLayout`, `setContainerAnchor`,
  `ResizeAuraButtons`, `AuraContainerRefreshFrame/AllFrames/EnsureHooks/Disable`,
  `ApplyAuraContainer`, `anchorPoints`, `ManageUnitFrames`, `determineAppropriateHook`, …);
- the retail `AuraContainer` backend (`IsAuraContainer_Supported` at line 124, `ApplyAuraContainer` at
  579);
- the classic RFA bridge dispatch (lines 949-966);
- the legacy pre-12 hook backend (lines 968-997, `hooksecurefunc` on
  `CompactUnitFrame_SetMaxBuffs`/`SetMaxDebuffs`/`DefaultCompactUnitFrameSetup`);
- its own combat-deferral machinery (`PLAYER_REGEN_ENABLED` frame, `ns.OnCombatEnd`).

**Why it matters.** Every aura change requires reading all three backends to know which one is live.
The backends also disagree in shape: the retail path builds frames imperatively, the RFA path pushes a
flat table into another addon's DB, the legacy path depends on Blizzard hook ordering.

**Suggested fix (incremental).** Split by backend *without changing behaviour*:
`UnitDebuffs/AuraContainer.lua`, `UnitDebuffs/Legacy.lua`, `UnitDebuffs/RaidFrameAuras.lua`, plus a
small `UnitDebuffs.lua` dispatcher keeping `ns.Module:new`, `isEnabled`, `onOptionsChanged`,
`getInfo`. Move shared math (`scaleToSize`, `ResolveSpacing`) to a helper file. Do it in three PRs,
one backend each, verifying in-game between them. The RFA file is kept separate precisely so that the
deletion of the vendored engine (TD-02) becomes a single `rm` plus one dispatcher branch.

## TD-02 — Frozen vendored RaidFrameAuras: do not maintain, plan the deletion · P2

**What it is.** `Modules/RaidFrameAuras/` is an entire third-party addon by Anahkas (Apache-2.0, its own
`LICENSE`, credited in `License.txt`), loaded only on classic-era clients (`KallyeRaidFrames.toc:31`,
`[AllowLoadGameType classic]`). It is **not** a KRF module and it is **not maintained here**.

**Status: frozen until deletion.** The engine only exists because Blizzard had no aura-layout API
before `AuraContainer`. Retail 12+ already goes through `Modules/UnitDebuffs.lua` →
`ApplyAuraContainer`, and as soon as every supported client exposes `AuraContainer` the whole subtree
is deleted. Until then:

- do not patch it, do not add options, do not localise it, do not "fix the FIXMEs" — the header of
  `Wrapper.lua` and the `FIXME: TO REMOVE when bugfixed` at line 173 are upstream's leftovers, not a
  backlog;
- do not try to reconcile it with upstream either: `git log -- Modules/RaidFrameAuras` mixes 12
  upstream refreshes with local patches and no patch log exists, so no diff against upstream is
  meaningful any more. Every extra local hunk only makes the deletion heavier;
- the only welcome edits are the ones that *shrink* it.

**Deletion checklist** (when `AuraContainer` is available on every supported client):

1. `KallyeRaidFrames.toc:31` (`Modules\RaidFrameAuras\RaidFrameAuras.xml`) and the directory.
2. The RFA branch in `Modules/UnitDebuffs.lua:954-966` (`ns.LoadRaidFramesAuras` /
   `ns.SyncRaidFramesAuras`) plus the `ns._UnitDebuffsHooked` guard that only serves it.
3. The bridge in `Wrapper.lua`: `ns.LoadRaidFramesAuras`, `ns.SyncRaidFramesAuras`, `resolveOptions`,
   `SafeSetCVar`, the Blizzard CVar policy (TD-14) and the `CompactUnitFrame_SetUpFrame` hook (TD-15)
   all live there and disappear with it.
4. The RFA-only options panel (`Modules/RaidFrameAuras/OptionsUnitDebuffs.xml`), its `parentKey`s in
   `defaultOptions`, and any control in `Shared/OptionsUnitDebuffs*.{xml,lua}` whose only consumer was
   RFA.
5. `ns.addonName` (the case-only mirror set by RFA's `Core.lua`, see TD-13) and the locale branches
   guarded by `ns.LoadRaidFramesAuras` (`l.UpdateLocales`, the debuff tooltip in
   `Core/localization.*.lua`).
6. Credits and docs: `License.txt`, the Apache-2.0 notice, `.pkgmeta`, `ChangeLog.txt`, and the
   `Modules/RaidFrameAuras/**` rows in `docs/ARCHITECTURE.md` / `docs/PROJECT_CONTEXT.md`.

**Why it matters.** Half-maintained vendored code is the worst of both worlds: expensive to read,
impossible to fix safely, and it survives every cleanup because it "still works on classic". The only
real work item is the removal itself, and it is cheap *only* while the subtree closely matches what
was imported.

Side note while it is still there: the RFA files load *before* `Core/KallyeRaidFrames.globals.lua`, so
their top-level `local l = ns.I18N` is `nil` and `Util.T` falls back to `ns.L or {}` (English). No file
dereferences `l.X` today, so nothing breaks — just never add `l.x` in that subtree.

## TD-04 — `sed`-based cross-addon propagation · P0

**Dependency direction is not the debt.** KRF is the single source of truth: the shared parts are
edited **here**, then propagated outwards to the four siblings. A sibling repository is never edited
and never syncs back, so there is no two-way drift to reason about — the debt is that the tool doing
the propagation is a blind, state-changing `sed` script.

**Evidence.** `.copy_shared.sh` copies `Shared/*KRF.xml` into four sibling addons, then rewrites
identifiers with global substring substitutions:

```bash
sed -i 's/KRF/KBD/g' ../KBigDebuffs/Shared/WidgetsKBD.xml
sed -i 's/KRF/KF/g'  ../KRaidFade/Shared/WidgetsKF.xml
sed -i 's/KallyeRaidFrames/KNameplateColor/g' ../KNameplateColor/Shared/OptionsNameplatesColorKNC.xml
```

Problems, all visible in the script itself:

1. **Substring rewrites that happen to be safe today.** The substitution correctly renames `KRFUI*`
   identifiers *and* any `KRF` substring, but the conversion of asset paths relies on a hand-added
   second `sed` that only exists for KNC: `Shared/OptionsNameplatesColorKRF.xml` has 18 occurrences of
   `Interface\AddOns\KallyeRaidFrames\Files\…`, and the generated
   `../KNameplateColor/Shared/OptionsNameplatesColorKNC.xml` is currently correct
   (`Interface\AddOns\KNameplateColor\Files\…`). Any template that gains an asset path later — or any
   locale string containing `KallyeRaidFrames` — will be silently wrong in the sibling, with no error.
2. **A sync step that is not a sync.** Line 17 comments out copying `OptionsRaidFadeKRF.xml`, but
   line 19 still runs `sed -i` on `../KRaidFade/Shared/OptionsRaidFadeKF.xml`. The target exists today,
   so the command "succeeds" while that panel is never refreshed from KRF — the script silently
   pretends to keep it in sync. There is no `set -e` either, so every failed `cp`/`sed` goes unnoticed.
3. **Hardcoded `../Sibling` paths and `/tmp/`.** Assumes a fixed multi-repo layout and a POSIX shell;
   `.copy_shared.bat` only launches the script through WSL, so Windows users without WSL cannot sync.
4. **Not idempotent, no dry-run.** Re-running it is supposed to be safe — siblings are downstream
   copies and must never carry local edits — but the script cannot tell a stale copy from a
   hand-fixed one, and it silently overwrites whatever it finds.
5. **Localisation blocks** are sliced with `sed -n "/-- KBD START/,/-- KBD END/…"`. A missing or
   misspelled marker yields an *empty* block, and because the delete pass runs before the insert
   pass, the sibling's translations are lost.

**Suggested fix.** Replace with a small Lua 5.1 generator: read the template, apply an explicit
prefix map (`KRF→KBD`, `KRFUI→KBDUI`, `KallyeRaidFrames→KBigDebuffs`), assert the target directory
exists, write through a temporary file, and refuse to touch an unbalanced marker block. Add a
`--check` mode that reports what would change and exits non-zero on drift, so a propagation can be
verified without writing. Short-term mitigations: `set -euo pipefail`, verify every `cp` target, and
never run it against a dirty sibling.

## TD-05 — Version / changelog / tag drift · P1

**Evidence (current tree).** `KallyeRaidFrames.toc:15` says `## Version: 12.1.504`; `ChangeLog.txt`
starts at `v12.1.502`; the newest git tag is `12.1.502`; `HEAD` (`babbee6`, ":fire: Buffs: Remove
legacy display") carries no tag; there is also a stray `wip` tag. The runtime version is read from the
TOC (`ns.VERSION`) and compared to `options.Version` to print the "what's new" message, so the
*behaviour* follows the TOC while the *documentation* users read follows `ChangeLog.txt`.

**Why it matters.** Three independent numbers describe "the version", nobody validates them, and the
packager publishes `manual-changelog: ChangeLog.txt`. Users can therefore receive `12.1.504` with a
changelog that stops at `12.1.502`, and the "what's new" popup can announce a release the changelog
never mentions.

**Suggested fix.** Add a release checklist (or a tiny CI job) that asserts
`toc version == top ChangeLog heading == tag name` before packaging, and normalise the tag format
(`12.1.502`, no prefixes). Keep `wip` out of the same namespace (branch instead of tag).

## TD-06 — Uncommitted personal hack in `Core/localization.fr.lua` · P0

**Evidence.** The only local modification in the working tree is:

```lua
-- Core/localization.fr.lua, line 8
if _G[ns.OPTIONS_NAME].ForceEnglish then return end
```

`ForceEnglish` exists nowhere else in the repository: it is not in `defaultOptions`, not in any panel
XML, and not documented. It sits *above* the French string table, so when a user happens to have that
key set, the whole file bails out and French silently degrades to English. Worse, the guard indexes
`_G[ns.OPTIONS_NAME]` unguarded, and that table only exists once saved variables have been written or
`Shared/OptionsAPI.lua:19-20` has run (included from `Core/KallyeRaidFrames.xml:3`, i.e. TOC line 48 —
*after* `localization.fr.lua`, TOC line 34). On a first install with an `frFR` client the line indexes
`nil`.

**Why it matters.** It is a debugging leftover in a tracked, shipped locale file (`.copy_shared.sh`
only copies the `-- XXX START/END` blocks, so it would not leak to siblings — but it *is* packaged).
Committing it ships a hidden switch to users and can break French on a fresh install; losing it silently
reverts the author's local workflow; and it makes every `git status` ambiguous.

**Suggested fix.** Move the experiment out of tracked source (e.g. a `--@do-not-package@` block or a
`.lua` file in `.gitignore`), or promote it to a documented developer option with a default in
`defaultOptions` and a guard (`local opts = _G[ns.OPTIONS_NAME]; if opts and opts.ForceEnglish then
return end`). Then either commit it deliberately or `git checkout` the file.

## TD-07 — Build artefacts and external tooling in the tree · P2

**Evidence.** Three separate things live outside version control or inside the working directory:

- `.release/KallyeRaidFrames/` is a full packaged copy of the addon (with its own
  `Core/KallyeRaidFrames.lua`, `Modules/`, …) sitting in the repo. It is excluded by `.gitignore:43`
  (`.release*`) and by `.pkgmeta`'s `ignore` list, but editor-wide search and "find in files" still
  walk into it.
- The release launchers `.release.bat`, `.release.live.bat` and `.release.xcopylibs.bat` are matched by
  **the same `.gitignore` glob**, so they are untracked and absent from the repository. They call
  `wsl bash ../packager/release.sh`, i.e. a sibling repository (`../packager` exists on the author's
  machine only). A fresh clone therefore cannot produce a release at all.
- `.sfdx/` is an empty leftover directory tree (`tools/sobjects`, `tools/soqlMetadata`, `typings/lwc`)
  from a Salesforce DX tool. Git never sees it because it contains no files, so `git status` stays clean
  and the directory survives every clone-less copy of the folder.

For contrast, `.vscode/settings.json` *is* tracked (Git ignores nothing there; `.pkgmeta` merely strips
`.vscode` from the package), which shows the ignore rules are not applied consistently.

**Why it matters.** `git ls-files` cannot answer "how do I build a release?", and the only record of the
process is three ignored batch files on one machine. Grep-based refactors hit the stale `.release/` copy,
and an assistant or a new contributor has no way to tell it apart from the source.

**Suggested fix.** Commit the release script (or a documented equivalent) and describe it in `AGENTS.md`;
narrow the `.gitignore` glob so the launchers can be tracked (e.g. rename them to `release.bat`,
`release.live.bat`, …). Move build output outside the repository or keep it — but say so. Delete `.sfdx/`.

## TD-08 — No automated safety net · P1

**Evidence.** There is no `.github/` (no CI), no `.luacheckrc`, no `stylua.toml`, no test harness, and
no in-game test plan in the repo. The only automatic check is `tools/validate_lua.py` (added later):
a Python Lua 5.1 lexer + block-structure checker + `--@do-not-package@` / `KBD`/`KNC`/`KF`/`KRI`
marker check, run by hand (`python tools/validate_lua.py`). It catches lexical/structural mistakes and
marker or encoding slips, nothing semantic.
The only in-game "test" affordances are `/krf test` (which calls `ns.DebugFrames` → `ns.LoopDebug`)
and `/krf debug` (which flips the persisted `DebugMode` flag that paints the panels red).

**Why it matters.** The addon hooks Blizzard internals across many clients — the TOC declares eight
interface numbers (`120100, 120105, 120107, 16001, 50504, 38002, 20506, 11509`). A syntax error, a
renamed Blizzard function or a nil option key is only caught by manually logging into the right client
— and the sibling-sync workflow can propagate a broken template to four other addons.

**Suggested fix (cheap first).** (1) Wire the existing syntax gate into something automatic — a git
`pre-commit` hook, or a CI job that just runs `python tools/validate_lua.py` (exit code 1 fails the
build) — so it cannot be skipped. (2) `luacheck` on the repo root with a small `.luacheckrc`
(`std = "lua51"`, `globals` for the WoW API used), run locally before commit. (3) A `tests/` Lua
harness that loads the namespace with a mocked `ns`/WoW API to assert: TOC files exist, every
`defaultOptions` key has a matching XML `parentKey`, every XML `parentKey` has a default, and every
`l.KEY` used in code exists in `localization.en.lua` (this last one catches most empty-string bugs).
(4) A five-line smoke checklist per client in `AGENTS.md`.

## TD-09 — Options layout is positioned by hand · P1

**Evidence.** `KRFUI_OptionsFrame` has a hard-coded `<Size x="550" y="830" />` and every control names
its predecessor: `<Anchor point="TOPLEFT" relativeKey="$parent.RevertBar" relativePoint="BOTTOMLEFT"/>`.
The three plugin panels are chained the same way (`Options2` → `Options1`, `Options3` → `Options2`) and
the `WhatsNew` button is anchored to `Options3` with `y="-40"`.

**Why it matters.** There is no layout engine: inserting a control means re-anchoring its successor,
and forgetting it produces overlapping widgets with no error. Changing the height of any panel silently
clips the tail of the scroll child, and the visual order is duplicated knowledge (XML anchors + panel
order).

**Suggested fix.** Introduce a tiny stacking helper (e.g. `KRFUI.Stack(parent, widget, previous,
offsetY)` registered from `<OnLoad>`), or generate the anchor chain from an ordered list. At minimum,
document "re-anchor the next control" in `AGENTS.md` and grow `KRFUI_OptionsFrame` when a panel grows.

## TD-10 — Copy-paste options boilerplate across five addons · P2

**Evidence.** `Shared/Widgets.lua`, `Shared/OptionsAPI.lua` and `Shared/Module.lua` are near-identical
per addon, yet `.copy_shared.sh` only copies the **XML** templates — the Lua half of the framework is
synchronised by hand. Checked at this commit: those three files are identical line-for-line between KRF,
KBigDebuffs, KNameplateColor, KRaidFade and KRaidIcons, so the manual discipline is currently holding.
The set is not even uniform: `Shared/Widgets_SpellList.lua` exists only in KRF and KBigDebuffs. Inside
KRF itself, `l.UpdateLocales` is redefined in all nine `Core/localization.*.lua` files with overlapping
client-conditional bodies.

**Why it matters.** The copy direction is strictly one-way (KRF → siblings, TD-04), so the five copies
cannot diverge by accident — but nothing makes them converge either: a `Shared/*.lua` change reaches
the siblings only when the author remembers to copy it by hand, and the five copies are invisible to
`git` because they live in five repositories. The dangerous state is a sibling running a *stale*
`OptionsAPI.lua` with a *fresh* generated template, and that state is indistinguishable from a correct
one until a control stops working.

**Suggested fix.** Extend the sync script to copy `Shared/*.lua` with the same prefix map (they are
already namespace-agnostic by design), and add the same `--check` mode that compares hashes and exits
non-zero on drift. For `l.UpdateLocales`, move the client-conditional part into one shared helper and
keep only the strings per locale.

## TD-11 — Client/flavour branching is inlined everywhere · P1

**Evidence.** Feature detection is spread across call sites instead of one capability table:
`ns.IS_FOREVER` / `ns.IS_RETAIL` (`Core/KallyeRaidFrames.globals.lua:20-25`, `scrollBarX` at line 104),
`ns.HAS_AURACONTAINER` and `ns.LoadRaidFramesAuras ~= nil`
(`Shared/OptionsUnitDebuffs.lua:40-41`), `ns.HAS_SECRETS` (`Modules/UnitDebuffs.lua:917`), and inline
`EditModeManagerFrame.UseRaidStylePartyFrames` checks in `ManageOptionsVisibility`
(`Core/KallyeRaidFrames.lua:388-408`).

**Why it matters.** "Which clients take this branch?" cannot be answered by reading one file, and each
client change (e.g. the Midnight secrets / `AuraContainer` work) requires hunting down every inline
test. Mixing test *kinds* (project ID, API existence, CVar presence) also makes it easy to write a
condition that is true on a client nobody tested.

**Suggested fix.** Consolidate into one `ns.FEATURES` table computed once in `globals.lua`
(`HAS_AURACONTAINER`, `HAS_SECRETS`, `HAS_EDITMODE_RAIDFRAMES`, `HAS_RFA`, …) and replace inline checks
with reads of that table. Add a `/krf status` output of the table — it doubles as a bug-report aid.

## TD-12 — Failures are silent by construction · P1

**Evidence.** Error paths are swallowed or downgraded:

- `Util.T` wraps `string.format` in `pcall` and returns the unformatted text on error
  (`Modules/RaidFrameAuras/Shared.lua:60-70` — RFA subtree, disappears with TD-02);
- `SafeSetCVar` returns `false` and callers ignore the result (`Wrapper.lua:120-131`,
  `Modules/UnitDebuffs.lua:128-139`);
- `resolveOptions` silently falls back to `ns.Module.cacheOptions`, then to `_G[ns.OPTIONS_NAME]`
  (`Wrapper.lua:34-40` — RFA subtree, disappears with TD-02);
- `ns.AddMsg*` compute `if DEFAULT_CHAT_FRAME and _G[ns.OPTIONS_NAME].ShowMsgNormal or force` — the
  options table is indexed without a nil check (an error, not a message, if it is ever missing) and
  `or force` silently overrides the user's verbosity choice, so a suppressed warning is
  indistinguishable from "nothing to report";
- one-shot guards (`ns._UnitDebuffsHooked` set at `Modules/UnitDebuffs.lua:957`/`:969` *before*
  `ns.LoadRaidFramesAuras`, `ns._InRangeHooked` set at `Core/KallyeRaidFrames.lua:155` *before* the
  `hooksecurefunc` calls) record success before the work completes, so a failure leaves the addon
  permanently half-configured with no retry.

**Why it matters.** When a user reports "aura sizes stopped working on classic", there is no trace:
the option saved, the module reported success, and nothing was logged.

**Suggested fix.** Keep the defensive helpers but report their failures through
`ns.AddMsgDebug`/`ns.AddMsgErr` with the option name and client, and set one-shot flags *after* the
successful call. Add `/krf status` (feature flags, module load state, current aura backend).

## TD-13 — Naming and conventions drift · P2

**Evidence.** Four competing prefixes coexist: `KRFUI_*` (framework widgets, `Shared/Widgets*.xml`),
`KRFOptions*` (`Shared/OptionsUnitDebuffsKRF.xml`, `Modules/RaidFrameAuras/OptionsUnitDebuffs.xml`),
`KRF_*` globals (`KRF_TITLE`, `K_Global_Vars` in `Core/KallyeRaidFramesAPI.lua:3`) and plain `ns.*` API.
The `ns` table carries both `ns.ADDON_NAME` (KRF) and `ns.addonName` (set by the frozen RaidFrameAuras
tree, see TD-02) — two keys differing only by case, with different owners. Comment banners alternate
between `--[[ ! Title ]]`, `--#region`, `-- #region`, `--?` and bare `-----`; indentation is mixed
tabs/spaces inside the same function (`Modules/UnitDebuffs.lua:967-988`).

**Why it matters.** Case-only key differences are invisible in review, and a `ns.addonName` lookup
inside KRF code silently returns `"RaidFrameAuras"`. `K_Global_Vars` is a global namespace shared *by
convention* with sibling addons (`../KNameplateColor/NameplatesColor.lua:77` consumes
`K_Global_Vars.GetUnitNameSafe` if present), so renaming anything under it breaks another addon without
a compile error. Mixed comment markers defeat "jump to section" navigation, and mixed indentation makes
diffs noisy.

**Suggested fix.** Freeze one rule set in `AGENTS.md`: `KRFUI_*` for shared widgets, `KRFOptions*` for
panels, keep `K_*` only for the documented cross-addon globals; keep `ns.ADDON_NAME` as the *only*
identity key for KRF. Do **not** rename the `ns.addonName` mirror: it belongs to the frozen RFA subtree
and disappears with it (TD-02) — the rule is simply "never read `ns.addonName` from KRF code". Pick
`--#region` for sections and apply `stylua` once.

## TD-14 — The addon writes Blizzard CVars as a side effect · P1

**Evidence.** Both aura back-ends call `applyBlizzardAuraCVarPolicy(false)` *unconditionally* at the top
of every entry point (`Modules/RaidFrameAuras/Wrapper.lua:134`, `:161`;
`Modules/UnitDebuffs.lua:588`), which writes `"1"` to `raidFramesDisplayBuffs` and
`raidFramesDisplayDebuffs` **before** deciding anything. Only afterwards, and only if
`RaidFrameAuras.db.enabled and options.HideBlizzardAuras`, is `"0"` written. `SafeSetCVar` wraps
`SetCVar` in `pcall` and discards `SetCVar`'s own boolean return, so a rejected write is invisible.
The same two helpers are duplicated in `Wrapper.lua` and `UnitDebuffs.lua`. Two of the three call sites
are in the frozen RFA subtree and vanish with it (TD-02); `Modules/UnitDebuffs.lua:588` is the one that
survives the deletion and therefore the one to fix.

**Why it matters.** Logging in with the aura module disabled — or just reloading — re-enables Blizzard's
own raid-frame auras for a user who had turned them off, permanently (CVars persist in
`config-cache.wtf`). Nothing restores the pre-KRF values, and the UI never says the addon touched a
Blizzard setting. Users experience this as "KRF keeps turning Blizzard auras back on".

**Suggested fix.** Make the policy three-valued: `hide=true` → `"0"`, `hide=false` → restore the value
recorded on first run (stored in saved variables), `hide=nil` → do nothing. Read the CVar, remember it,
and never write `"1"` unless it is the restore path. De-duplicate the helper pair in one shared place.

## TD-15 — Permanent `hooksecurefunc` workarounds · P2

**Evidence.** The hooks below can never be removed and several exist for workarounds that are themselves
marked as temporary:

- `hooksecurefunc("CompactUnitFrame_SetUpFrame", disableBlizzAuras)` behind the comment
  `-- FIXME: TO REMOVE when bugfixed` (`Modules/RaidFrameAuras/Wrapper.lua:173-176`). Its guard
  `GetCVar("raidFramesDisplayBuffs") == nil` is false on every current client, so the branch is
  effectively dead code that no test will ever exercise. It sits in the frozen subtree: leave it
  alone, it disappears with TD-02.
- `hooksecurefunc("CompactUnitFrame_UpdateAuras", ns.CompactUnitFrame_UpdateAurasInternal)` on the
  legacy path (`Modules/UnitDebuffs.lua:976`), plus hooks on `CompactUnitFrame_SetMaxBuffs/_SetMaxDebuffs`
  whose *names are built from strings* (`determineAppropriateHook`, which can also return
  `"DefaultCompactUnitFrameSetup"`), so a Blizzard rename turns into a `hooksecurefunc` call on a
  non-existent name — an error at hook time rather than a graceful degradation.
- `disableBlizzAuras` mutates Blizzard's `frame.optionTable` in place and deliberately does **not** call
  `CompactUnitFrame_SetOptionTable` (commented out at `Wrapper.lua:151`), so the table claims
  `displayBuffs = false` while the frame keeps drawing them.
- The legacy installer creates a `CreateFrame("Frame")` for `PLAYER_REGEN_ENABLED` and drops the
  reference (`UnitDebuffs.lua:980-986`).

**Why it matters.** Hooks that cannot be undone plus guards that cannot be true plus string-built
function names make the aura backend impossible to reason about; the "temporary" code is now load-bearing.

**Suggested fix.** Leave the RFA hook alone (frozen subtree, TD-02). In `UnitDebuffs.lua`, replace
string-built hook names with an explicit table of `(functionName, handler)` pairs validated with
`type(_G[name]) == "function"` before hooking, and log when a name is missing. Keep the
`PLAYER_REGEN_ENABLED` frame in the module state table so it can be reused instead of leaked.

## TD-16 — Debug switches leak into user state · P2

**Evidence.** `DebugMode` lives in saved variables (`Core/KallyeRaidFrames.lua:98`), and on every login
with it enabled the addon (a) opens the settings window through `SLASH_KRF_command()` (`:219-220`) and
(b) paints a red gradient over each plugin panel (`:222-227`), which is not cleared when the mode is
toggled off — it only goes away on the next reload. It also decides whether
`ns.AddMsgDebug` prints at all (`Core/KallyeRaidFrames.globals.lua:95`). Developer defaults are shipped
inside `--@do-not-package@` comment blocks that only the packager strips
(`Core/KallyeRaidFrames.lua:101-114`, `Core/KallyeRaidFrames.globals.lua:10-12`,
`Modules/UnitDebuffs.lua:214`), and `Shared/OptionsAPI.lua:203` keeps a commented-out `print`.

**Why it matters.** A user who once enabled debug mode gets a settings window popping open at every login
and a permanently tinted options UI, with no way to revert other than unchecking an option they do not
recognise. The dev-defaults mechanism depends entirely on the external packager understanding
`@do-not-package`; any other copy path (`.release/`, a manual zip, the sibling sync) ships them.

**Suggested fix.** Keep the flag but make it session-scoped (`ns.DebugMode`), or clear the gradient in
the off-branch of `ns.DebugFrames`. Gate developer defaults behind an explicit `ns.IS_DEVELOPMENT`
constant instead of comment markers, and delete commented-out `print` calls.

---

## Not debt (deliberate, keep as is)

Documenting these prevents a future reader from "fixing" them:

- **Vendoring a third-party aura engine (RFA).** Classic clients needed an aura layout engine Blizzard
  did not provide, and shipping Anahkas' addon was cheaper than reimplementing it. It is now frozen and
  scheduled for deletion (TD-02) — the deliverable is the removal, not maintenance.
- **One-way propagation instead of a shared library.** KRF is the reference implementation and the four
  siblings are generated downstream copies: shared code is edited here and pushed outwards, never the
  reverse, and no sibling is ever patched directly. TD-04/TD-10 ask for a safer tool, not for a
  different model.
- **One `ns` table per addon, resolved from `...`.** No globals except the documented `K_*` ones; this
  is what makes the `sed` sync and the sibling ecosystem possible at all.
- **A hand-rolled options framework (no Ace3).** It is why the panels are copy-pasteable between
  addons and why `Shared/*.xml` can be generated. TD-09/TD-10 are the price; replacing it would be a
  rewrite, not a cleanup.
- **Nine hand-written locale files with `-- XXX START/END` markers.** Redundant inside this repo, but
  they are the interface used to export strings to siblings (TD-04 item 5).
- **`/krf test`, `/krf debug`, `DebugMode`.** Necessary in-game diagnostics for a client-specific
  addon; TD-16 only asks that they do not *persist* into user state.
- **`ns.LoadRaidFramesAuras` being optional.** The `if ns.LoadRaidFramesAuras then …` checks are what
  let the aura module survive clients without RFA, not defensive noise (they go away with TD-02).

## Suggested order of attack

Ordered by (risk removed ÷ effort), assuming a single maintainer:

1. **TD-06** — decide what to do with the uncommitted French guard. Takes minutes; it makes every
   later `git status` trustworthy. Do this first because everything else starts with a clean tree.
2. **TD-05** — write the release checklist (TOC = ChangeLog = tag). Minutes, and it stops shipping a
   changelog that disagrees with the build.
3. **TD-04** — turn `.copy_shared.sh` into a checked generator with `set -e`, a `--check` mode and an
   asset-path rule that is not per-file manual. This is P0 because it mechanically rewrites four other
   repositories, even though the direction is one-way.
4. **TD-14** — make the CVar policy non-destructive and record the original values (only the
   `UnitDebuffs.lua` call site matters once TD-02 is done). This is the item users notice today.
5. **TD-08** — wire `tools/validate_lua.py` into a pre-commit hook or CI, then add `luacheck` plus the
   TOC/`defaultOptions`/`parentKey`/`l.KEY` consistency script. These checks are mechanical and catch
   most of what TD-11 and TD-12 hide.
6. **TD-01 + TD-11** — split `UnitDebuffs.lua` along the three backends and introduce `ns.FEATURES`.
   Do them together: the split is what gives the feature table a natural home.
7. **TD-15 + TD-16** — validate hook names in the legacy path, stop `DebugMode` from persisting. Small,
   contained.
8. **TD-10** — make the sync tool also copy `Shared/*.lua` with a hash check. No code movement
   required.
9. **TD-02** — delete the frozen RFA subtree following the checklist above, **when** every supported
   client exposes `AuraContainer`. Everything else on this list is written so that this deletion stays
   a mechanical operation.
10. **TD-09 + TD-13** — layout helper and naming/style pass. Pure maintainability; do it last, in a
    single mechanical commit, or not at all.
11. **TD-07** — housekeeping (`.sfdx/`, `.release/`, packaging docs).

## Maintenance rules for this document

- Every item must cite a file and line. When the cited line moves, update it in the same commit that
  moves it — otherwise the document becomes the next reader's debt.
- An item is deleted (not archived) when the underlying cause is gone. The summary table is the index:
  renumbering is allowed only when an item disappears and no other document links to its ID.
- An ID is never reused, so the table can contain intentional gaps. `TD-03` was removed once
  localisation was verified working in game (the keys resolve, the locale files load, nothing
  dereferences the dead `l` handle in the vendored tree) — the gap is the record, do not renumber to
  fill it.
- New items need a severity from the table at the top, plus at least one of: a concrete failure
  scenario, or a one-command reproduction.
- This file describes *structure*. A reproducible wrong behaviour goes to the issue tracker; a
  feature question goes to [PROJECT_CONTEXT.md](PROJECT_CONTEXT.md); a "how does this work" question
  goes to [ARCHITECTURE.md](ARCHITECTURE.md).

