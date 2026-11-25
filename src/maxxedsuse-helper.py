#!/usr/bin/python3
"""Privileged installation helper for MaxxedSUSE.

Invoked through pkexec by the graphical interface. It accepts only application
identifiers present in the catalog and never executes arbitrary input.
"""

import json
import os
import shlex
import subprocess
import sys
from pathlib import Path

if os.environ.get("MXX_DATADIR"):
    CATALOG_PATH = Path(os.environ["MXX_DATADIR"]) / "catalog" / "apps.json"
else:
    CATALOG_PATH = Path("/usr/share/maxxedsuse/catalog/apps.json")
    if not CATALOG_PATH.exists():
        CATALOG_PATH = Path(__file__).resolve().parent.parent / "catalog" / "apps.json"


def load_catalog():
    with CATALOG_PATH.open(encoding="utf-8") as handle:
        return {app["id"]: app for app in json.load(handle)}


def run(command, description):
    print(f"==> {description}", flush=True)
    result = subprocess.run(command, shell=True, check=False)
    if result.returncode != 0:
        print(f"Command failed with status {result.returncode}: {command}", file=sys.stderr, flush=True)
    return result.returncode == 0


def install(app):
    backend = app["backend"]
    name = app["name"]
    if backend == "zypper":
        packages = " ".join(shlex.quote(p) for p in app["packages"])
        return run(
            f"zypper --non-interactive --gpg-auto-import-keys install "
            f"--allow-unsigned-rpm --auto-agree-with-licenses {packages}",
            f"Installing {name}",
        )
    if backend == "flatpak":
        app_id = app["packages"][0]
        return run(
            f"flatpak install flathub {shlex.quote(app_id)} -y",
            f"Installing {name} from Flathub",
        )
    if backend == "script":
        return run(app["script"], f"Installing {name}")
    print(f"Unknown backend for {name}: {backend}", file=sys.stderr)
    return False


SETUP_STEPS = [
    ("Adding the MaxxedSUSE repository",
     "zypper --gpg-auto-import-keys addrepo --refresh "
     "https://download.opensuse.org/repositories/home:MaxxedSUSE/openSUSE_Tumbleweed/ MaxxedSUSE"),
    ("Refreshing repositories", "zypper --gpg-auto-import-keys refresh"),
    ("Updating the system", "zypper --non-interactive dup --auto-agree-with-licenses --no-recommends"),
    ("Installing Flatpak", "zypper --non-interactive install flatpak"),
    ("Adding Flathub",
     "flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo"),
    ("Installing media codecs",
     "zypper --non-interactive install --allow-vendor-change ffmpeg-7 gstreamer-plugins-bad "
     "lame gstreamer-plugins-libav gstreamer-plugins-ugly libavresample4_0 libavdevice60 "
     "vlc-codec-gstreamer"),
]


def setup_system():
    for description, command in SETUP_STEPS:
        if not run(command, description):
            return False
    state = Path("/var/lib/maxxedsuse/state")
    state.mkdir(parents=True, exist_ok=True)
    (state / "setup.done").write_text("DONE\n", encoding="utf-8")
    return True


def main():
    if len(sys.argv) < 2 or sys.argv[1] not in ("install", "setup"):
        print("Usage: maxxedsuse-helper install APP_ID [APP_ID...] | maxxedsuse-helper setup",
              file=sys.stderr)
        return 2
    if os.geteuid() != 0:
        print("This helper must run as root.", file=sys.stderr)
        return 2

    if sys.argv[1] == "setup":
        return 0 if setup_system() else 1

    catalog = load_catalog()
    ok = True
    for app_id in sys.argv[2:]:
        app = catalog.get(app_id)
        if not app:
            print(f"Unknown application: {app_id}", file=sys.stderr)
            ok = False
            continue
        if not install(app):
            ok = False
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
