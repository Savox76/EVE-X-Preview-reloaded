## EVE-X-Preview Reloaded 2.2.0

### Modern interface completed

- **Modern Dark** and **Modern Light** now match the approved desktop concept with a fixed top bar, sidebar navigation, consistent cards, spacing and modern switches.
- The thumbnail overview provides size, spacing, aspect-ratio locking, border, character-name and inactive-client controls at a glance.
- A live preview uses running EVE clients when available and immediately reflects relevant setting changes.
- A separate detail view keeps all advanced text, frame, opacity and window-behaviour settings accessible without cluttering the overview.
- **Classic** remains available as an independent interface option.

### Behaviour improvements

- The configurable thumbnail minimum size has been removed completely.
- Thumbnail size and profile settings take effect immediately without requiring an application restart.
- Window and thumbnail positions continue to be stored per profile.
- Inactive clients can optionally be dimmed, and thumbnail resizing can preserve the selected aspect ratio.

### Verification

- The real compiled Windows application is automatically captured in dark and light mode for both the overview and detail view.
- Regression checks, AutoHotkey compilation, portable ZIP creation and ZIP-content verification passed before release.
