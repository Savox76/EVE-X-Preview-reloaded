## EVE-X-Preview Reloaded 1.1.0-preview.2

Second Reloaded preview package.

### New

- Native Windows color palette for global, thumbnail, and per-character colors.
- Detected EVE character names are automatically added to the active profile's hotkey and custom-color lists.
- The selected palette color is written back as a hexadecimal value.
- A prioritized backlog derived from the original repository's issue tracker.

### Fixed

- Removed all `Example Name` and `Example Char` placeholders from new and existing settings files.
- Character names beginning with `Eve`, such as `Eve Valkyrie`, are no longer damaged when window titles are cleaned more than once.

### Compatibility

- Existing profiles, hotkeys, colors, and saved positions are preserved.
- Placeholder cleanup only removes the known default example values.
- The "do not minimize" list remains opt-in and is not populated automatically.

### Test focus

- Open the color palette for every color field and confirm the chosen hexadecimal value is saved.
- In per-character colors, place the caret in a row before selecting its row color.
- Start EVE clients and confirm their real character names appear in Hotkeys and Custom Colors after reopening Settings.
- Confirm names beginning with `Eve` remain complete in hotkey groups.
