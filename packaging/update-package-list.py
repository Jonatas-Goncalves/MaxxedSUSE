#!/usr/bin/env python3
"""Regenerate PackageList.md from the application catalog."""

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
apps = json.loads((ROOT / "catalog" / "apps.json").read_text(encoding="utf-8"))

lines = [
    "# Package List",
    "",
    "Applications available in MaxxedSUSE, grouped by category.",
    "",
]

categories = []
for app in apps:
    if app["category"] not in categories:
        categories.append(app["category"])

for category in categories:
    entries = [app for app in apps if app["category"] == category]
    lines.append(f"## {entries[0]['category_name']}")
    lines.extend(f"- {app['name']}" for app in entries)
    lines.append("")

while lines and not lines[-1]:
    lines.pop()
(ROOT / "PackageList.md").write_text("\n".join(lines) + "\n", encoding="utf-8")
print("Updated PackageList.md")
