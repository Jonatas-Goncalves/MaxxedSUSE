"""Installation status and privileged action dispatch."""

import os
import subprocess
from pathlib import Path

from .catalog import CATALOG_PATH

INSTALLED_HELPER = Path("/usr/libexec/maxxedsuse/maxxedsuse-helper")
LAUNCHER_DIR = Path(os.environ.get("XDG_DATA_HOME", Path.home() / ".local/share")) / "applications"
LAUNCHER_PATH = LAUNCHER_DIR / "maxxedsuse-user.desktop"
LAUNCHER_MARKER = "Created by MaxxedSUSE.sh"


def user_launcher_installed():
    if not LAUNCHER_PATH.is_file():
        return False
    try:
        return LAUNCHER_MARKER in LAUNCHER_PATH.read_text(encoding="utf-8")
    except OSError:
        return False


def remove_user_launcher():
    if not user_launcher_installed():
        return False
    try:
        LAUNCHER_PATH.unlink()
    except OSError:
        return False
    return not LAUNCHER_PATH.exists()


def helper_command(*args):
    """Use pkexec with the installed helper, or sudo for a source checkout."""
    if INSTALLED_HELPER.exists() and Path("/usr/share/polkit-1/actions/io.github.JonatasGoncalves.MaxxedSUSE.policy").exists():
        return ["pkexec", str(INSTALLED_HELPER), *args]
    local = Path(__file__).resolve().parent.parent / "maxxedsuse-helper.py"
    return ["sudo", "-E", "python3", str(local), *args]


def is_installed(app):
    check = app.get("check", "")
    if not check:
        return None
    if app["backend"] in ("zypper", "script"):
        if check.startswith("/"):
            return Path(check).exists()
        return subprocess.run(["rpm", "-q", check], capture_output=True).returncode == 0
    if app["backend"] == "flatpak":
        result = subprocess.run(
            ["flatpak", "list", "--app", "--columns=application"],
            capture_output=True, text=True,
        )
        return result.returncode == 0 and check in result.stdout.splitlines()
    return None


def install(app_ids):
    command = helper_command("install", *app_ids)
    return subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                            text=True, bufsize=1)


def run_setup():
    """Run the initial repository setup through the privileged helper."""
    command = helper_command("setup")
    return subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                            text=True, bufsize=1)


def setup_needed():
    return not Path("/var/lib/maxxedsuse/state/setup.done").exists()
