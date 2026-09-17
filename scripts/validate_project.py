#!/usr/bin/env python3
from __future__ import annotations

import json
import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


def fail(message: str) -> None:
    raise AssertionError(message)


def load_json(path: Path) -> dict[str, object]:
    with path.open("r", encoding="utf-8-sig") as handle:
        return json.load(handle)


def validate_version() -> None:
    version = (ROOT / "VERSION").read_text(encoding="utf-8").strip()
    app_info = (ROOT / "src" / "AppInfo.ahk").read_text(encoding="utf-8-sig")
    match = re.search(r'static Version := "([^"]+)"', app_info)
    if not match or match.group(1) != version:
        fail("VERSION and AppInfo.Version must match")

    version_match = re.fullmatch(r"(\d+)\.(\d+)\.(\d+)(?:-preview\.(\d+))?", version)
    if not version_match:
        fail(f"Unsupported version format: {version}")

    expected_file_version = ".".join(
        [version_match.group(1), version_match.group(2), version_match.group(3), version_match.group(4) or "0"]
    )
    main = (ROOT / "Main.ahk").read_text(encoding="utf-8-sig")
    if f";@Ahk2Exe-SetVersion {expected_file_version}" not in main:
        fail("Ahk2Exe product version does not match VERSION")
    if f";@Ahk2Exe-SetFileVersion {expected_file_version}" not in main:
        fail("Ahk2Exe file version does not match VERSION")


def validate_locales() -> None:
    english = load_json(ROOT / "locales" / "en.json")
    german = load_json(ROOT / "locales" / "de.json")
    if set(english) != set(german):
        missing_de = sorted(set(english) - set(german))
        missing_en = sorted(set(german) - set(english))
        fail(f"Locale keys differ. Missing DE={missing_de}; missing EN={missing_en}")
    if any(not isinstance(value, str) or not value.strip() for value in english.values()):
        fail("English locale contains an empty or non-string value")
    if any(not isinstance(value, str) or not value.strip() for value in german.values()):
        fail("German locale contains an empty or non-string value")

    used_keys: set[str] = set()
    for path in [ROOT / "Main.ahk", *(ROOT / "src").glob("*.ahk")]:
        text = path.read_text(encoding="utf-8-sig")
        used_keys.update(re.findall(r'Tr\("([^"]+)"', text))
    missing = sorted(used_keys - set(english))
    if missing:
        fail(f"Translation keys used in code are missing: {missing}")


def validate_default_settings() -> None:
    source = (ROOT / "Lib" / "DefaultJSON.ahk").read_text(encoding="utf-8-sig")
    match = re.search(r'default_JSON := "\s*\(\s*(\{.*\})\s*\)"', source, re.DOTALL)
    if not match:
        fail("Could not extract default JSON")
    settings = json.loads(match.group(1))
    globals_ = settings["global_Settings"]
    if globals_.get("Language") != "de":
        fail("German must be the default language for new configurations")
    if "LastNotifiedVersion" not in globals_:
        fail("LastNotifiedVersion is missing from default settings")
    if "Example Name" in source or "Example Char" in source:
        fail("Default settings must not contain example client placeholders")


def validate_client_discovery() -> None:
    main_class = (ROOT / "src" / "Main_Class.ahk").read_text(encoding="utf-8-sig")
    properties = (ROOT / "src" / "Propertys.ahk").read_text(encoding="utf-8-sig")
    if "This.RememberClientName(WinList.%hwnd%.Title)" not in main_class:
        fail("Detected clients are not connected to profile discovery")
    if 'RegExReplace(title, "i)^EVE\\s*-\\s*", "")' not in main_class:
        fail("Window title cleanup is not protected against character names beginning with Eve")
    if "This.PopulateProfileWithActiveClients(ProfileName)" not in properties:
        fail("New profiles are not populated with currently active clients")
    if "JSON.Load(JSON.Dump(SourceProfile))" not in properties:
        fail("New profiles must be deep copies")


