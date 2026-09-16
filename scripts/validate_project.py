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


def main() -> int:
    checks = [
        validate_version,
        validate_locales,
        validate_default_settings,
        validate_client_discovery,
        validate_thumbnail_lock,
        validate_color_picker,
        validate_portable_contract,
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
