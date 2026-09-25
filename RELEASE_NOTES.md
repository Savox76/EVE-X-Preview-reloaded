## EVE-X-Preview Reloaded 2.0.8

### Fixed

- Clearing an existing hotkey no longer tries to register incomplete intermediate text and no longer shows a false invalid-hotkey message.
- Function keys such as `F1` through `F24` are captured by their actual key names.
- Ctrl, Alt, Shift and Windows-key combinations are captured atomically and normalized to valid AutoHotkey syntax.
- Cycle-group hotkeys now have an explicit **Clear** action.
- Character hotkeys can be captured or cleared for the currently selected hotkey row.
- The global suspend-hotkey field now uses the same capture and clear behavior.
- Manual advanced syntax remains possible and is applied only after leaving the field.

### Automated verification

- Windows CI distinguishes the number row from Numpad keys and now also exercises function keys and modifier combinations.
- The project contract prevents hotkey fields from registering partial text on every keystroke.
- Existing group-cycle, gameplay-input, localization, compilation and portable ZIP checks remain mandatory.

### Recommended practical check

- Capture `F1` as a forward or character hotkey and verify that the field displays `F1`.
- Capture a combination such as Ctrl+Alt+F12 and verify that it switches only when the complete combination is pressed.
- Use **Clear** and verify that the field becomes empty without an error message.
