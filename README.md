<h1 align="center">MaxxedSUSE</h1>

<p align="center">
  <img src="data/maxxedsuse.svg" alt="MaxxedSUSE" width="180">
</p>

MaxxedSUSE is a setup utility for openSUSE Tumbleweed. It helps users coming from Windows configure a fresh installation and install common applications, games and tools without having to learn the terminal.

> Supported distribution: **openSUSE Tumbleweed only**.

## Features

- Simple first-run setup: adds the MaxxedSUSE and Flathub repositories and updates the system.
- System configuration: hostname, graphics drivers, kernel parameters and swap tuning.
- Application catalog organized into categories.
- Installation status for every application.
- Interface available in Portuguese (Brazil), English (US), Spanish, Italian and French. The language is detected from the system locale and can be changed on the first page with immediate effect. Categories and application descriptions follow the selected language.

## How to run

Just run this command:

```bash
curl -L https://raw.githubusercontent.com/Jonatas-Goncalves/MaxxedSUSE/main/MaxxedSUSE.sh | bash
```

`MaxxedSUSE.sh` downloads or updates the project, prepares the dependencies and starts the application. With the RPM installed, the same application is available from the desktop menu or as `maxxedsuse`.

When the project is run directly from the command without installing the RPM, a user-level launcher is added to the System menu using the project icon. The **Remove desktop shortcut** action on the first page removes it.

The first page lets you choose the language and run the initial setup. Privileged actions ask for the administrator password in a graphical dialog; the setup also skips the MaxxedSUSE repository when it is already configured. Zypper never forces conflict resolution; a transaction with unresolved conflicts is skipped without installing it. The next page lists the sections; each section opens its own page with its applications.

RPM packages for Tumbleweed are published in the `home:MaxxedSUSE` project on the Open Build Service.

An AppImage can also be built from the source tree:

```bash
bash packaging/build-appimage.sh
```

The resulting file is written to `build/`. Set `VERSION` to choose the artifact name. The AppImage bundles the Python runtime, GTK4/libadwaita stack, introspection data, native libraries and application files. `libfuse2` is required to run it.

## Application catalog

`catalog/apps.json` is the single source of truth for applications. The graphical interface, package checks, RPM and AppImage all read it, so add or update applications there.

Each entry uses these fields:

- `id` — unique lowercase identifier.
- `name` and `description` — text shown in the interface.
- `category` and `category_name` — section slug and visible title.
- `backend` — `zypper`, `flatpak` or `script`.
- `packages` — RPM names for `zypper`, one Flatpak application ID for `flatpak`, or an empty list for `script`.
- `check` — RPM name, absolute installed path, or Flatpak application ID used to show the status icon. Leave it empty if no reliable check exists.
- `script` — required only for `backend: "script"`; a self-contained shell snippet that runs as root. Do not call local shell helpers.

After changing the catalog, regenerate the documentation list:

```bash
python3 packaging/update-package-list.py
```

## Repositories

MaxxedSUSE uses only two repositories:

- `home:MaxxedSUSE` — packages maintained by this project.
- Flathub — Flatpak applications.

Leap repositories were removed because maintaining a separate set of packages for a fixed release is no longer practical. The Emulators repository was removed because virtually all emulators are now available directly from Tumbleweed. The Wine repository is no longer used or referenced.

## Kernel parameters

Tumbleweed no longer uses `/etc/default/grub` or `grub2-mkconfig`. Both systemd-boot and GRUB2-BLS read the kernel command line from `/etc/kernel/cmdline` and regenerate boot entries with `sdbootutil`.

If kernel parameter management is exposed in the interface, it must detect the bootloader with `update-bootloader --show`, write to `/etc/kernel/cmdline` and run `sdbootutil update-all-entries`. Do not use `/etc/default/grub`, `grub2-mkconfig`, `mkinitrd` or `dracut -f --regenerate-all`. A reboot is required for parameter changes to take effect.

## Project structure

```
MaxxedSUSE.sh             single entry point
catalog/apps.json         application catalog
src/maxxedsuse/           GTK4 interface
src/maxxedsuseapp.py      application launcher
src/maxxedsuse-helper.py  privileged helper
po/                       gettext translation catalogs
data/                     desktop file, icon and polkit policy
packaging/                RPM spec and AppImage build script
```

## License

See [LICENSE](LICENSE).
