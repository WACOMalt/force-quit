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

- `logo/logo.svg`: the source file
- `logo/logo.png`: the 512x512 render for the store logo field

Render a new PNG after a change to the SVG:

```
rsvg-convert -w 512 -h 512 logo/logo.svg -o logo/logo.png
```

The logo is derived from the Breeze `process-stop` icon, which is the icon the
applet shows in the panel. Breeze is licensed LGPL-3.0-or-later AND
CC-BY-SA-4.0. Keep the attribution comment at the top of `logo/logo.svg`. If
you do not want to carry that licence on the store listing, replace the logo
with an original drawing.

## Screenshots

- `screenshots/screenshot-panel.png`: the icon in the panel — **done**
- `screenshots/screenshot-cursor.png`: the changed cursor over a target window
  — **still to make**

Blur everything except the widget. This draws attention to the Force Quit icon
and hides the applications and the window titles of the person who makes the
screenshot.

### How the panel screenshot was made

The style matches the bs-updater screenshots: a strip of the panel, blurred,
with the widget left sharp.

1. Capture the desktop:

   ```
   spectacle -b -n -f -o full.png
   ```

2. Find the widget. The icon is the only Breeze red (`#da4453`) in the panel,
   so it can be located without measuring by hand:

   ```
   magick full.png -crop 120x50+1780+1150 +repage -fuzz 10% \
     +transparent "#da4453" -trim -format "%wx%h at +%X+%Y\n" info:
   ```

3. Crop a 354x40 strip of the panel and scale it 7 times, which gives the
   2478x280 size the bs-updater screenshots use:

   ```
   magick full.png -crop 354x40+1566+1160 +repage -filter Lanczos -resize 700% big.png
   ```

4. Make a mask that is black everywhere and white over the widget. The mask
   must have no alpha channel, or the composite step reads the alpha channel
   instead of the grey values and nothing is blurred:

   ```
   magick -size 2478x280 xc:black -fill white \
     -draw "roundrectangle 1911,21 2149,259 28,28" \
     -alpha off -colorspace Gray -blur 0x6 mask.png
   ```

5. Blur the strip, then put the sharp widget back through the mask:

   ```
   magick big.png -blur 0x22 blurred.png
   magick blurred.png big.png mask.png -composite screenshots/screenshot-panel.png
   ```

The crop offsets are for a 1920x1200 screen with the panel at the bottom. Find
the offsets again with step 2 after a panel change.

### How to make the cursor screenshot

This shot needs a hand on the mouse, because the cursor cannot be moved from a
script on Wayland, and because the kill cursor cannot be cancelled from a
script.

1. Open a window you do not mind losing. This is the target to point at.
2. Start a capture with a delay, which includes the pointer:

   ```
   spectacle -b -n -p -f -d 10000 -o /tmp/fq-cursor.png
   ```

3. Click the Force Quit widget. The cursor changes shape.
4. Hold the cursor over the target window until the shutter fires.
5. **Press Escape.** This cancels the kill cursor. Until you do, the next
   click kills whatever window it lands on.
6. Blur the result the same way as steps 3 to 5 above, with the mask over the
   cursor instead of the widget.

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

3. **Make the screenshots.** This is the only item left before the first
   upload. See the Screenshots section above. The logo is done.

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
