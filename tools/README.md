# tools/ — developer helpers

Nothing in this folder ships with the addon (`.pkgmeta` ignores `tools/` and `docs/`) and nothing here
is required to play. These are the offline checks the maintainer and the AI agents run instead of a
real test suite — see `AGENTS.md` §1 for the whole workflow (`rtk`, `python`, this gate).

| File | Purpose |
| --- | --- |
| `validate_lua.py` | Lua 5.1 syntax gate for every `*.lua` file of the repository |

---

## `validate_lua.py`

A dependency-free Python 3 script: a Lua 5.1 lexer plus a block-structure checker. It never executes
the code and never touches the WoW client, so it works on any machine.

```powershell
python tools/validate_lua.py                                # whole repository
python tools/validate_lua.py Modules/UnitDebuffs.lua Core   # only some paths
python tools/validate_lua.py -v                             # list clean files too
python tools/validate_lua.py --selftest                     # test the checker itself
python tools/validate_lua.py --no-extra                     # skip the Kallye marker checks
python tools/validate_lua.py --exclude Modules              # skip a directory
```

Output is compiler-style — `path:line:col: error: message` — followed by a summary line:

```
Modules/Foo.lua:42:5: error: 'end' without a matching block
1 file(s) checked, 1 error(s) in 1 file(s), 0.01s
FAILED: fix the errors above and re-run.
```

| Exit code | Meaning |
| --- | --- |
| `0` | every file lexes and is structurally balanced |
| `1` | at least one error (also used by `--selftest` when a case regresses) |
| `2` | bad invocation, or no `.lua` file under the given paths |

### What it checks

1. **Lexing (Lua 5.1)** — short and long strings (`[[…]]`, `[==[…]==]`), short and long comments,
   decimal/hex numbers, escape sequences, unterminated literals, raw newlines inside `"…"`, and
   characters Lua 5.1 rejects outside strings/comments (`!=`, `&&`, `||`, `$`, non-ASCII identifiers).
2. **Block structure** — `function`/`if`/`for`/`while`/`do` must be closed by `end`, `repeat` by
   `until`; `then` and `do` headers are tracked separately, so `if x then` followed by `end` is
   reported; `elseif`/`else` must sit in an `if`, only one `else` per `if`; `(`, `[`, `{` must be
   balanced and correctly nested.
3. **Kallye specifics** — UTF-8 **without BOM** (a BOM makes the WoW client refuse the file), balanced
   `--@do-not-package@` / `--@end-do-not-package@` blocks (the packager strips them) and balanced
   `-- KBD|KNC|KF|KRI START` / `END` blocks (`.copy_shared.sh` matches those anchors).

Vendored code (`Libs/`, `Modules/RaidFrameAuras/`) is checked on purpose: a syntax error there breaks
the addon just as well. `.git`, `.release`, `.sfdx`, `docs`, `node_modules` and `__pycache__` are
skipped.

### What it does **not** check

XML validity, `.toc` completeness, `parentKey` vs `defaultOptions` consistency, existence of the
`l.KEY` strings, load order, `ns.*` availability at call time, or any runtime behaviour. Those are
manual checks (`AGENTS.md` §1, §4 and `docs/TECHNICAL_DEBT.md` TD-08).

### Adding a check

Keep it in this file (no third-party import, standard library only), add one positive *and* one
negative case to `SELFTEST_CASES`, then run `python tools/validate_lua.py --selftest` and the full
repository scan before trusting it.
