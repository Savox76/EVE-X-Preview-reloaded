## EVE-X-Preview Reloaded 2.0.4

### Changed

- Profile Settings → Custom Colors now shows one scrollable table row per character.
- Every row contains separate fields for the active border, text and inactive border colors.
- Clicking a color field opens the native Windows color palette immediately; the old select-a-row-then-click workflow has been removed.
- Detected EVE characters continue to be added automatically. Characters can also be added or removed manually.
- Existing profiles and color assignments remain compatible.
- An unknown character can no longer inherit the colors of the last configured row.

### Automated verification

- The project contract requires the direct-click color table and its character-based data mapping.
- The old parallel text fields and separate row-color buttons are rejected.
- Existing color picker, localization, profile application, compilation, portable ZIP creation and ZIP content checks remain mandatory.

### Recommended practical check

- Open **Profile Settings → Custom Colors** and confirm that each character occupies exactly one row.
- Click each of the three color fields in a row and confirm that the Windows color palette opens for that exact field.
- Add or remove a character and switch profiles to confirm that rows and colors remain profile-specific.
