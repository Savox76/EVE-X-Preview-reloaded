## EVE-X-Preview Reloaded 2.0.3

### Changed

- The configurable minimum thumbnail size has been removed completely.
- Thumbnails can now be resized freely down to the smallest positive size Windows supports.
- The separate default thumbnail width and height remain available and continue to update visible thumbnails immediately.
- Existing `EVE-X-Preview.json` files are cleaned automatically; the obsolete `ThumbnailMinimumSize` entry is removed without affecting profiles, positions, colors or hotkeys.

### Automated verification

- The project contract rejects any active minimum-size setting or scaling clamp.
- The resize path remains protected against invalid zero or negative Windows dimensions.
- AutoHotkey regression tests, compilation, portable ZIP creation and ZIP content verification remain mandatory.

### Recommended practical check

- Open **Global Settings** and confirm the minimum-size fields are gone in both German and English.
- Resize one or all thumbnails below the former 50 × 50 pixel limit and confirm they remain usable and keep their new dimensions after restarting.
- Change the default thumbnail width and height to small positive values and confirm visible thumbnails update without restarting.