def validate_thumbnail_lock() -> None:
    defaults = (ROOT / "Lib" / "DefaultJSON.ahk").read_text(encoding="utf-8-sig")
    main_class = (ROOT / "src" / "Main_Class.ahk").read_text(encoding="utf-8-sig")
    settings_gui = (ROOT / "src" / "Settings_Gui.ahk").read_text(encoding="utf-8-sig")
    if '"LockThumbnailPositions": false' not in defaults:
        fail("Thumbnail position lock must default to false")
    if "if (This.LockThumbnailPositions)" not in main_class:
        fail("Thumbnail mouse handling does not enforce the position lock")
    if "vLockThumbnailPositions" not in settings_gui:
        fail("Thumbnail position lock is missing from settings")


def validate_live_thumbnail_size() -> None:
    main_class = (ROOT / "src" / "Main_Class.ahk").read_text(encoding="utf-8-sig")
    settings_gui = (ROOT / "src" / "Settings_Gui.ahk").read_text(encoding="utf-8-sig")
    thumb_window = (ROOT / "src" / "ThumbWindow.ahk").read_text(encoding="utf-8-sig")
    if "ApplyThumbnailStartSize_Delay_Timer := ObjBindMethod" not in main_class:
        fail("Live thumbnail size timer is missing")
    if settings_gui.count("SetTimer(This.ApplyThumbnailStartSize_Delay_Timer, -250)") != 2:
        fail("Thumbnail width and height must both trigger the live size update")
    required_updates = [
        "ApplyThumbnailStartSize(*)",
        "This.ThumbMove(X, Y, Width, Height, ThumbObj)",
        'ThumbObj["TextOverlay"]["OverlayText"].Move(, , Width)',
        'This.BorderSize(ThumbObj["Window"].Hwnd, ThumbObj["Border"].Hwnd)',
        'This.Update_Thumb(false, ThumbObj["Window"].Hwnd)',
        "This.Save_Settings()",
    ]
    missing = [entry for entry in required_updates if entry not in thumb_window]
    if missing:
        fail(f"Live thumbnail size update is incomplete: {missing}")


def validate_interface_themes_and_free_resize() -> None:
    defaults = (ROOT / "Lib" / "DefaultJSON.ahk").read_text(encoding="utf-8-sig")
    properties = (ROOT / "src" / "Propertys.ahk").read_text(encoding="utf-8-sig")
    settings_gui = (ROOT / "src" / "Settings_Gui.ahk").read_text(encoding="utf-8-sig")
    thumb_window = (ROOT / "src" / "ThumbWindow.ahk").read_text(encoding="utf-8-sig")
    main = (ROOT / "Main.ahk").read_text(encoding="utf-8-sig")
    workflow = (ROOT / ".github" / "workflows" / "quality-release.yml").read_text(encoding="utf-8")
    capture_script = ROOT / "scripts" / "capture-settings.ps1"

    required_theme_contract = [
        '"InterfaceTheme": "Classic"',
        'This.InterfaceTheme != "Classic"',
        '["Classic", "ModernDark", "ModernLight"]',
        "ConfigureModernInterface()",
        "ModernNavigate(PageKey, *)",
        "ConfigureModernPageLayouts(CardColor, BorderColor, Foreground, Muted)",
        "LayoutModernThumbnailPage(CardColor, BorderColor, Foreground)",
        'This.AddModernCard("Thumbnail Settings"',
        'Tr("modern.size_layout")',
        'Tr("modern.display")',
        'Tr("modern.live_preview")',
        'CreateModernToggle(PageKey, ControlName',
        'CreateModernPreview(CardColor, BorderColor, Foreground)',
        'LayoutModernThumbnailDetails(CardColor, BorderColor, Foreground)',
        'ToggleModernThumbnailMode(*)',
        'This.ModernPageExtras["Thumbnail Details"]',
        '"HideThumbnailsOnLostFocus"',
        '"ShowThumbnailsAlwaysOnTop"',
        '"LockThumbnailPositions"',
        '"ShowAllBorders"',
        '"w1120 h800',
        'This.SaveJsonToFile()',
    ]
    combined = defaults + properties + settings_gui
    missing = [entry for entry in required_theme_contract if entry not in combined]
    if missing:
        fail(f"Selectable interface themes are incomplete: {missing}")

    active_sources = defaults + properties + settings_gui + thumb_window
    if "ThumbnailMinimumSize" in active_sources:
        fail("The obsolete thumbnail minimum size is still active")
    if 'Settings["global_Settings"].Delete("ThumbnailMinimumSize")' not in main:
        fail("Existing configurations do not remove the obsolete thumbnail minimum size")
    if 'if (Wn < 1 || Wh < 1)' not in thumb_window:
        fail("Thumbnail resizing does not guard Windows against invalid non-positive dimensions")

    modern_behavior_contract = [
        '"KeepThumbnailAspectRatio": true',
        '"DimInactiveClients": false',
        "KeepThumbnailAspectRatio {",
        "DimInactiveClients {",
        "This.KeepThumbnailAspectRatio && Width > 0 && Height > 0",
        "This.DimInactiveClients && !IsActiveClient",
    ]
    missing = [entry for entry in modern_behavior_contract if entry not in active_sources]
    if missing:
        fail(f"Modern thumbnail controls are not connected to live behavior: {missing}")

    if not capture_script.is_file():
        fail("The compiled GUI screenshot script is missing")
    required_visual_review = [
        'A_Args[1] = "--ui-preview"',
        "Capture real modern settings windows",
        "-Theme ModernDark",
        "-Theme ModernLight",
        "actions/upload-artifact@v4",
        "settings-gui-review",
    ]
    visual_sources = main + workflow
    missing = [entry for entry in required_visual_review if entry not in visual_sources]
    if missing:
        fail(f"Compiled GUI visual review is incomplete: {missing}")


