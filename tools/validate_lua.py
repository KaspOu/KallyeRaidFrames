#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Lua 5.1 syntax gate for KallyeRaidFrames (and its sibling addons).

Validates Lua sources WITHOUT executing them and without the WoW client:

  1. a full Lua 5.1 lexer (short/long strings, short/long comments, numbers,
     names, operators) -- catches unterminated strings/comments, raw newlines
     inside short strings and characters Lua 5.1 does not know (`!=`, `&&`,
     `||`, `$`, non-ASCII identifiers, ...);
  2. a block-structure checker -- `function`/`if`/`for`/`while`/`do` closed by
     `end`, `repeat` closed by `until`, `then`/`do` present, `elseif`/`else`
     only inside an `if`, balanced `()`, `[]`, `{}`;
  3. Kallye-specific checks -- UTF-8 without BOM, `--@do-not-package@` /
     `--@end-do-not-package@` pairing (the packager strips those blocks) and
     `-- KBD/KNC/KF/KRI START|END` locale-block pairing (`.copy_shared.sh`
     matches those anchors).

It is a SYNTAX gate only: it cannot know whether `ns.Foo` exists at the time it
is called (load order), whether an option has an XML control, or whether the
in-game behaviour is right. See AGENTS.md for the rest of the checklist.

Usage
-----
    python tools/validate_lua.py                     # whole repository
    python tools/validate_lua.py Modules/UnitDebuffs.lua Core
    python tools/validate_lua.py -v                  # + one line per file
    python tools/validate_lua.py --selftest          # check the checker itself

