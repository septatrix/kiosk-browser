# kiosk-browser

A fullscreen kiosk browser for touch devices
with an embedded on-screen keyboard.

It is built on Qt WebEngine (Chromium) and the Qt Virtual Keyboard.
The keyboard is drawn inside the application window,
so it works on X11 and Wayland alike
without any help from the compositor.

## Usage

```
kiosk-browser [--windowed] url
```

- The keyboard layout follows the locale of the process (`LANG`).
- Chromium flags can be passed in the `QTWEBENGINE_CHROMIUM_FLAGS` environment variable.
- The page is reloaded if the render process dies.

## Building

Requires Qt 6.4 or newer with the Quick, WebEngine and Virtual Keyboard modules
(on Debian: `qt6-declarative-dev qt6-virtualkeyboard-dev qt6-webengine-dev`).

```bash
cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release
cmake --build build
./build/kiosk-browser --windowed https://example.com
```

Releases contain `.deb` and `.rpm` packages
named `kiosk-browser-<distro>-<arch>.<ext>`.
