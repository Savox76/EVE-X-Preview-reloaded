## EVE-X-Preview Reloaded 1.1.0-preview.4

Live thumbnail-size correction.

### Fixed

- Changes to the configured thumbnail width and height are now visible immediately without restarting the application.
- The live resize keeps every thumbnail at its current screen position and updates the DWM preview, text overlay, and border together.
- The changed dimensions are stored with the active profile so they remain in effect after the next start.

### Behaviour

- Width and height changes are debounced briefly while typing to avoid visible redraws for every individual keystroke.
- Values smaller than the configured minimum thumbnail size are raised to that minimum.
- The position-and-size lock still prevents accidental mouse resizing; an explicit size change in settings remains effective.

### Test focus

- Keep one or more EVE clients open and change the default thumbnail width or height under Global Settings.
- Confirm all visible thumbnails resize without closing the settings window or restarting the application.
- Confirm their screen positions do not change and that preview content, text overlay, and borders remain aligned.
- Restart the portable application and confirm the new dimensions remain active.
