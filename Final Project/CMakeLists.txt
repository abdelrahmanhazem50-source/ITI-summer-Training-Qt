# Changelog

## Version 1.5 — Stability Fix

### Bluetooth

- Removed synchronous `bluetoothctl` command execution from the Qt GUI process.
- Removed `enableBluetoothReceiver()` from C++, QML, and documentation.
- **Pair Phone** now opens the system Bluetooth manager using `QProcess::startDetached()`.
- **Bluetooth Devices** uses the same safe system-manager path.
- Phone-to-IVI Bluetooth direction is unchanged; Linux handles pairing and incoming audio routing.

### Live Radio

- Replaced legacy default HTTP stream URLs with HTTPS streams published by the MP3Quran radio API.
- Added URL validation for built-in/custom stations.
- Stop and clear the previous source before changing a live stream.
- Queue live-source startup with `QTimer::singleShot(0, ...)` to avoid re-entrant source changes.
- Excluded radio mode from local-file `EndOfMedia` auto-next behavior.
- Kept normal Qt error reporting so an unavailable stream shows an error instead of destabilizing the app.

### Documentation

- Updated README.
- Rewritten step-by-step explanation to match the final code.
- Updated internal test report.
- Regenerated FULL_CODE.txt.
