# Force Quit — KDE Plasma 6 applet

A port of the Cinnamon [Force Quit](https://cinnamon-spices.linuxmint.com/applets/view/4)
spice (`force-quit@cinnamon.org`) to a Plasma 6 panel applet.

Click the panel icon, then click any window — it is killed immediately.

## Why not `xkill`?

The Cinnamon original shells out to `xkill`, an X11 utility. Under a Wayland
session `xkill` can only reach XWayland clients, so it silently fails on
Wayland-native windows (and it isn't installed by default on Fedora/Nobara).

This applet instead calls KWin's own `org.kde.KWin.killWindow()` over D-Bus.
That's the same code path as the built-in **Ctrl+Alt+Esc** shortcut, and it
works for both Wayland and X11 windows.

## Install

```
kpackagetool6 --type Plasma/Applet --install package
```

To update after editing, use `--upgrade` instead of `--install`; to remove:

```
kpackagetool6 --type Plasma/Applet --remove bsums.xyz.forcequit
```

Then right-click the panel → *Add or Manage Widgets…* → search "Force Quit"
→ drag it onto the panel.

## Layout

- `package/metadata.json` — applet id, name, icon, Plasma API version
- `package/contents/ui/main.qml` — the whole applet
- `make-plasmoid.sh` — builds `dist/force-quit-<version>.plasmoid` for the KDE Store
- `PUBLISHING.md` — KDE Store listing text and release steps

## Publishing

See [PUBLISHING.md](PUBLISHING.md). Build the store package with:

```
./make-plasmoid.sh
```

## Notes

- No dependency beyond `qdbus` (Plasma already pulls it in); the applet probes
  for `qdbus6` / `qdbus-qt6` / `qdbus` so it works across distro naming.
- Tested on Plasma 6.7.4, Wayland, Nobara/Fedora 44.
