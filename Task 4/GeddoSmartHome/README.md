# Nexa Home — Modern Qt Quick Smart Home Dashboard

A redesigned version of the original smart-home assignment with a responsive interface, smooth animations, reusable controls, dark mode, and real English/Arabic internationalization.

## Included features

- Animated splash screen
- Modern login page with validation and loading feedback
- Responsive dashboard for desktop and smaller windows
- Animated device cards and custom switches
- Live device and energy summary values
- Rotating fan animation while the fan is active
- Settings page with brightness, temperature, notifications and energy saver controls
- Light and dark appearance
- English and Arabic language switching while the program is running
- Correct right-to-left layout in Arabic
- Qt `qsTr()`, `QTranslator`, `.ts` and generated `.qm` files
- Smooth StackView page transitions
- Online Icons8 graphics, so no local image folder is required

## Open and run in Qt Creator

1. Extract the ZIP file.
2. Open `CMakeLists.txt` in Qt Creator.
3. Select a Qt 6.5 or newer Desktop kit. Qt 6.11 works.
4. Press **Configure Project**.
5. Build and run.

The Arabic `.qm` translation is generated automatically by CMake from:

```text
translations/smarthome_ar.ts
```

## Login

This demonstration accepts any non-empty username and password. It does not connect to a real authentication server.

## Important note

The interface is mainly kept inside `Main.qml` to make the assignment easy to inspect and explain. `main.cpp` is required because proper runtime Qt internationalization uses `QTranslator` and `engine.retranslate()`.
