"""GTK4/libadwaita interface for MaxxedSUSE."""

import gettext
import locale
import os
import threading
from pathlib import Path

import gi

gi.require_version("Gtk", "4.0")
gi.require_version("Gdk", "4.0")
gi.require_version("Adw", "1")
from gi.repository import Adw, Gdk, Gio, GLib, Gtk, Pango  # noqa: E402

from .catalog import load_apps  # noqa: E402
from .engine import (  # noqa: E402
    install,
    is_installed,
    password_required,
    remove_user_launcher,
    run_setup,
    setup_needed,
    user_launcher_installed,
)

if os.environ.get("MXX_LOCALEDIR"):
    LOCALEDIR = Path(os.environ["MXX_LOCALEDIR"])
else:
    LOCALEDIR = Path("/usr/share/locale")
    if not LOCALEDIR.exists():
        LOCALEDIR = Path(__file__).resolve().parent.parent.parent / "po" / "locale"


def setup_translations():
    config = Path(os.environ.get("XDG_CONFIG_HOME", Path.home() / ".config")) / "maxxedsuse" / "locale"
    saved = config.read_text(encoding="utf-8").strip() if config.exists() else ""
    if saved:
        os.environ["LANGUAGE"] = saved
    else:
        locale.setlocale(locale.LC_ALL, "")
    gettext.bindtextdomain("maxxedsuse", str(LOCALEDIR))
    gettext.textdomain("maxxedsuse")
    return gettext.gettext


_ = setup_translations()

SUPPORTED = [
    ("pt_BR", "Português (Brasil)"),
    ("en_US", "English (US)"),
    ("es", "Español"),
    ("it", "Italiano"),
    ("fr", "Français"),
]


def save_locale(code):
    config = Path(os.environ.get("XDG_CONFIG_HOME", Path.home() / ".config")) / "maxxedsuse" / "locale"
    config.parent.mkdir(parents=True, exist_ok=True)
    config.write_text(code + "\n", encoding="utf-8")


def find_icon_path():
    candidates = []
    if os.environ.get("MXX_DATADIR"):
        candidates.append(Path(os.environ["MXX_DATADIR"]) / "data" / "maxxedsuse.svg")
    candidates.extend([
        Path("/usr/share/maxxedsuse/data/maxxedsuse.svg"),
        Path("/usr/share/icons/hicolor/scalable/apps/maxxedsuse.svg"),
        Path(__file__).resolve().parent.parent.parent / "data" / "maxxedsuse.svg",
    ])
    for candidate in candidates:
        if candidate.is_file():
            return candidate
    return None


