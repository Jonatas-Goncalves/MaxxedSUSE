#!/bin/bash
# Build a self-contained AppImage for openSUSE Tumbleweed.
# Run this script on Tumbleweed so the bundled native libraries match the target system.
set -euo pipefail

VERSION="${VERSION:-4.0}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD="$ROOT/build"
APPDIR="$BUILD/MaxxedSUSE.AppDir"
TOOL="$BUILD/appimagetool-x86_64.AppImage"
TOOL_URL="https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage"

PYVER="$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')"
STDLIB="$(python3 -c 'import sysconfig; print(sysconfig.get_paths()["stdlib"])')"
SITEPACKAGES="$(python3 -c 'import gi, os; print(os.path.dirname(os.path.dirname(gi.__file__)))')"
LIBDIR="$(dirname "$STDLIB")"
if [[ "$(basename "$LIBDIR")" != "lib64" && -d /usr/lib64 ]]; then
	LIBDIR="/usr/lib64"
fi

for dep in patchelf msgfmt curl; do
	command -v "$dep" >/dev/null 2>&1 || { echo "Missing build tool: $dep" >&2; exit 1; }
done

bash "$ROOT/po/build.sh"

rm -rf "$APPDIR"
mkdir -p "$APPDIR/usr/bin" \
         "$APPDIR/usr/lib/girepository-1.0" \
         "$APPDIR/usr/lib/gdk-pixbuf-2.0/2.10.0/loaders" \
         "$APPDIR/usr/lib/gio/modules" \
         "$APPDIR/usr/share/maxxedsuse" \
         "$APPDIR/usr/share/applications" \
         "$APPDIR/usr/share/icons/hicolor/scalable/apps" \
         "$APPDIR/usr/share/glib-2.0/schemas"

# --- Application files -----------------------------------------------------
cp -r "$ROOT/src" "$APPDIR/usr/share/maxxedsuse/"
cp -r "$ROOT/catalog" "$APPDIR/usr/share/maxxedsuse/"
cp -r "$ROOT/data" "$APPDIR/usr/share/maxxedsuse/"
cp -r "$ROOT/po/locale" "$APPDIR/usr/share/maxxedsuse/po/"
cp "$ROOT/data/maxxedsuse.desktop" "$APPDIR/usr/share/applications/"
cp "$ROOT/data/maxxedsuse.svg" "$APPDIR/usr/share/icons/hicolor/scalable/apps/"
cp "$ROOT/data/maxxedsuse.desktop" "$APPDIR/maxxedsuse.desktop"
cp "$ROOT/data/maxxedsuse.svg" "$APPDIR/maxxedsuse.svg"

# --- Python runtime ---------------------------------------------------------
cp -L "$(command -v python3)" "$APPDIR/usr/bin/python3"
mkdir -p "$APPDIR$(dirname "$STDLIB")" "$APPDIR$(dirname "$SITEPACKAGES")"
cp -r "$STDLIB" "$APPDIR$STDLIB"
rm -rf "$APPDIR$STDLIB/site-packages"
mkdir -p "$APPDIR$SITEPACKAGES"
for package in gi cairo pycairo pygobject; do
	for candidate in "$SITEPACKAGES/$package" "$SITEPACKAGES/${package}"*; do
		[[ -e "$candidate" ]] && cp -r "$candidate" "$APPDIR$SITEPACKAGES/"
	done
done

