## EVE-X-Preview Reloaded 2.0.5

### Changed

- **Hotkeys** is now named **Character hotkeys** and explains that each entry activates one specific character directly.
- **Hotkey groups** is now named **Cycle groups** and explains that groups are optional lists for forward/backward character switching.
- The cycle-group character list now has its own descriptive label.
- Both explanations are available in German and English.
- Existing hotkeys, groups, profiles and switching behavior remain unchanged.
- Character switching deliberately continues to activate windows only; it does not generate automated gameplay input.

### Automated verification

- The project contract requires the explanatory text for both hotkey sections.
- A regression guard rejects automatic `Send` or `ControlSend` gameplay input in the EVE switching paths.
- Existing group-cycle regression tests, localization checks, compilation, portable ZIP creation and ZIP content checks remain mandatory.

### Recommended practical check

- Open **Profile Settings → Character hotkeys** and confirm that the direct-switch explanation is fully visible.
- Open **Profile Settings → Cycle groups** and confirm that the optional group purpose and character order are clear.
- Switch directly to one character and cycle through a group to confirm that existing assignments still work unchanged.
