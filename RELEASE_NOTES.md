## EVE-X-Preview Reloaded 2.0.6

### Changed

- Every profile now receives an automatically maintained **Default** cycle group.
- Detected characters are appended to Default automatically, including characters already known by existing profiles.
- Only currently running clients are considered while cycling; unavailable characters continue to be skipped safely.
- The Default character list is read-only and the group cannot be deleted accidentally.
- Forward and backward hotkeys remain intentionally empty so existing assignments cannot conflict.
- Additional manually maintained groups and all existing profile settings remain unchanged.

### Automated verification

- The project contract requires the Default group schema without placeholder characters.
- Existing profiles, new profiles and live client discovery are all checked for Default-group integration.
- Existing group-cycle regression tests, the gameplay-input guard, localization checks, compilation and portable ZIP verification remain mandatory.

### Recommended practical check

- Open **Profile Settings → Cycle groups** and confirm that Default is selected and contains the detected characters.
- Set a forward and/or backward hotkey, then confirm that it cycles through running clients and skips closed ones.
- Create a manual group and confirm that its list remains freely editable and independent from Default.