class MaxxedSUSEApp(Adw.Application):
    def __init__(self):
        super().__init__(application_id="io.github.JonatasGoncalves.MaxxedSUSE",
                         flags=Gio.ApplicationFlags.DEFAULT_FLAGS)
        self.apps = load_apps()
        self.rows = {}
        self.current_ids = []
        self.current_search = None
        self.current_listbox = None

    def do_activate(self):
        self.window = Adw.ApplicationWindow(application=self, title="MaxxedSUSE")
        self.window.set_default_size(900, 720)
        self.view = Adw.NavigationView()
        self.window.set_content(self.view)
        self.welcome_page = self.build_welcome()
        self.view.push(self.welcome_page)
        self.window.present()

    # ------------------------------------------------------------------
    # Welcome page
    # ------------------------------------------------------------------
    def build_welcome(self):
        page = Adw.NavigationPage(title=_("Welcome"))
        toolbar = Adw.ToolbarView()
        header = Adw.HeaderBar()
        toolbar.add_top_bar(header)

        status = Adw.StatusPage()
        status.set_title(_("MaxxedSUSE"))
        status.set_description(_("Setup utility for openSUSE Tumbleweed"))

        icon_path = find_icon_path()
        if icon_path:
            try:
                status.set_paintable(Gdk.Texture.new_from_file(Gio.File.new_for_path(str(icon_path))))
            except GLib.Error:
                status.set_icon_name("maxxedsuse")
        else:
            status.set_icon_name("maxxedsuse")

        content = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=12)
        content.set_halign(Gtk.Align.CENTER)
        content.set_size_request(380, -1)
        content.set_margin_top(36)
        content.set_margin_bottom(24)

        current = os.environ.get("LANGUAGE", os.environ.get("LANG", "en_US")).split(".")[0]
        codes = [code for code, _ in SUPPORTED]
        names = [name for _, name in SUPPORTED]
        selected = codes.index(current) if current in codes else 1

        combo = Adw.ComboRow(title=_("Language"), subtitle=_("Select the interface language"))
        model = Gtk.StringList()
        for name in names:
            model.append(name)
        combo.set_model(model)
        combo.set_selected(selected)
        combo.connect("notify::selected", lambda w, _p: self.on_language_changed(codes[w.get_selected()]))

        lang_group = Adw.PreferencesGroup()
        lang_group.add(combo)
        content.append(lang_group)

        if setup_needed():
            setup_btn = Gtk.Button(label=_("Run initial setup"), halign=Gtk.Align.CENTER)
            setup_btn.set_margin_top(32)
            setup_btn.connect("clicked", lambda _b: self.run_initial_setup(setup_btn))
            content.append(setup_btn)

        start = Gtk.Button(label=_("Start"), halign=Gtk.Align.CENTER)
        start.add_css_class("suggested-action")
        start.set_margin_top(16)
        start.connect("clicked", lambda _b: self.view.push(self.build_categories()))
        content.append(start)

        if user_launcher_installed():
            remove_launcher = Gtk.Button(label=_("Remove desktop shortcut"), halign=Gtk.Align.CENTER)
            remove_launcher.set_margin_top(8)
            remove_launcher.connect("clicked", lambda _b: self.on_remove_launcher(_b))
            content.append(remove_launcher)

        status.set_child(content)
        toolbar.set_content(status)
        page.set_child(toolbar)
        return page

    def on_language_changed(self, code):
        save_locale(code)
        os.environ["LANGUAGE"] = code
        gettext.bindtextdomain("maxxedsuse", str(LOCALEDIR))
        gettext.textdomain("maxxedsuse")
        self.window.set_title(_("MaxxedSUSE"))
        if self.view.get_visible_page() == self.welcome_page:
            self.welcome_page = self.build_welcome()
            self.view.replace([self.welcome_page])

    def ask_password(self, callback):
        dialog = Gtk.Dialog(
            transient_for=self.window,
            title=_("Administrator password"),
            modal=True,
        )
        dialog.set_default_size(380, -1)
        content = dialog.get_content_area()
        content.set_spacing(8)
        content.set_margin_top(12)
        content.set_margin_bottom(12)
        content.set_margin_start(12)
        content.set_margin_end(12)
        content.append(Gtk.Label(label=_("Enter your password to continue."), wrap=True))
        entry = Gtk.PasswordEntry(show_peek_icon=True)
        content.append(entry)
        dialog.add_button(_("Cancel"), Gtk.ResponseType.CANCEL)
        dialog.add_button(_("Unlock"), Gtk.ResponseType.OK)
        dialog.set_default_response(Gtk.ResponseType.OK)

        def on_response(current, response):
            self._password_dialog = None
            password = entry.get_text() if response == Gtk.ResponseType.OK else None
            current.destroy()
            if password is not None:
                callback(password)

        dialog.connect("response", on_response)
        self._password_dialog = dialog
        dialog.present()
        entry.grab_focus()

    def run_initial_setup(self, button):
        if password_required():
            self.ask_password(lambda password: self.start_initial_setup(button, password))
        else:
            self.start_initial_setup(button, None)

    def start_initial_setup(self, button, password):
        button.set_sensitive(False)
        _dialog, buffer = self.output_dialog(_("Initial setup"))

        def append(text):
            buffer.insert(buffer.get_end_iter(), text)

        def worker():
            process = run_setup(password)
            if not process:
                GLib.idle_add(append, _("Could not start the setup."))
                return
            for line in process.stdout:
                GLib.idle_add(append, line)
            code = process.wait()
            message = _("Setup finished.") if code == 0 else _("Setup failed.")
            GLib.idle_add(append, f"\n{message}\n")
            GLib.idle_add(button.set_sensitive, True)

        threading.Thread(target=worker, daemon=True).start()

    # ------------------------------------------------------------------
    # Category overview
    # ------------------------------------------------------------------
    def build_categories(self):
        page = Adw.NavigationPage(title=_("Categories"))
        toolbar = Adw.ToolbarView()
        header = Adw.HeaderBar()
        toolbar.add_top_bar(header)
        prefs = Adw.PreferencesPage()
        group = Adw.PreferencesGroup(title=_("Categories"),
                                     description=_("Choose a section to browse"))

        seen = []
        for app in self.apps:
            if app["category"] not in seen:
                seen.append(app["category"])

        for category in seen:
            name = next(_(a["category_name"]) for a in self.apps if a["category"] == category)
            count = sum(1 for a in self.apps if a["category"] == category)
            row = Adw.ActionRow(title=name, subtitle=f"{count} " + _("applications"))
            image = Gtk.Image(icon_name="go-next-symbolic")
            image.add_css_class("dim-label")
            row.add_suffix(image)
            row.set_activatable(True)
            row.connect("activated", lambda _r, c=category, n=name: self.view.push(self.build_category(c, n)))
            group.add(row)

        prefs.add(group)
        toolbar.set_content(prefs)
        page.set_child(toolbar)
        return page

    # ------------------------------------------------------------------
    # Category page
    # ------------------------------------------------------------------
    def build_category(self, category, name):
        page = Adw.NavigationPage(title=name)
        toolbar = Adw.ToolbarView()
        header = Adw.HeaderBar()
        toolbar.add_top_bar(header)

        search = Gtk.SearchEntry(placeholder_text=_("Search applications"))
        search.connect("search-changed", lambda _e: self.apply_filter())
        header.set_title_widget(search)
        self.current_search = search

        refresh = Gtk.Button(icon_name="view-refresh-symbolic", tooltip_text=_("Refresh status"))
        refresh.connect("clicked", lambda _b: self.refresh_status())
        header.pack_end(refresh)

        install_btn = Gtk.Button(label=_("Install selected"))
        install_btn.add_css_class("suggested-action")
        install_btn.connect("clicked", lambda _b: self.install_selected())
        header.pack_end(install_btn)

        listbox = Gtk.ListBox(selection_mode=Gtk.SelectionMode.NONE)
        listbox.add_css_class("boxed-list")
        self.current_listbox = listbox
        self.current_ids = []

        for app in self.apps:
            if app["category"] != category:
                continue

            row = Gtk.ListBoxRow()
            inner = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=12)
            inner.set_margin_top(8)
            inner.set_margin_bottom(8)
            inner.set_margin_start(8)
            inner.set_margin_end(8)

            check = Gtk.CheckButton()
            inner.append(check)

            labels = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=2)
            label = Gtk.Label(label=_(app["name"]), xalign=0, ellipsize=Pango.EllipsizeMode.END)
            label.add_css_class("title-4")
            labels.append(label)
            desc = Gtk.Label(label=_(app["description"]), xalign=0, ellipsize=Pango.EllipsizeMode.END)
            desc.add_css_class("dim-label")
            labels.append(desc)
            inner.append(labels)

            status = Gtk.Image(icon_name="question-circle-symbolic")
            status.set_tooltip_text(_("Checking..."))
            inner.append(status)

            row.set_child(inner)
            listbox.append(row)
            self.rows[app["id"]] = (row, check, status)
            self.current_ids.append(app["id"])

        scroll = Gtk.ScrolledWindow(hexpand=True, vexpand=True)
        scroll.set_child(listbox)
        toolbar.set_content(scroll)
        page.set_child(toolbar)
        self.refresh_status()
        return page

    def apply_filter(self):
        if not self.current_search or not self.current_listbox:
            return
        text = self.current_search.get_text().casefold()
        for app_id in self.current_ids:
            row = self.rows[app_id][0]
            app = next(a for a in self.apps if a["id"] == app_id)
            name = _(app["name"]).casefold()
            description = _(app["description"]).casefold()
            visible = not text or text in name or text in description
            row.set_visible(visible)

    # ------------------------------------------------------------------
    # Status and installation
    # ------------------------------------------------------------------
    def refresh_status(self):
        def worker():
            for app in self.apps:
                result = is_installed(app)
                GLib.idle_add(self.set_status, app["id"], result)
        threading.Thread(target=worker, daemon=True).start()

    def set_status(self, app_id, result):
        if app_id not in self.rows:
            return GLib.SOURCE_REMOVE
        _row, _check, image = self.rows[app_id]
        if result is True:
            image.set_from_icon_name("emblem-ok-symbolic")
            image.set_tooltip_text(_("Installed"))
        elif result is False:
            image.set_from_icon_name("dialog-warning-symbolic")
            image.set_tooltip_text(_("Not installed"))
        else:
            image.set_from_icon_name("question-circle-symbolic")
            image.set_tooltip_text(_("Status unavailable"))
        return GLib.SOURCE_REMOVE

    def install_selected(self):
        ids = [app_id for app_id in self.current_ids
               if self.rows[app_id][1].get_active()]
        if not ids:
            self.show_message(_("No applications selected"))
            return

        if password_required():
            self.ask_password(lambda password: self.start_install(ids, password))
        else:
            self.start_install(ids, None)

    def start_install(self, ids, password):
        _dialog, buffer = self.output_dialog(_("Installing applications"))

        def append(text):
            buffer.insert(buffer.get_end_iter(), text)

        def worker():
            process = install(ids, password)
            if not process:
                GLib.idle_add(append, _("Could not start the installer."))
                return
            for line in process.stdout:
                GLib.idle_add(append, line)
            process.wait()
            GLib.idle_add(append, _("\nInstallation finished.\n"))
            GLib.idle_add(self.refresh_status)

        threading.Thread(target=worker, daemon=True).start()

    def output_dialog(self, title):
        dialog = Gtk.Dialog(transient_for=self.window, title=title, modal=True)
        dialog.set_default_size(640, 480)
        view = Gtk.TextView(editable=False, monospace=True)
        view.set_wrap_mode(Gtk.WrapMode.WORD)
        scroll = Gtk.ScrolledWindow(child=view, hexpand=True, vexpand=True)
        content = dialog.get_content_area()
        content.set_spacing(8)
        content.set_margin_top(12)
        content.set_margin_bottom(12)
        content.set_margin_start(12)
        content.set_margin_end(12)
        content.append(scroll)
        dialog.add_button(_("Close"), Gtk.ResponseType.CLOSE)

        def scroll_to_end(_buffer):
            end = buffer.get_end_iter()
            buffer.place_cursor(end)
            view.scroll_to_iter(end, 0.0, False, 0.0, 0.0)

        buffer = view.get_buffer()
        scroll_handler = buffer.connect("changed", scroll_to_end)
        dialog.connect("destroy", lambda _w: buffer.disconnect(scroll_handler))
        dialog.present()
        return dialog, buffer

    def show_message(self, text):
        dialog = Adw.MessageDialog(transient_for=self.window, heading=text)
        dialog.add_response("ok", _("OK"))
        dialog.present()

    def on_remove_launcher(self, button):
        if remove_user_launcher():
            button.set_visible(False)
            self.show_message(_("Desktop shortcut removed."))
        else:
            self.show_message(_("Could not remove the desktop shortcut."))


def main():
    app = MaxxedSUSEApp()
    return app.run()
