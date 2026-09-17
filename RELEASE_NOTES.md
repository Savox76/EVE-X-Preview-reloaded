## EVE-X-Preview Reloaded 2.0.0

First stable Reloaded release.

### Fixed

- Hotkey groups now select clients from a stable snapshot of currently running EVE windows.
- Forward and backward cycling check every configured character at most once, preventing a disappearing or unavailable window from trapping the application in an endless search.
- Minimized target clients are restored and then explicitly brought to the foreground; activation is verified and retried once before the switch is considered successful.
- A pending minimize action from the previous switch is cancelled before another client is activated, preventing fast switching from minimizing the new target and briefly exposing the desktop.
- EVE window handles are passed to the Windows API with the pointer-sized type required by 64-bit Windows.
- Character names beginning with “Eve”, including “Eve Phillips”, remain intact while an actual `EVE - ` window-title prefix is removed safely.

### Included from the preview phase

- Portable ZIP distribution with German and English user interfaces.
- Automatic and manual GitHub update notifications.
- Native Windows color selection with hexadecimal and RGB input.
- Automatic discovery of active client names in profiles.
- Per-profile protection against accidental thumbnail movement and resizing.
- Live thumbnail width and height changes without restarting the application.

### Automated verification

- New executable Windows regression tests cover forward and backward cycling, wraparound, unavailable clients, clients outside the group, an empty live-client set, and names beginning with “Eve”.
- The existing project contract, AutoHotkey compilation, portable ZIP build, and ZIP content verification remain mandatory.

### Recommended practical check

- Open at least three EVE clients and cycle forward and backward several times.
- Minimize one target client and confirm the first hotkey press restores and activates it.
- Enable automatic minimization of inactive clients and switch rapidly in both directions; the selected target should remain active and the desktop should not appear.
