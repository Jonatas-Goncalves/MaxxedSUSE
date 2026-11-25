Name:           maxxedsuse
Version:        4.0
Release:        1
Summary:        Setup utility for openSUSE Tumbleweed
License:        GPL-3.0-or-later
URL:            https://github.com/Jonatas-Goncalves/MaxxedSUSE
Source0:        %{name}-%{version}.tar.gz

BuildArch:      noarch
BuildRequires:  gettext
Requires:       python3
Requires:       python3-gobject
Requires:       gtk4
Requires:       libadwaita
Requires:       typelib-1_0-Gtk-4_0
Requires:       typelib-1_0-Adw-1
Requires:       flatpak
Requires:       polkit
Requires:       zypper
Recommends:     zenity
Recommends:     snapper

%description
MaxxedSUSE helps users configure a fresh openSUSE Tumbleweed installation
and install common applications, games and tools through a graphical interface.

%prep
%setup -q

%build
bash po/build.sh

%install
install -Dm644 data/%{name}.desktop %{buildroot}%{_datadir}/applications/%{name}.desktop
install -Dm644 data/%{name}.svg %{buildroot}%{_datadir}/icons/hicolor/scalable/apps/%{name}.svg
install -Dm644 data/io.github.JonatasGoncalves.MaxxedSUSE.policy \
    %{buildroot}%{_datadir}/polkit-1/actions/io.github.JonatasGoncalves.MaxxedSUSE.policy

install -dm0755 %{buildroot}%{_datadir}/%{name}
cp -r catalog %{buildroot}%{_datadir}/%{name}/
install -Dm644 src/maxxedsuseapp.py %{buildroot}%{_bindir}/%{name}
install -Dm755 src/maxxedsuse-helper.py %{buildroot}%{_libexecdir}/%{name}/%{name}-helper

cp -r src/maxxedsuse %{buildroot}%{python3_sitelib}/maxxedsuse
for lang in pt_BR en_US es it fr; do
    install -Dm644 po/locale/$lang/LC_MESSAGES/%{name}.mo \
        %{buildroot}%{_datadir}/locale/$lang/LC_MESSAGES/%{name}.mo
done

%files
%license LICENSE
%doc README.md PackageList.md
%{_bindir}/%{name}
%{_libexecdir}/%{name}/%{name}-helper
%{_datadir}/%{name}/
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/scalable/apps/%{name}.svg
%{_datadir}/polkit-1/actions/io.github.JonatasGoncalves.MaxxedSUSE.policy
%{python3_sitelib}/maxxedsuse/
%lang(pt_BR) %{_datadir}/locale/pt_BR/LC_MESSAGES/%{name}.mo
%lang(en_US) %{_datadir}/locale/en_US/LC_MESSAGES/%{name}.mo
%lang(es) %{_datadir}/locale/es/LC_MESSAGES/%{name}.mo
%lang(it) %{_datadir}/locale/it/LC_MESSAGES/%{name}.mo
%lang(fr) %{_datadir}/locale/fr/LC_MESSAGES/%{name}.mo

%changelog
