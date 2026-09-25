## EVE-X-Preview Reloaded 2.0.9

### Fixed

- Corrected the swapped cycle directions: the forward hotkey now follows the intended forward path and the backward hotkey follows the opposite path.
- Existing forward and backward assignments remain in their fields; users do not need to exchange their configured keys.
- Skipping unavailable clients and wrap-around behavior continue to work in both directions.

### Automated verification

- The group-cycle regression test now checks the UI-facing meaning of Forward and Backward, including wrap-around and unavailable clients.
- The project contract locks the direction mapping so it cannot silently be reversed again.
- Existing hotkey-capture, gameplay-input, localization, compilation and portable ZIP checks remain mandatory.

### Recommended practical check

- Open **Profile Settings → Cycle groups** and keep the existing forward and backward assignments unchanged.
- Starting from the same character, press each hotkey once and confirm that they now move in opposite, correctly labelled directions.
- Confirm that a closed client is still skipped in either direction.
