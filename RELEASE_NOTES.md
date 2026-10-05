## EVE-X-Preview Reloaded 2.0.10

### Fixed

- Automatic Default cycle groups now use a stable alphabetical character order in every profile.
- Existing profiles are normalized automatically, removing differences caused by the Windows window/Z-order at profile creation time.
- User-created cycle groups keep their manually configured character order unchanged.

### Automated verification

- The group-cycle regression test now checks stable ordering, duplicate removal and EVE window-title normalization.
- The project contract requires automatic profile groups to be normalized without touching custom groups.
- Existing direction, hotkey-capture, gameplay-input, localization, compilation and portable ZIP checks remain mandatory.

### Recommended practical check

- Switch between two profiles that contain the same running characters.
- Starting from the same character, press the forward hotkey once in each profile and confirm that both select the same next character.
- Confirm that any manually created group still follows its own listed order.