Output is compiler-style (`path:line:col: error: message`), so it is easy to
grep. Exit codes: 0 = clean, 1 = at least one file failed, 2 = usage error.
Requires Python 3.8+, standard library only.
"""

from __future__ import print_function

import argparse
import os
import sys
import time

# --------------------------------------------------------------------------
# Lua 5.1 lexical grammar
# --------------------------------------------------------------------------

KEYWORDS = frozenset(
    "and break do else elseif end false for function if in local nil not or "
    "repeat return then true until while".split()
)

# Longest operators first: startswith() is tried in this order.
OPERATORS = (
    "...", "..", "==", "~=", "<=", ">=", "::",
    "+", "-", "*", "/", "%", "^", "#", "<", ">", "=",
    "(", ")", "{", "}", "[", "]", ";", ":", ",", ".",
)

CLOSERS = {"(": ")", "[": "]", "{": "}"}

WHITESPACE = " \t\n\f\v"

# Paired markers whose balance the maintainer relies on.
MARKER_PAIRS = (
    ("--@do-not-package@", "--@end-do-not-package@"),
    ("-- KBD START", "-- KBD END"),
    ("-- KNC START", "-- KNC END"),
    ("-- KF START", "-- KF END"),
    ("-- KRI START", "-- KRI END"),
)


class LuaError(Exception):
    """A lexical or structural error, located by line/column."""

    def __init__(self, message, line, col):
        Exception.__init__(self, message)
        self.message = message
        self.line = line
        self.col = col


class Token(object):
    __slots__ = ("kind", "value", "line", "col")

    def __init__(self, kind, value, line, col):
        self.kind = kind          # name | number | string | keyword | op
        self.value = value
        self.line = line
        self.col = col

    def __repr__(self):
        return "Token(%s, %r, %d:%d)" % (self.kind, self.value, self.line, self.col)


class Lexer(object):
    """Single-pass Lua 5.1 lexer. Raises LuaError on malformed input."""

    def __init__(self, src):
        self.src = src
        self.size = len(src)
        self.pos = 0
        self.line = 1
        self.col = 1

    # -- low level ---------------------------------------------------------
    def _peek(self, offset=0):
        idx = self.pos + offset
        return self.src[idx] if idx < self.size else ""

    def _skip(self, count):
        """Advance `count` characters, keeping line/col in sync."""
        src = self.src
        end = min(self.pos + count, self.size)
        while self.pos < end:
            if src[self.pos] == "\n":
                self.line += 1
                self.col = 1
            else:
                self.col += 1
            self.pos += 1

    def _skip_while(self, allowed):
        while self.pos < self.size and self.src[self.pos] in allowed:
            self._skip(1)

    # -- long brackets -----------------------------------------------------
    def _long_level(self):
        """Return the level of the long bracket starting here, or -1."""
        if self._peek() != "[":
            return -1
        level = 0
        idx = self.pos + 1
        while idx < self.size and self.src[idx] == "=":
            level += 1
            idx += 1
        if idx < self.size and self.src[idx] == "[":
            return level
        return -1

    def _read_long(self, level, what):
        opener = "[" + "=" * level + "["
        closer = "]" + "=" * level + "]"
        line, col = self.line, self.col
        self._skip(len(opener))
        idx = self.src.find(closer, self.pos)
        if idx < 0:
            raise LuaError("unterminated %s (opened with %s)" % (what, opener), line, col)
        text = self.src[self.pos:idx]
        self._skip(idx - self.pos + len(closer))
        return text

    # -- literals ----------------------------------------------------------
    def _read_string(self):
        quote = self._peek()
        line, col = self.line, self.col
        start = self.pos
        self._skip(1)
        while True:
            if self.pos >= self.size:
                raise LuaError("unterminated string", line, col)
            ch = self.src[self.pos]
            if ch == quote:
                self._skip(1)
                return self.src[start:self.pos]
            if ch == "\n":
                raise LuaError(
                    "unterminated string (raw newline inside a short string; "
                    "use \\n or a [[long string]])", line, col)
            if ch == "\\":
                self._skip(1)
                esc = self._peek()
                if esc == "":
                    raise LuaError("unterminated string (trailing backslash)", line, col)
                if esc == "z":
                    # Lua 5.2+ but harmless to accept; skips following whitespace
                    self._skip(1)
                    self._skip_while(WHITESPACE)
                    continue
                if esc.isdigit():
                    for _ in range(3):
                        if self._peek().isdigit():
                            self._skip(1)
                    continue
                if esc == "x":
                    self._skip(1)
                    for _ in range(2):
                        if self._peek() in "0123456789abcdefABCDEF":
                            self._skip(1)
                    continue
                self._skip(1)  # \a \b \f \n \r \t \v \\ \" \' and anything else
                continue
            self._skip(1)

    def _read_number(self):
        line, col = self.line, self.col
        start = self.pos
        src = self.src
        if src[self.pos] == "0" and self._peek(1) in "xX":
            self._skip(2)
            self._skip_while("0123456789abcdefABCDEF")
            return Token("number", src[start:self.pos], line, col)
        seen_dot = False
        while True:
            ch = self._peek()
            if ch.isdigit():
                self._skip(1)
            elif ch == "." and not seen_dot and self._peek(1) != ".":
                seen_dot = True
                self._skip(1)
            else:
                break
        if self._peek() in "eE":
            self._skip(1)
            if self._peek() in "+-":
                self._skip(1)
            self._skip_while("0123456789")
        return Token("number", src[start:self.pos], line, col)

    # -- main loop ---------------------------------------------------------
    def tokens(self):
        src = self.src
        while self.pos < self.size:
            ch = src[self.pos]
            if ch in WHITESPACE:
                self._skip(1)
                continue

            line, col = self.line, self.col

            # comments: --[[ long ]] or -- line
            if ch == "-" and self._peek(1) == "-":
                self._skip(2)
                level = self._long_level()
                if level >= 0:
                    self._read_long(level, "long comment")
                else:
                    while self.pos < self.size and src[self.pos] != "\n":
                        self._skip(1)
                continue

            if ch in "\"'":
                yield Token("string", self._read_string(), line, col)
                continue

            if ch == "[":
                level = self._long_level()
                if level >= 0:
                    yield Token("string", self._read_long(level, "long string"), line, col)
                    continue

            if ch.isdigit() or (ch == "." and self._peek(1).isdigit()):
                yield self._read_number()
                continue

            if ch == "_" or (ch.isalpha() and ch.isascii()):
                start = self.pos
                while True:
                    nxt = self._peek()
                    if nxt == "_" or (nxt.isalnum() and nxt.isascii()):
                        self._skip(1)
                    else:
                        break
                word = src[start:self.pos]
                yield Token("keyword" if word in KEYWORDS else "name", word, line, col)
                continue

            if not ch.isascii():
                raise LuaError(
                    "non-ASCII character %s outside a string or comment "
                    "(Lua 5.1 identifiers must be ASCII)" % ascii(ch), line, col)

            for op in OPERATORS:
                if src.startswith(op, self.pos):
                    self._skip(len(op))
                    yield Token("op", op, line, col)
                    break
            else:
                raise LuaError("unexpected character %s" % ascii(ch), line, col)


# --------------------------------------------------------------------------
# Block-structure checker
# --------------------------------------------------------------------------

# kind -> keyword that closes it
OPENERS = {
    "function": "end",
    "do": "end",
    "if": "end",
    "for": "end",
    "while": "end",
    "repeat": "until",
}


class Block(object):
    __slots__ = ("kind", "line", "col", "want", "had_else")

    def __init__(self, kind, line, col, want=None):
        self.kind = kind
        self.line = line
        self.col = col
        self.want = want      # header keyword still missing ("then"/"do")
        self.had_else = False


def check_structure(tokens):
    """Walk the token stream and return a list of (line, col, sev, message)."""
    problems = []
    blocks = []
    delims = []

    def err(line, col, message):
        problems.append((line, col, "error", message))

    for tok in tokens:
        if tok.kind == "keyword":
            word = tok.value
            if word == "function":
                blocks.append(Block("function", tok.line, tok.col))
            elif word == "if":
                blocks.append(Block("if", tok.line, tok.col, "then"))
            elif word in ("for", "while"):
                blocks.append(Block(word, tok.line, tok.col, "do"))
            elif word == "repeat":
                blocks.append(Block("repeat", tok.line, tok.col))
            elif word == "do":
                top = blocks[-1] if blocks else None
                if top is not None and top.want == "do":
                    top.want = None              # closes the for/while header
                else:
                    blocks.append(Block("do", tok.line, tok.col))
            elif word == "then":
                top = blocks[-1] if blocks else None
                if top is not None and top.kind == "if" and top.want == "then":
                    top.want = None
                else:
                    err(tok.line, tok.col, "'then' outside an if condition")
            elif word == "elseif":
                top = blocks[-1] if blocks else None
                if top is None or top.kind != "if" or top.want is not None:
                    err(tok.line, tok.col, "'elseif' outside an if block")
                elif top.had_else:
                    err(tok.line, tok.col, "'elseif' after 'else'")
                else:
                    top.want = "then"
            elif word == "else":
                top = blocks[-1] if blocks else None
                if top is None or top.kind != "if" or top.want is not None:
                    err(tok.line, tok.col, "'else' outside an if block")
                elif top.had_else:
                    err(tok.line, tok.col, "duplicate 'else' in the same if")
                else:
                    top.had_else = True
            elif word == "until":
                top = blocks[-1] if blocks else None
                if top is None:
                    err(tok.line, tok.col, "'until' without a matching 'repeat'")
                elif top.kind == "repeat":
                    blocks.pop()
                else:
                    err(tok.line, tok.col,
                        "'until' cannot close the '%s' opened at line %d"
                        % (top.kind, top.line))
                    blocks.pop()
            elif word == "end":
                top = blocks[-1] if blocks else None
                if top is None:
                    err(tok.line, tok.col, "'end' without a matching block")
                    continue
                if top.kind == "repeat":
                    err(tok.line, tok.col,
                        "'end' cannot close the 'repeat' opened at line %d "
                        "(a repeat needs 'until')" % top.line)
                elif top.want is not None:
                    err(tok.line, tok.col,
                        "'%s' opened at line %d is missing its '%s'"
                        % (top.kind, top.line, top.want))
                blocks.pop()
        elif tok.kind == "op":
            if tok.value in CLOSERS:
                delims.append((tok.value, tok.line, tok.col))
            elif tok.value in (")", "]", "}"):
                if not delims:
                    err(tok.line, tok.col, "unexpected '%s'" % tok.value)
                    continue
                opener, oline, _ocol = delims.pop()
                if CLOSERS[opener] != tok.value:
                    err(tok.line, tok.col,
                        "'%s' closes the '%s' opened at line %d"
                        % (tok.value, opener, oline))

    for opener, oline, ocol in delims:
        err(oline, ocol, "'%s' is never closed" % opener)
    for blk in blocks:
        err(blk.line, blk.col,
            "'%s' is never closed (missing '%s')" % (blk.kind, OPENERS[blk.kind]))

    problems.sort(key=lambda p: (p[0], p[1]))
    return problems


# --------------------------------------------------------------------------
# Kallye-specific text checks
# --------------------------------------------------------------------------

def check_markers(text):
    """Verify that paired comment markers are balanced and correctly ordered."""
    lines = text.split("\n")
    problems = []
    for opener, closer in MARKER_PAIRS:
        open_line = None
        for number, line in enumerate(lines, 1):
            if opener in line:
                if open_line is not None:
                    problems.append((number, 1, "error",
                                     "%r nested inside the block opened at line %d"
                                     % (opener, open_line)))
                open_line = number
            if closer in line:
                if open_line is None:
                    problems.append((number, 1, "error",
                                     "%r without a preceding %r" % (closer, opener)))
                open_line = None
        if open_line is not None:
            problems.append((open_line, 1, "error",
                             "%r is never closed (missing %r)" % (opener, closer)))
    problems.sort(key=lambda p: (p[0], p[1]))
    return problems


# --------------------------------------------------------------------------
# Per-source / per-file validation
# --------------------------------------------------------------------------

def check_source(text, extra=True):
    """Validate a decoded Lua source string. Returns (problems, line_count)."""
    normalized = text.replace("\r\n", "\n").replace("\r", "\n")
    problems = []
    try:
        tokens = list(Lexer(normalized).tokens())
    except LuaError as exc:
        problems.append((exc.line, exc.col, "error", exc.message))
    else:
        problems.extend(check_structure(tokens))
    if extra:
        problems.extend(check_markers(normalized))
    problems.sort(key=lambda p: (p[0], p[1]))
    return problems, normalized.count("\n") + 1


def check_file(path, extra=True):
    """Validate one file on disk. Returns (problems, line_count)."""
    with open(path, "rb") as handle:
        raw = handle.read()

    problems = []
    if raw.startswith(b"\xef\xbb\xbf"):
        problems.append((1, 1, "error",
                         "file starts with a UTF-8 BOM (WoW refuses to parse it)"))
        raw = raw[3:]

    try:
        text = raw.decode("utf-8")
    except UnicodeDecodeError as exc:
        line = raw[:exc.start].count(b"\n") + 1
        problems.append((line, 1, "error",
                         "invalid UTF-8 byte 0x%02X at offset %d"
                         % (raw[exc.start], exc.start)))
        text = raw.decode("utf-8", "replace")

    found, line_count = check_source(text, extra=extra)
    problems.extend(found)
    problems.sort(key=lambda p: (p[0], p[1]))
    return problems, line_count

# --------------------------------------------------------------------------
# File discovery
# --------------------------------------------------------------------------

DEFAULT_EXCLUDES = (".git", ".release", ".sfdx", "docs", "node_modules", "__pycache__")


def collect_files(paths, excludes):
    """Return every *.lua file under `paths`, skipping vendored/build dirs."""
    found = []
    for raw in paths:
        if os.path.isfile(raw):
            if raw.lower().endswith(".lua"):
                found.append(raw)
            continue
        for root, dirs, files in os.walk(raw):
            dirs[:] = sorted(d for d in dirs
                             if d not in excludes and not d.startswith("."))
            for name in sorted(files):
                if name.lower().endswith(".lua"):
                    found.append(os.path.join(root, name))
    return found


def rel(path):
    try:
        return os.path.relpath(path)
    except ValueError:
        return path


# --------------------------------------------------------------------------
# Self-test: a checker that is not tested is not a gate
# --------------------------------------------------------------------------

SELFTEST_CASES = (
    # (name, Lua source, must be accepted?)
    ("empty file", "", True),
    ("comments only", "-- nothing to see\n--[[ block\ncomment ]]\n", True),
    ("function", "local function add(a, b) return a + b end\n", True),
    ("method definition",
     "function ns.Thing:Do(a, ...) return a, ... end\n", True),
    ("if/elseif/else", "if a then b() elseif c then d() else e() end\n", True),
    ("loops", "for i = 1, #t do while x do do y() end end end\n", True),
    ("generic for", "for k, v in pairs(t) do print(k, v) end\n", True),
    ("repeat/until", "repeat x() until y\n", True),
    ("long string", "local s = [==[ end ]] \"q\" ]==]\n", True),
    ("escaped quotes", "local s = \"a \\\" end \\\" b\"\n", True),
    ("keywords in a comment", "-- end until then ]] do\nlocal x = 1\n", True),
    ("numbers", "local a, b, c, d = 1, 1.5, 0xff, 1e-3\n", True),
    ("package markers",
     "--@do-not-package@\nlocal x = 1\n--@end-do-not-package@\n", True),
    ("locale markers",
     "-- KBD START\nl.A = \"a\";\n-- KBD END\n", True),
    ("missing end", "if x then\n    y()\n", False),
    ("unexpected end", "foo()\nend\n", False),
    ("raw newline in string", "local s = \"abc\ndef\"\n", False),
    ("unterminated long string", "local s = [[abc\n", False),
    ("duplicate else", "if a then b() else c() else d() end\n", False),
    ("end closing repeat", "repeat x() end\n", False),
    ("unclosed parenthesis", "a = (1 + 2\n", False),
    ("mismatched bracket", "a = {1, 2)\n", False),
    ("until without repeat", "x() until y\n", False),
    ("javascript operator", "if a != b then c() end\n", False),
    ("non-ascii identifier", "local caf\u00e9 = 1\n", False),
    ("unbalanced package markers",
     "--@do-not-package@\nlocal x = 1\n", False),
)


def run_selftest():
    print("validate_lua self-test (%d cases)" % len(SELFTEST_CASES))
    failures = 0
    for name, source, expect_ok in SELFTEST_CASES:
        problems, _lines = check_source(source)
        accepted = not problems
        if accepted == expect_ok:
            detail = "accepted" if accepted else problems[0][3]
            print("  PASS  %-28s %s" % (name, detail))
        else:
            failures += 1
            if expect_ok:
                print("  FAIL  %-28s rejected: %s" % (name, problems[0][3]))
            else:
                print("  FAIL  %-28s should have been rejected" % name)
    if failures:
        print("SELFTEST FAILED: %d case(s)" % failures)
        return 1
    print("SELFTEST OK")
    return 0

# --------------------------------------------------------------------------
# CLI
# --------------------------------------------------------------------------

def main(argv=None):
    parser = argparse.ArgumentParser(
        prog="validate_lua.py",
        description="Lua 5.1 syntax gate for the Kallye addon family "
                    "(lexer + block structure + Kallye marker checks).",
        epilog="Exit codes: 0 = all files clean, 1 = at least one error, "
               "2 = usage error.")
    parser.add_argument("paths", nargs="*", default=None,
                        metavar="PATH",
                        help="files or directories to check (default: the repository root)")
    parser.add_argument("-v", "--verbose", action="store_true",
                        help="print one line per file, including the clean ones")
    parser.add_argument("--no-extra", action="store_true",
                        help="skip the Kallye-specific marker checks")
    parser.add_argument("--exclude", action="append", default=[],
                        metavar="DIR", help="extra directory name to skip (repeatable)")
    parser.add_argument("--selftest", action="store_true",
                        help="run the built-in tests of the checker itself and exit")
    args = parser.parse_args(argv)

    if args.selftest:
        return run_selftest()

    excludes = set(DEFAULT_EXCLUDES) | set(args.exclude)
    paths = args.paths or ["."]
    files = collect_files(paths, excludes)
    if not files:
        sys.stderr.write("validate_lua: no .lua file found under %s\n"
                         % ", ".join(paths))
        return 2

    started = time.time()
    failed_files = 0
    error_count = 0
    for path in files:
        try:
            problems, line_count = check_file(path, extra=not args.no_extra)
        except (IOError, OSError) as exc:
            print("%s: error: cannot read file (%s)" % (rel(path), exc))
            failed_files += 1
            error_count += 1
            continue
        if problems:
            failed_files += 1
            error_count += len(problems)
            for line, col, severity, message in problems:
                print("%s:%d:%d: %s: %s" % (rel(path), line, col, severity, message))
        elif args.verbose:
            print("%s: ok (%d lines)" % (rel(path), line_count))

    elapsed = time.time() - started
    print("%d file(s) checked, %d error(s) in %d file(s), %.2fs"
          % (len(files), error_count, failed_files, elapsed))
    if failed_files:
        sys.stderr.write("FAILED: fix the errors above and re-run.\n")
        return 1
    print("OK: every file lexes and is structurally balanced "
          "(in-game verification is still required).")
    return 0


if __name__ == "__main__":
    sys.exit(main())

