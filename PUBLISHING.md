# KDE Store publishing information

Use this file to keep the KDE Store listing consistent between releases.

## Product

- **Store page**: store.kde.org (log in with the OpenDesktop account)
- **Product name**: Force Quit
- **Plugin Id**: `bsums.xyz.forcequit`
- **Category**: Plasma → Plasma 6 Applets
- **License**: GPL-2.0-or-later
- **Homepage / Source**: https://github.com/WACOMalt/force-quit

## Description

Copy this text into the store description field:

> Force Quit kills an unresponsive window with two clicks.
>
> Click the icon in the panel. The cursor changes shape. Click the window you
> want to close. The window is killed immediately.
>
> The widget calls KWin directly to kill the window. It does not use xkill, so
> it works on Wayland windows and on X11 windows. It needs no extra package.
>
> This widget is a port of the Cinnamon "Force Quit" applet to Plasma 6.
>
> Warning: a killed program does not save its work.
>
> Source: https://github.com/WACOMalt/force-quit

## Logo

The widget uses the `process-stop` icon from the active icon theme, so there is
no logo file in this repository yet. The store listing needs its own logo image.

Make a 512x512 PNG before the first upload. Put the source SVG in `logo/logo.svg`
and render it with:

```
rsvg-convert -w 512 -h 512 logo/logo.svg -o logo/logo.png
```

`rsvg-convert` is not installed on this machine. Install it with:

```
sudo dnf install librsvg2-tools
```

## Screenshots

The store listing needs at least one screenshot. Take these two:

- `screenshots/screenshot-panel.png`: the icon in the panel
- `screenshots/screenshot-cursor.png`: the changed cursor over a target window

Blur the other panel icons and any window titles. This draws attention to the
Force Quit icon and hides the applications of the person who makes the
screenshot. Make new screenshots when the icon or the panel changes, and blur
them the same way.

## Before the first upload

Do these three things one time.

1. **The licence is set.** `metadata.json` declares `GPL-2.0-or-later`, because
   the Cinnamon applet this is based on is GPL. bs-updater uses The Unlicense;
   the two do not have to match. `LICENSE` holds the full GPL-2.0 text and
   `main.qml` carries the matching SPDX header.

2. **Do not change the plugin Id.** The Id is `bsums.xyz.forcequit`. It follows
   the same reverse-domain form as `bsums.xyz.bs-updater`. The store and
   Discover use the Id to match an update to an installed widget, so the Id
   cannot change after the first upload without making a new product.

3. **Make the logo and the screenshots.** These are the only items left before
   the first upload. See the two sections above.

## How to publish an update

1. Increase `Version` in `package/metadata.json`.
2. Build the package:

   ```
   ./make-plasmoid.sh
   ```

3. Open the product page on store.kde.org and go to the Files section.
4. Upload `dist/force-quit-<version>.plasmoid`.
5. Update the description text if the behavior changed. Keep this file and the
   store text identical.
6. Commit and push the version change.

Users receive the update through Discover and the Plasma widget browser.

## How to test the package before upload

Install the built archive into a temporary location. This checks the archive
layout without touching the installed widget:

```
kpackagetool6 --type Plasma/Applet --install dist/force-quit-<version>.plasmoid \
  --packageroot /tmp/plasmoid-test
```

The store expects `metadata.json` at the root of the archive. `make-plasmoid.sh`
builds it that way.
