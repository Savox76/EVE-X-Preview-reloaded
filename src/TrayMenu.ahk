Class TrayMenu extends Settings_Gui {
    TrayMenuObj := A_TrayMenu
    Saved_overTray := 0
    Tray_Profile_scwitch := 0

    TrayMenu() {
        ProfilesSubmenu := Menu()
        for ProfileName in This.Profiles {
            ProfilesSubmenu.Add(ProfileName, ObjBindMethod(This, "SelectTrayProfile", ProfileName))
            if (ProfileName = This.LastUsedProfile)
                ProfilesSubmenu.Check(ProfileName)
        }

        TrayMenu := This.TrayMenuObj
        TrayMenu.Delete()

        OpenLabel := Tr("tray.open")
        SuspendLabel := Tr("tray.suspend")
        RestoreLabel := Tr("tray.restore_positions")
        VersionLabel := Tr("update.version", AppInfo.Version)

        TrayMenu.Add(OpenLabel, ObjBindMethod(This, "OpenSettings"))
        TrayMenu.Add()
        TrayMenu.Add(Tr("tray.profiles"), ProfilesSubmenu)
        TrayMenu.Add()
        TrayMenu.Add(SuspendLabel, ObjBindMethod(This, "ToggleHotkeysFromTray", SuspendLabel))
        TrayMenu.Add()
        TrayMenu.Add(Tr("tray.close_clients"), (*) => This.CloseAllEVEWindows())
        TrayMenu.Add()
        TrayMenu.Add(RestoreLabel, ObjBindMethod(This, "ToggleRestoreClientPositions", RestoreLabel))
        if (This.TrackClientPossitions)
            TrayMenu.Check(RestoreLabel)

        TrayMenu.Add(Tr("tray.save_client_positions"), (*) => This.Client_Possitions())
        TrayMenu.Add(Tr("tray.save_thumbnail_positions"), (*) => This.Save_ThumbnailPossitions())
        TrayMenu.Add()
        TrayMenu.Add(Tr("tray.check_updates"), (*) => This.CheckForUpdates(false))
        TrayMenu.Add(Tr("tray.github_releases"), (*) => Run(AppInfo.ReleasesUrl))
        TrayMenu.Add()
        TrayMenu.Add(Tr("tray.reload"), (*) => Reload())
        TrayMenu.Add(Tr("tray.exit"), (*) => ExitApp())
        TrayMenu.Add()
        TrayMenu.Add(VersionLabel, (*) => 0)
        TrayMenu.Disable(VersionLabel)
        TrayMenu.Default := OpenLabel
    }

    OpenSettings(*) {
        if WinExist(This.SettingsWindowTitle) {
            WinActivate(This.SettingsWindowTitle)
            return
        }
        This.MainGui()
    }

    SelectTrayProfile(ProfileName, *) {
        if (ProfileName = This.LastUsedProfile)
            return
        This.Save_Settings()
        This.AutoSaveClientPositions()
        This.SaveJsonToFile()
        This.LastUsedProfile := ProfileName
        This.ApplyProfileSettings(true, false)
    }

    ToggleHotkeysFromTray(ItemLabel, *) {
        Suspend(-1)
        This.TrayMenuObj.ToggleCheck(ItemLabel)
    }

    ToggleRestoreClientPositions(ItemLabel, *) {
        This.TrackClientPossitions := !This.TrackClientPossitions
        This.TrayMenuObj.ToggleCheck(ItemLabel)
        SetTimer(This.Save_Settings_Delay_Timer, -200)
    }

    CloseAllEVEWindows(*) {
        try {
            list := WinGetList("Ahk_Exe exefile.exe")
            GroupAdd("EVE", "Ahk_Exe exefile.exe")
            for k in list {
                PostMessage 0x0112, 0xF060, , , k
                Sleep(50)
            }
        }
    }
}