# --- GObject introspection and shared data ---------------------------------
cp /usr/lib64/girepository-1.0/*.typelib "$APPDIR/usr/lib/girepository-1.0/" 2>/dev/null || true
cp /usr/lib/girepository-1.0/*.typelib "$APPDIR/usr/lib/girepository-1.0/" 2>/dev/null || true
cp /usr/share/glib-2.0/schemas/*.gschema.xml "$APPDIR/usr/share/glib-2.0/schemas/" 2>/dev/null || true
cp /usr/lib64/gdk-pixbuf-2.0/2.10.0/loaders/*.so "$APPDIR/usr/lib/gdk-pixbuf-2.0/2.10.0/loaders/" 2>/dev/null || true
cp /usr/lib64/gio/modules/*.so "$APPDIR/usr/lib/gio/modules/" 2>/dev/null || true

# --- Native libraries -------------------------------------------------------
collect_libs() {
	local binary="$1" lib target
	while read -r lib; do
		[[ -f "$lib" ]] || continue
		case "$lib" in "$APPDIR"/*) continue ;; esac
		target="$APPDIR/usr/lib/$(basename "$lib")"
		[[ -e "$target" ]] && continue
		cp -L "$lib" "$target"
		collect_libs "$target"
	done < <(ldd "$binary" 2>/dev/null | awk '/=>/ {print $3} /^\s*\// {print $1}')
}

collect_libs "$APPDIR/usr/bin/python3"
for so in "$APPDIR$SITEPACKAGES"/gi/*.so "$APPDIR/usr/lib/gdk-pixbuf-2.0/2.10.0/loaders/"*.so \
          "$APPDIR/usr/lib/gio/modules/"*.so; do
	[[ -e "$so" ]] && collect_libs "$so"
done
for lib in libgtk-4.so.1 libadwaita-1.so.1 libgirepository-1.0.so.1; do
	system_lib="$(ldconfig -p 2>/dev/null | awk -v n="$lib" '$1 == n {print $NF; exit}')"
	[[ -n "$system_lib" ]] && collect_libs "$system_lib"
done

find "$APPDIR/usr/lib" -type f -name '*.so*' -exec patchelf --set-rpath '$ORIGIN' {} \; 2>/dev/null || true
patchelf --set-rpath '$ORIGIN/../lib' "$APPDIR/usr/bin/python3"

# --- Runtime environment ----------------------------------------------------
gdk_loader_dir="$APPDIR/usr/lib/gdk-pixbuf-2.0/2.10.0/loaders"
if command -v gdk-pixbuf-query-loaders >/dev/null 2>&1; then
	GDK_PIXBUF_MODULEDIR="$gdk_loader_dir" LD_LIBRARY_PATH="$APPDIR/usr/lib" \
		gdk-pixbuf-query-loaders "$gdk_loader_dir"/*.so 2>/dev/null |
		sed "s|$APPDIR|@APPDIR@|g" > "$APPDIR/usr/lib/gdk-pixbuf-loaders.cache.tpl" || true
fi

cat > "$APPDIR/AppRun" <<EOF
#!/bin/bash
APPDIR="\$(cd "\$(dirname "\${BASH_SOURCE[0]}")" && pwd)"
export LD_LIBRARY_PATH="\$APPDIR/usr/lib:/run/host/usr/lib64:/run/host/lib64:\${LD_LIBRARY_PATH:-}"
export GI_TYPELIB_PATH="\$APPDIR/usr/lib/girepository-1.0"
export PYTHONHOME="\$APPDIR/usr"
export PYTHONPATH="\$APPDIR$SITEPACKAGES:\$APPDIR/usr/share/maxxedsuse/src"
export MXX_DATADIR="\$APPDIR/usr/share/maxxedsuse"
export MXX_LOCALEDIR="\$MXX_DATADIR/po/locale"
export XDG_DATA_DIRS="\$APPDIR/usr/share:\${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"
export GSETTINGS_SCHEMA_DIR="\$APPDIR/usr/share/glib-2.0/schemas"
export GIO_EXTRA_MODULES="\$APPDIR/usr/lib/gio/modules"
if [[ -f "\$APPDIR/usr/lib/gdk-pixbuf-loaders.cache.tpl" ]]; then
	sed "s|@APPDIR@|\$APPDIR|g" "\$APPDIR/usr/lib/gdk-pixbuf-loaders.cache.tpl" > /tmp/maxxedsuse-loaders.cache
	export GDK_PIXBUF_MODULE_FILE=/tmp/maxxedsuse-loaders.cache
fi
exec "\$APPDIR/usr/bin/python3" "\$MXX_DATADIR/src/maxxedsuseapp.py" "\$@"
EOF

cat > "$APPDIR/usr/bin/maxxedsuse" <<'EOF'
#!/bin/bash
exec "$APPDIR/AppRun" "$@"
EOF
chmod +x "$APPDIR/AppRun" "$APPDIR/usr/bin/maxxedsuse"

# --- Packaging --------------------------------------------------------------
mkdir -p "$BUILD"
if [[ ! -x "$TOOL" ]]; then
	echo "Downloading appimagetool..."
	curl -fL "$TOOL_URL" -o "$TOOL"
	chmod +x "$TOOL"
fi

APPIMAGE_TOOL="$TOOL"
if ! "$TOOL" --version >/dev/null 2>&1; then
	(cd "$BUILD" && ./appimagetool-x86_64.AppImage --appimage-extract >/dev/null)
	APPIMAGE_TOOL="$BUILD/squashfs-root/AppRun"
fi

echo "Building MaxxedSUSE-$VERSION-x86_64.AppImage..."
"$APPIMAGE_TOOL" "$APPDIR" "$BUILD/MaxxedSUSE-$VERSION-x86_64.AppImage"
echo "Created $BUILD/MaxxedSUSE-$VERSION-x86_64.AppImage"
