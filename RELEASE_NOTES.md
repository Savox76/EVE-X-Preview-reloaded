## EVE-X-Preview Reloaded 1.1.0-preview.3

Third Reloaded preview package.

### New

- New profiles immediately include every currently active EVE character in their hotkey and custom-color lists.
- New profile contents refresh in the open settings window without restarting the application.
- Per-profile option to lock thumbnail positions and sizes.

### Fixed

- Profile creation now uses a deep copy, preventing later changes from leaking into the source or default profile.
- Locked thumbnails ignore right-button dragging and combined right-/left-button resizing.

### Compatibility

- Existing profiles receive the unlocked default and keep their current mouse behavior.
- The lock setting is stored separately for each profile.

### Test focus

- Keep several EVE clients open, create a profile, and confirm the names appear immediately under Hotkeys and Custom Colors.
- Enable "Lock positions and size" and confirm right-drag and right+left resize no longer move thumbnails.
- Confirm normal left-click client activation still works while locked.
- Disable the lock and confirm moving and resizing work again.
