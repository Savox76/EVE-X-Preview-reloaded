## EVE-X-Preview Reloaded 2.0.1

### Fixed

- The controls in **Profile Settings → Thumbnail Settings** now use a fixed two-column grid.
- Checkboxes, text fields and numeric inputs begin at the same horizontal position.
- `px` and `%` units follow their value fields instead of shifting those fields sideways.
- Every label and its control now share an explicit row position, preventing gradual vertical drift.

### Automated verification

- The project contract now guards the fixed thumbnail-settings grid against accidental reintroduction of relative control positioning.
- AutoHotkey regression tests, compilation, portable ZIP creation and ZIP content verification remain mandatory.

### Recommended practical check

- Open **Profile Settings → Thumbnail Settings** in German and English.
- Confirm that all primary controls form one straight right-hand column and that each control lines up with its label.
