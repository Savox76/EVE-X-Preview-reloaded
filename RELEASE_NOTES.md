## EVE-X-Preview Reloaded 2.0.2

### Changed

- Moving or resizing thumbnails now saves their coordinates and dimensions automatically in the active profile.
- EVE client restore rectangles and maximized state are captured automatically without restoring or focusing minimized clients.
- Switching profiles now applies the selected layout, colors, visibility, borders, client behavior and hotkeys immediately.
- Editing any profile setting refreshes the active thumbnails and managed hotkeys without restarting the application.
- Obsolete profile hotkeys are disabled before the current profile mappings are registered.
- The existing **Restore Client Positions** switch continues to control whether captured EVE window positions are restored.

### Automated verification

- The project contract checks automatic position capture, live profile application, managed hotkey replacement and restart-free profile switching.
- AutoHotkey regression tests, compilation, portable ZIP creation and ZIP content verification remain mandatory.

### Recommended practical check

- Move and resize thumbnails, close the application and confirm the layout returns after reopening.
- Move an EVE client, change profiles and confirm each profile restores its own saved layout when **Restore Client Positions** is enabled.
- Change profile colors, borders, visibility and hotkeys while the application remains open and confirm every change takes effect without a restart.
