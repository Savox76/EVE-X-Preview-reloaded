## EVE-X-Preview Reloaded 2.1.1

### Corrected

- **Modern Dark** and **Modern Light** now use a genuinely separate modern layout instead of shifted Classic controls.
- The new shell follows the approved concept with a fixed top bar, persistent profile selector, styled sidebar navigation, card-based content and consistent spacing.
- Thumbnail settings are divided into **Text and layout** and **Appearance and behavior** cards.
- Global, client, color, hotkey, group and visibility pages have been individually reflowed for the wider interface.
- **Classic** remains unchanged and selectable.

### Still included from 2.1.0

- The design selection is stored globally and applied immediately.
- The configurable thumbnail minimum size remains removed.
- All profile settings continue to apply and save automatically.

### Automated verification

- CI now launches the real compiled Windows application and captures both modern designs as PNG files for visual review.
- AutoHotkey regression tests, compilation, portable ZIP creation and ZIP content verification remain mandatory before merging.

### Recommended practical check

- Compare both modern interfaces with the approved concept: top bar, left navigation, two thumbnail-setting cards and aligned controls.
- Switch among all three designs and confirm the selection is retained after reopening.
- Change a profile value in each design and confirm it is applied immediately.