def validate_thumbnail_settings_layout() -> None:
    settings_gui = (ROOT / "src" / "Settings_Gui.ahk").read_text(encoding="utf-8-sig")
    start = settings_gui.index("    ThumbnailSettings_Ctrl() {")
    end = settings_gui.index("    Thumbnail_visibilityCtrl() {", start)
    section = settings_gui[start:end]

    required_grid = ["LabelX := 35", "ControlX := 335", "RowY := 220", "RowStep := 28"]
    missing = [entry for entry in required_grid if entry not in section]
    if missing:
        fail(f"Thumbnail settings fixed grid is incomplete: {missing}")
    if section.count("RowY += RowStep") != 14:
        fail("Thumbnail settings must use exactly one fixed row per setting")

    primary_controls = [
        "ShowThumbnailTextOverlay",
        "ThumbnailTextColor",
        "ThumbnailTextSize",
        "ThumbnailTextFont",
        "ThumbnailTextMarginsx",
        "ClientHighligtColor",
        "ClientHighligtBorderthickness",
        "ShowClientHighlightBorder",
        "HideThumbnailsOnLostFocus",
        "ThumbnailOpacity",
        "ShowThumbnailsAlwaysOnTop",
        "LockThumbnailPositions",
        "ShowAllBorders",
        "InactiveClientBorderthickness",
        "InactiveClientBorderColor",
    ]
    for name in primary_controls:
        pattern = rf'Add\("(?:CheckBox|Edit)", "x" ControlX " y" RowY[^\n]*v{name}(?:\s|\b)'
        if not re.search(pattern, section):
            fail(f"Thumbnail setting is not aligned to the primary control column: {name}")

    forbidden_relative_positions = ['"xs y+', '"xs+300', '"x+5 yp', '"x+4 yp']
    found = [entry for entry in forbidden_relative_positions if entry in section]
    if found:
        fail(f"Thumbnail settings still contain drifting relative positions: {found}")


