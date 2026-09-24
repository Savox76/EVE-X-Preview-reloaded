## EVE-X-Preview Reloaded 2.0.7

### Fixed

- Cycle-group hotkeys can now be captured from the keyboard instead of relying on ambiguous text entry.
- Numpad keys are stored with their distinct AutoHotkey names, for example `Numpad3` instead of `3`.
- Modifier combinations are captured together with the pressed key; `Esc` cancels capture.
- Existing manual entry remains available for mouse hotkeys and advanced AutoHotkey syntax.

### Automated verification

- The project contract checks the keyboard-capture helper, both cycle-group capture buttons and the translated capture instructions.
- Existing group-cycle regression tests, the gameplay-input guard, localization checks, compilation and portable ZIP verification remain mandatory.

### Recommended practical check

- Open **Profile Settings → Cycle groups** and select **Default**.
- Click **Capture…** beside the forward field, press Numpad 3 and confirm that `Numpad3` is displayed.
- Capture Numpad 1 for backward and confirm that both keys cycle in the expected direction.
