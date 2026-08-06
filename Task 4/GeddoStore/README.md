# Geddo Store - Modern Qt Quick App

This project is a complete modern redesign of the original online-store QML app.

## Included features

- Responsive product grid that adapts from three columns to two or one.
- Smooth hover, press, image zoom, popup, splash-screen, and background animations.
- English and Arabic language switching at runtime.
- Proper Arabic right-to-left layout mirroring.
- Qt `qsTr()` translation strings with a real `QTranslator` manager.
- Online Unsplash product images, so no local image files are required.
- Scrollable layout for smaller windows.

## Project files

- `Main.qml`: complete user interface and animations.
- `main.cpp`: language manager and application startup.
- `translations/store_ar.ts`: Arabic translations.
- `CMakeLists.txt`: Qt 6 project configuration.

## Run in Qt Creator

1. Open Qt Creator.
2. Select **File > Open File or Project**.
3. Open `CMakeLists.txt`.
4. Select your Qt 6.5 or newer Desktop kit.
5. Configure the project.
6. Build and run.

The project is compatible with Qt 6.11.

## Important

The product pictures come from the internet. An internet connection is needed for them to appear.