def validate_group_cycle_reliability() -> None:
    main = (ROOT / "Main.ahk").read_text(encoding="utf-8-sig")
    main_class = (ROOT / "src" / "Main_Class.ahk").read_text(encoding="utf-8-sig")
    helper = (ROOT / "src" / "GroupCycle.ahk").read_text(encoding="utf-8-sig")
    workflow = (ROOT / ".github" / "workflows" / "quality-release.yml").read_text(encoding="utf-8")
    test_file = ROOT / "tests" / "group-cycle.ahk"

    if "#Include <../src/GroupCycle>" not in main:
        fail("GroupCycle helper is not included by the application")
    if "GroupCycle.SelectIndex" not in main_class:
        fail("Hotkey groups do not use the bounded selection helper")
    if 'while (!(WinExist("EVE - "' in main_class:
        fail("Hotkey group cycling still contains an unbounded window-search loop")
    required_activation_guards = [
        "SetTimer(This.timer, 0)",
        "RequestEVEForeground(hwnd)",
        'WinWaitActive("ahk_id " hwnd, , 0.35)',
    ]
    missing = [entry for entry in required_activation_guards if entry not in main_class]
    if missing:
        fail(f"Reliable client activation is incomplete: {missing}")
    if "loop Characters.Length" not in helper:
        fail("Group client selection must be bounded by the configured group size")
    if not test_file.is_file():
        fail("Group cycle regression test is missing")
    if "Test hotkey group cycling" not in workflow or "tests/group-cycle.ahk" not in workflow:
        fail("Windows CI does not execute the group cycle regression test")


def validate_live_profile_settings() -> None:
    main_class = (ROOT / "src" / "Main_Class.ahk").read_text(encoding="utf-8-sig")
    settings_gui = (ROOT / "src" / "Settings_Gui.ahk").read_text(encoding="utf-8-sig")
    thumb_window = (ROOT / "src" / "ThumbWindow.ahk").read_text(encoding="utf-8-sig")
    tray_menu = (ROOT / "src" / "TrayMenu.ahk").read_text(encoding="utf-8-sig")

    required_position_capture = [
        "AutoSaveClientPositions_Timer := ObjBindMethod",
        "SetTimer(This.AutoSaveClientPositions_Timer, 750)",
        "AutoSaveClientPositions(*)",
        "Placement := This.GetWindowPlacement(Hwnd)",
        "Placement.flags & 0x2",
    ]
    missing = [entry for entry in required_position_capture if entry not in main_class]
    if missing:
        fail(f"Automatic EVE window position capture is incomplete: {missing}")

    if thumb_window.count("This.Save_Settings()") < 3:
        fail("Thumbnail movement and resizing must persist the active profile layout")

    required_live_apply = [
        "ScheduleProfileApply(*)",
        "ApplyProfileSettings(RestoreClientLayout := false, CaptureThumbnailLayout := true, *)",
        "RebuildThumbnailsForProfile(RestoreClientLayout := false)",
        "This.RefreshProfileHotkeys()",
        "This.ApplyProfileSettings(true, false)",
    ]
    combined = settings_gui + thumb_window + tray_menu
    missing = [entry for entry in required_live_apply if entry not in combined]
    if missing:
        fail(f"Restart-free profile application is incomplete: {missing}")

    required_hotkey_lifecycle = [
        "ProfileHotkeyRegistrations := []",
        "RegisterManagedProfileHotkey(KeyName, Callback, Criterion)",
        "ClearProfileHotkeys()",
        'Hotkey(Registration["Key"], "Off")',
    ]
    missing = [entry for entry in required_hotkey_lifecycle if entry not in main_class]
    if missing:
        fail(f"Managed profile hotkey lifecycle is incomplete: {missing}")

    profile_sections = settings_gui[settings_gui.index("    ClientSettings_Ctrl"):]
    if "This.NeedRestart := 1" in profile_sections:
        fail("Profile settings still request an application restart")


