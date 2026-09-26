#!/usr/bin/env python3
"""Guard: every translatable setting title in the settings pages must be
either present in lib/foundation/settings_index.dart (so users can find it via
settings search) or explicitly listed in NON_INDEXABLE below (buttons,
subtitles, option labels, dialog titles).

Run in CI; exits 1 with the list of titles that need a decision.
"""
import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
PAGES = {
    "lib/pages/settings/explore_settings.dart": 0,
    "lib/pages/settings/reader.dart": 1,
    "lib/pages/settings/appearance.dart": 2,
    "lib/pages/settings/local_favorites.dart": 3,
    "lib/pages/settings/app.dart": 4,
    "lib/pages/settings/network.dart": 5,
    "lib/pages/settings/about.dart": 6,
    "lib/pages/settings/debug.dart": 7,
}
SECTIONS = [
    "Explore",
    "Reading",
    "Appearance",
    "Local Favorites",
    "APP",
    "Network",
    "About",
    "Debug",
]
# Titles that are not settings a user would search for: button labels,
# subtitles, option values and dialog titles. Keep this list explicit - adding
# an entry here means "deliberately not searchable".
NON_INDEXABLE = {
    "Add keyword",
    "Add",
    "Enable",
    "Reset",
    "When using Continuous(Top to Bottom) mode",
    "Set Cache Limit",
    "App",
    "all",
    "info",
    "warning",
    "error",
    "Clear",
    "Export",
    "Copy",
    "Continue",
    "Direct",
    "System",
    "Manual",
    "Save",
    "New version available",
    "Feedback, suggestions and help",
    "Check",
    "Releases page",
    "Update",
    "Run",
    # failure dialog / buttons in about.dart
    "Failed to download update",
    "Retry",
}

TITLE_PATTERNS = [
    r"title:\s*['\"]([^'\"]+)['\"]\s*\.tl",
    r"title:\s*Text\(['\"]([^'\"]+)['\"]\.tl",
    r"child:\s*Text\(['\"]([^'\"]+)['\"]\.tl",
]

index_code = (ROOT / "lib/foundation/settings_index.dart").read_text(encoding="utf-8")
indexed = set(re.findall(r'SettingsEntryRef\(\s*"([^"]+)"', index_code))

uncovered = []
for page, section in PAGES.items():
    code = (ROOT / page).read_text(encoding="utf-8")
    titles = []
    for pattern in TITLE_PATTERNS:
        titles.extend(re.findall(pattern, code))
    for title in dict.fromkeys(titles):
        if title in indexed or title in SECTIONS or title in NON_INDEXABLE:
            continue
        uncovered.append((page, section, title))

if uncovered:
    print("Settings search index is out of sync.\n")
    print("Add the following to lib/foundation/settings_index.dart (with the")
    print("section id shown), or list them in NON_INDEXABLE in")
    print("scripts/check_settings_index.py if they are not searchable:\n")
    for page, section, title in uncovered:
        print(f"  [{section}] {title!r}   ({page})")
    sys.exit(1)

print(f"settings index ok ({len(indexed)} entries)")
