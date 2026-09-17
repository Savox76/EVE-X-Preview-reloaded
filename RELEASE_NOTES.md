## EVE-X-Preview Reloaded 2.1.0

### New

- Three selectable interfaces: **Classic**, **Modern Dark** and **Modern Light**.
- The modern interfaces provide a wide settings window, permanent profile selection, left-hand navigation and clear saved-state feedback.
- The selected design is stored globally and applied immediately without restarting the complete application.

### Changed

- The configurable minimum thumbnail size has been removed from the interface, defaults and resize logic.
- Existing configuration files automatically discard the obsolete minimum-size entry.
- Thumbnails can be reduced to any positive size that Windows can display.
- All three interfaces share the same settings handlers, live profile application and automatic saving.

### Automated verification

- The project contract checks all three interface choices, persistent immediate switching and complete removal of minimum-size enforcement.
- AutoHotkey regression tests, compilation, portable ZIP creation and ZIP content verification remain mandatory.

### Recommended practical check

- Open **General / Allgemein**, select each of the three designs and confirm the settings window changes immediately.
- Close and reopen the application and confirm the selected design is retained.
- Reduce a thumbnail below the former 50 × 50 pixel limit and confirm the new size is saved.
- Change a profile value in each design and confirm it is applied immediately.
