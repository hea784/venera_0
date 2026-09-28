#!/usr/bin/env python3
"""Guard: every translatable string literal in lib/ must have zh_CN and zh_TW
entries in assets/translation.json. Full localization is this fork's promise,
so a missing entry should fail CI instead of silently showing English.

Handles Dart's adjacent-string concatenation ("foo"\n"bar".tl).
"""
import json
import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
translations = json.loads(
    (ROOT / "assets/translation.json").read_text(encoding="utf-8")
)
zh_cn = translations.get("zh_CN", {})
zh_tw = translations.get("zh_TW", {})

LITERAL = r'''(?:"(?:[^"\\\n]|\\.)*"|'(?:[^'\\\n]|\\.)*')'''
KEY = re.compile(
    r"(" + LITERAL + r"(?:\s*\n\s*" + LITERAL + r")*)\s*\.(?:tl|tlParams)\b"
)
LIT = re.compile(LITERAL)


def literal_text(chunk: str) -> str:
    parts = LIT.findall(chunk)
    out = []
    for part in parts:
        if part[0] in "\"'":
            out.append(part[1:-1])
        else:  # r"..." raw string
            out.append(part[2:-1])
    return "".join(out)


keys = {}
skipped = set()
for path in sorted((ROOT / "lib").rglob("*.dart")):
    code = path.read_text(encoding="utf-8", errors="replace")
    for match in KEY.finditer(code):
        key = literal_text(match.group(1))
        if not key:
            continue
        if "$" in key:
            skipped.add(key)  # built at runtime, cannot be a static json key
            continue
        keys.setdefault(key, set()).add(str(path.relative_to(ROOT)))

missing_cn = sorted(k for k in keys if k not in zh_cn)
missing_tw = sorted(k for k in keys if k not in zh_tw)

if missing_cn or missing_tw:
    print("Translation coverage is incomplete.\n")
    print("Add the following keys to assets/translation.json (both locales):\n")
    for key in sorted(set(missing_cn) | set(missing_tw)):
        where = sorted({str(p).split("\\")[-1] for p in keys.get(key, set())})
        print(f"  {key!r}   ({', '.join(where)})")
    sys.exit(1)

print(
    f"translations ok ({len(keys)} strings, "
    f"{len(skipped)} runtime-composed skipped)"
)