def validate_color_picker() -> None:
    main = (ROOT / "Main.ahk").read_text(encoding="utf-8-sig")
    settings_gui = (ROOT / "src" / "Settings_Gui.ahk").read_text(encoding="utf-8-sig")
    if "#Include <../src/ColorPicker>" not in main:
        fail("ColorPicker is not included")
    required_controls = [
        "ThumbnailBackgroundColor",
        "ThumbnailTextColor",
        "ClientHighligtColor",
        "InactiveClientBorderColor",
        "CBorderColor",
        "CTextColor",
        "IABorderColor",
    ]
    missing = [name for name in required_controls if f'ChooseSingleColor("{name}")' not in settings_gui and f'ChooseListColor("{name}")' not in settings_gui]
    if missing:
        fail(f"Color palette is missing for: {missing}")


def validate_portable_contract() -> None:
    required = [
        ROOT / "PORTABLE.md",
        ROOT / "LICENSE",
        ROOT / "locales" / "de.json",
        ROOT / "locales" / "en.json",
    ]
    missing = [str(path.relative_to(ROOT)) for path in required if not path.is_file()]
    if missing:
        fail(f"Portable package inputs are missing: {missing}")

    tracked_settings = ROOT / "EVE-X-Preview.json"
    if tracked_settings.exists():
        fail("Personal EVE-X-Preview.json must not be part of the repository")


def validate_site_desktop_grid() -> None:
    hosting = load_json(ROOT / ".openai" / "hosting.json")
    if hosting.get("static", {}).get("directory") != "out":
        fail("Project website must publish the validated out directory")

    site = ROOT / "out"
    required_assets = [
        site / "index.html",
        site / "styles.css",
        site / "app.js",
        site / "favicon.svg",
        site / ".nojekyll",
        site / "images" / "global-settings.png",
        site / "images" / "profile-settings.png",
    ]
    missing = [str(path.relative_to(ROOT)) for path in required_assets if not path.is_file()]
    if missing:
        fail(f"Project website assets are missing: {missing}")

    css = (site / "styles.css").read_text(encoding="utf-8")
    required_grid = [
        "--gutter: clamp(",
        "--heading-rail: 180px",
        "--grid-gap: 2rem",
        "calc(var(--max) + var(--gutter) + var(--gutter))",
        "grid-template-columns: var(--heading-rail) minmax(0, 1fr) minmax(260px, 340px)",
        "width: calc(100% - var(--heading-rail) - var(--grid-gap))",
    ]
    missing = [entry for entry in required_grid if entry not in css]
    if missing:
        fail(f"Project website desktop grid is incomplete: {missing}")
    if ".section { max-width: var(--max)" in css:
        fail("Project website sections still lose width through the old nested padding layout")

    pages_url = "https://savox76.github.io/EVE-X-Preview-reloaded/"
    readme = (ROOT / "README.MD").read_text(encoding="utf-8-sig")
    html = (site / "index.html").read_text(encoding="utf-8")
    if pages_url not in readme:
        fail("README must link to the GitHub Pages website")
    if f'<link rel="canonical" href="{pages_url}">' not in html:
        fail("Project website must declare its GitHub Pages URL as canonical")

    pages_workflow = (ROOT / ".github" / "workflows" / "pages.yml").read_text(encoding="utf-8")
    required_pages_config = [
        "actions/configure-pages@v5",
        "actions/upload-pages-artifact@v4",
        "actions/deploy-pages@v4",
        "path: out",
        "pages: write",
        "id-token: write",
        "name: github-pages",
    ]
    missing = [entry for entry in required_pages_config if entry not in pages_workflow]
    if missing:
        fail(f"GitHub Pages workflow is incomplete: {missing}")


def main() -> int:
    checks = [
        validate_version,
        validate_locales,
        validate_default_settings,
        validate_client_discovery,
        validate_thumbnail_lock,
        validate_live_thumbnail_size,
        validate_interface_themes_and_free_resize,
        validate_thumbnail_settings_layout,
        validate_group_cycle_reliability,
        validate_live_profile_settings,
        validate_color_picker,
        validate_portable_contract,
        validate_site_desktop_grid,
    ]
    for check in checks:
        check()
        print(f"PASS {check.__name__}")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except AssertionError as error:
        print(f"FAIL {error}", file=sys.stderr)
        raise SystemExit(1)
