"""Catalog access for MaxxedSUSE."""

import json
import os
from pathlib import Path

if os.environ.get("MXX_DATADIR"):
    CATALOG_PATH = Path(os.environ["MXX_DATADIR"]) / "catalog" / "apps.json"
else:
    CATALOG_PATH = Path("/usr/share/maxxedsuse/catalog/apps.json")
    if not CATALOG_PATH.exists():
        CATALOG_PATH = Path(__file__).resolve().parent.parent.parent / "catalog" / "apps.json"


def load_apps():
    with CATALOG_PATH.open(encoding="utf-8") as handle:
        return json.load(handle)


def categories(apps):
    result = []
    seen = set()
    for app in apps:
        if app["category"] not in seen:
            seen.add(app["category"])
            result.append((app["category"], app["category_name"]))
    return result
