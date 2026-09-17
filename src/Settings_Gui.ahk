Class Settings_Gui {
    MainGui() {
        ;if settings got chnaged which require a restart to apply
        This.NeedRestart := 0
        IsModern := This.InterfaceTheme != "Classic"

        SetControlDelay(-1)
        This.S_Gui := Gui("+OwnDialogs +MinimizeBox -Resize -MaximizeBox SysMenu " (IsModern ? "+MinSize1120x760" : "+MinSize500x250"))
        This.S_Gui.Title := This.SettingsWindowTitle

        ;Font options for the Buttons
        This.S_Gui.SetFont("s10 w700")

        ;Sets Margins for the following Buttons
        This.S_Gui.MarginX := 80, This.S_Gui.MarginY := 20
        This.ClassicGlobalButton := This.S_Gui.Add("Button", " x110 y20 w160 h40 vGlobal_Settings", Tr("main.global_settings"))
        This.ClassicGlobalButton.OnEvent("Click", (obj, *) => Button_Handler(obj))
        This.ClassicProfileButton := This.S_Gui.Add("Button", "x+30 y+-40 wp hp vProfile_Settings", Tr("main.profile_settings"))
        This.ClassicProfileButton.OnEvent("Click", (obj, *) => Button_Handler(obj))

        This.S_Gui.Show("hide")

        ;Create the Arrays which hold the GUI objects for the controls
        This.S_Gui.Controls := [], This.S_Gui.ClientSettings := []

        ;Sets Margins for the following controls
        This.S_Gui.MarginX := 25

        ;Default Font options for the controls
        This.S_Gui.SetFont("s9 w400")
        ;Creates the Controls
        This.Global_Settings(), This.Profile_Settings(), This.ClientSettings_Ctrl(), This.Custom_ColorsCtrl()
        This.Hotkey_GroupsCtrl(), This.HotkeysCtrl(), This.ThumbnailSettings_Ctrl(), This.Thumbnail_visibilityCtrl()

        if (IsModern)
            This.ConfigureModernInterface()

        ModernShowOptions := This.HasProp("UIVisualPreview") ? "w1120 h760 x0 y0" : "w1120 h760 Center"
        This.S_Gui.Show(IsModern ? ModernShowOptions : "AutoSize Center")
        This._Button_Load()
        if (IsModern)
            This.ModernNavigate("Global Settings")

        This.Seetings_DDL.OnEvent("Change", (Obj, *) => SettingsDDL_Handler(Obj))

        This.S_Gui.OnEvent("Close", (*) => GuiDestroy())

        GuiDestroy(*) {
            This.S_Gui.Destroy()
            if (This.NeedRestart)
                Reload()
        }

        SettingsDDL_Handler(Obj) {
            SelectedSection := This.GetSelectedProfileSection()
            for k, v in This.S_Gui.Controls.Profile_Settings.PsDDL {
                if k = SelectedSection {
                    for _, ob in v
                        ob.Visible := 1
                }
                else {
                    for _, ob in v
                        ob.Visible := 0
                }                
            }
            if (This.InterfaceTheme = "Classic")
                This.S_Gui.Show("AutoSize")
        }

        Button_Handler(obj) {
            if (obj.Name = "Global_Settings") {
                for ButtonName, Controls in This.S_Gui.Controls.OwnProps() {
                    if ButtonName = obj.Name {
                        for _, Ctrl in Controls {
                            Ctrl.Visible := 1
                        }
                    }
                    else {
                        for _, Ctrl in Controls {
                            Ctrl.Visible := 0
                        }
                        for _, Ctrl in This.S_Gui.Controls.Profile_Settings.PsDDL {
                            for k, v in Ctrl
                                v.Visible := 0
                        }

                    }
                }
            }
            else if (obj.Name = "Profile_Settings") {
                for ButtonName, Controls in This.S_Gui.Controls.OwnProps() {
                    if ButtonName = obj.Name {
                        for _, Ctrl in Controls {
                            Ctrl.Visible := 1
                        }
                        for _, Ctrl in This.S_Gui.Controls.Profile_Settings.PsDDL {
                            if (This.GetSelectedProfileSection() = _) {
                                for k, v in Ctrl {
                                    v.Visible := 1
                                }
                            }
                        }                        
                    }
                    else {
                        for _, Ctrl in Controls {
                            Ctrl.Visible := 0
                        }
                    }
                }
                if (This.Profiles.Count = 1 && This.SelectProfile_DDL.Text = "Default")
                    MsgBox(Tr("profile.default_locked"), AppInfo.Name)
            }

            if (This.InterfaceTheme = "Classic")
                This.S_Gui.Show("AutoSize")
        }
    }

    InterfaceThemeLabels() {
        return [Tr("theme.classic"), Tr("theme.modern_dark"), Tr("theme.modern_light")]
    }

    InterfaceThemeIndex() {
        return This.InterfaceTheme = "ModernDark" ? 2 : This.InterfaceTheme = "ModernLight" ? 3 : 1
    }

    SwitchInterfaceTheme(ThemeControl, *) {
        Themes := ["Classic", "ModernDark", "ModernLight"]
        NewTheme := Themes[ThemeControl.Value]
        if (NewTheme = This.InterfaceTheme)
            return
        This.InterfaceTheme := NewTheme
        This.SaveJsonToFile()
        This.S_Gui.Destroy()
        SetTimer(ObjBindMethod(This, "MainGui"), -50)
    }

    ConfigureModernInterface() {
        IsDark := This.InterfaceTheme = "ModernDark"
        Background := IsDark ? "151719" : "F3F4F6"
        Sidebar := IsDark ? "101214" : "E8EAED"
        Card := IsDark ? "202326" : "FFFFFF"
        Border := IsDark ? "34383D" : "D7DCE2"
        Accent := IsDark ? "F2A91D" : "D88B08"
        Foreground := IsDark ? "F0F1F2" : "17191C"
        Muted := IsDark ? "A7ABB0" : "60656C"

        This.S_Gui.BackColor := Background
        This.ModernSidebarColor := Sidebar
        This.ModernAccentColor := Accent
        This.ModernForegroundColor := Foreground
        This.ClassicGlobalButton.Visible := false
        This.ClassicProfileButton.Visible := false

        Header := This.S_Gui.Controls.Profile_Settings
        Header[1].Move(580, 20, 75, 20)
        Header[2].Move(655, 14, 190, 30)
        Header[3].Move(855, 14, 82, 30)
        Header[4].Move(945, 14, 82, 30)
        loop Header.Length - 4
            Header[A_Index + 4].Visible := false

        This.ModernChrome := []
        SidebarPanel := This.S_Gui.Add("Text", "x0 y55 w238 h705 Background" Sidebar)
        This.ModernChrome.Push SidebarPanel
        This.SendControlToBack(SidebarPanel)
        This.S_Gui.SetFont("s15 w700 c" Foreground, "Segoe UI")
        This.ModernChrome.Push This.S_Gui.Add("Text", "x24 y15 w350 h30 BackgroundTrans", AppInfo.Name)
        This.S_Gui.SetFont("s9 w400 c" Muted, "Segoe UI")
        This.ModernChrome.Push This.S_Gui.Add("Text", "x385 y21 w110 h20 BackgroundTrans", "v" AppInfo.Version)
        This.ModernChrome.Push This.S_Gui.Add("Text", "x0 y54 w1120 h1 Background" Border)
        This.ModernChrome.Push This.S_Gui.Add("Text", "x237 y55 w1 h705 Background" Border)

        This.S_Gui.SetFont("s18 w700 c" Foreground, "Segoe UI")
        This.ModernPageTitle := This.S_Gui.Add("Text", "x270 y82 w790 h36 BackgroundTrans", Tr("main.global_settings"))
        This.ModernChrome.Push This.ModernPageTitle

        Navigation := [
            ["Global Settings", Tr("nav.general")],
            ["Client Settings", Tr("nav.client")],
            ["Thumbnail Settings", Tr("nav.thumbnails")],
            ["Custom Colors", Tr("nav.colors")],
            ["Hotkeys", Tr("nav.hotkeys")],
            ["Hotkey Groups", Tr("nav.hotkey_groups")],
            ["Thumbnail Visibility", Tr("nav.visibility")]
        ]
        This.ModernNavButtons := Map()
        This.ModernNavLabels := Map()
        NavY := 86
        This.S_Gui.SetFont("s10 w500 c" Foreground, "Segoe UI")
        for Entry in Navigation {
            PageKey := Entry[1], Label := Entry[2]
            NavButton := This.S_Gui.Add("Text", "x12 y" NavY " w213 h42 +0x100 +0x200 Background" Sidebar, "      " Label)
            NavButton.OnEvent("Click", ObjBindMethod(This, "ModernNavigate", PageKey))
            This.ModernNavButtons[PageKey] := NavButton
            This.ModernNavLabels[PageKey] := Label
            NavY += 48
        }

        This.S_Gui.SetFont("s9 w400 c" Muted, "Segoe UI")
        This.ModernChrome.Push This.S_Gui.Add("Text", "x18 y642 w195 h20 BackgroundTrans", Tr("global.interface_theme"))
        This.ModernThemeSelector := This.S_Gui.Add("DDL", "x18 y665 w195 Choose" This.InterfaceThemeIndex(), This.InterfaceThemeLabels())
        This.ModernThemeSelector.OnEvent("Change", ObjBindMethod(This, "SwitchInterfaceTheme"))
        This.ModernChrome.Push This.ModernThemeSelector
        This.S_Gui.SetFont("s9 w600 c4AA568", "Segoe UI")
        This.ModernChrome.Push This.S_Gui.Add("Text", "x18 y712 w195 h20 BackgroundTrans", "●  " Tr("theme.auto_saved"))

        This.ConfigureModernPageLayouts(Card, Border, Foreground, Muted)
        This.StyleModernControls(IsDark, Foreground)
        if (IsDark)
            This.EnableDarkTitleBar()
    }

    ConfigureModernPageLayouts(CardColor, BorderColor, Foreground, Muted) {
        This.ModernPageExtras := Map()
        This.ModernCardPanels := Map()
        Pages := ["Global Settings", "Client Settings", "Thumbnail Settings", "Custom Colors", "Hotkeys", "Hotkey Groups", "Thumbnail Visibility"]
        for PageKey in Pages {
            This.ModernPageExtras[PageKey] := []
            This.ModernCardPanels[PageKey] := []
        }

        ; Allgemein: eine klare zweispaltige Karte statt verschobener Classic-Zeilen.
        G := This.S_Gui.Controls.Global_Settings
        G[1].Visible := false
        This.AddModernCard("Global Settings", 260, 132, 830, 545, Tr("global.general_group"), CardColor, BorderColor, Foreground)
        loop 9 {
            Row := A_Index
            G[Row + 1].Move(288, 210 + (Row - 1) * 50, 350, 22)
        }
        This.S_Gui["Language"].Move(700, 205, 300, 28)
        This.S_Gui["InterfaceTheme"].Move(700, 255, 300, 28)
        This.S_Gui["Suspend_Hotkeys_Hotkey"].Move(700, 305, 210, 28)
        This.S_Gui["Hotkey_Scoope"].Move(700, 355, 300, 28)
        This.S_Gui["ThumbnailBackgroundColor"].Move(700, 405, 145, 28)
        G[16].Move(854, 403, 146, 30)
        This.LayoutModernLocationRow(700, 455)
        This.S_Gui["ThumbnailSnapOn"].Move(700, 505, 75, 24)
        This.S_Gui["ThumbnailSnapOff"].Move(790, 505, 75, 24)
        This.S_Gui["ThumbnailSnap_Distance"].Move(700, 555, 80, 28)
        G[27].Move(788, 560, 100, 20)
        This.S_Gui["Minimizeclients_Delay"].Move(700, 605, 90, 28)

        ; Client-Verhalten.
        C := This.S_Gui.Controls.Profile_Settings.PsDDL["Client Settings"]
        C[1].Visible := false
        This.AddModernCard("Client Settings", 260, 132, 830, 545, Tr("section.client_settings"), CardColor, BorderColor, Foreground)
        C[2].Move(290, 210, 360, 24), C[5].Move(720, 208, 160, 24)
        C[3].Move(290, 262, 360, 24), C[6].Move(720, 260, 160, 24)
        C[4].Move(290, 324, 360, 24), C[7].Move(290, 358, 770, 250)

        This.LayoutModernThumbnailPage(CardColor, BorderColor, Foreground)
        This.LayoutModernColorPage(CardColor, BorderColor, Foreground)
        This.LayoutModernHotkeysPage(CardColor, BorderColor, Foreground)
        This.LayoutModernGroupsPage(CardColor, BorderColor, Foreground)
        This.LayoutModernVisibilityPage(CardColor, BorderColor, Foreground)

        for _, Extras in This.ModernPageExtras {
            for _, Ctrl in Extras
                Ctrl.Visible := false
        }
    }

    AddModernCard(PageKey, X, Y, Width, Height, Heading, CardColor, BorderColor, Foreground) {
        Panel := This.S_Gui.Add("Text", "x" X " y" Y " w" Width " h" Height " +Border Background" CardColor)
        This.SendControlToBack(Panel)
        This.S_Gui.SetFont("s12 w700 c" Foreground, "Segoe UI")
        Title := This.S_Gui.Add("Text", "x" (X + 24) " y" (Y + 18) " w" (Width - 48) " h26 BackgroundTrans", Heading)
        Line := This.S_Gui.Add("Text", "x" (X + 24) " y" (Y + 53) " w" (Width - 48) " h1 Background" BorderColor)
        This.ModernPageExtras[PageKey].Push(Panel, Title, Line)
        This.ModernCardPanels[PageKey].Push(Panel)
    }

    SendControlToBack(Ctrl) {
        try DllCall("SetWindowPos", "ptr", Ctrl.Hwnd, "ptr", 1, "int", 0, "int", 0, "int", 0, "int", 0, "uint", 0x13)
    }

    LayoutModernLocationRow(X, Y) {
        Names := ["ThumbnailStartLocationx", "ThumbnailStartLocationy", "ThumbnailStartLocationwidth", "ThumbnailStartLocationheight"]
        Labels := ["x", "y", "w", "h"]
        loop 4 {
            This.S_Gui[Names[A_Index]].Move(X + (A_Index - 1) * 85 + 22, Y, 55, 28)
        }
        ; The four small x/y/w/h labels immediately precede the location edits.
        G := This.S_Gui.Controls.Global_Settings
        LabelIndexes := [17, 19, 21, 23]
        loop 4
            G[LabelIndexes[A_Index]].Move(X + (A_Index - 1) * 85, Y + 5, 18, 20)
    }

    LayoutModernThumbnailPage(CardColor, BorderColor, Foreground) {
        T := This.S_Gui.Controls.Profile_Settings.PsDDL["Thumbnail Settings"]
        T[1].Visible := false
        This.AddModernCard("Thumbnail Settings", 260, 132, 400, 545, Tr("modern.text_layout"), CardColor, BorderColor, Foreground)
        This.AddModernCard("Thumbnail Settings", 680, 132, 410, 545, Tr("modern.appearance"), CardColor, BorderColor, Foreground)

        ; Linke Karte: Text und Anordnung.
        RowsLeft := [[2,3], [4,5,6], [7,8], [9,10], [11,12,13,14,15]]
        Y := 210
        for Row in RowsLeft {
            T[Row[1]].Move(284, Y, 340, 22)
            This.MoveModernRowControls(T, Row, 284, Y + 28)
            Y += 82
        }

        ; Rechte Karte: Rahmen und Verhalten.
        RowsRight := [[16,17,18], [19,20,21], [22,23], [24,25], [26,27,28], [29,30], [31,32], [33,34], [35,36,37], [38,39,40]]
        Y := 205
        for Row in RowsRight {
            T[Row[1]].Move(704, Y, 215, 22)
            This.MoveModernRowControls(T, Row, 930, Y - 3)
            Y += 42
        }
        T[17].Move(900, 202, 85, 24), T[18].Move(992, 200, 75, 28)
        T[39].Move(900, 580, 85, 24), T[40].Move(992, 578, 75, 28)
    }

    MoveModernRowControls(Controls, Row, X, Y) {
        Offset := 0
        loop Row.Length - 1 {
            Ctrl := Controls[Row[A_Index + 1]]
            Width := Ctrl.Type = "Button" ? 105 : Ctrl.Type = "Edit" ? 75 : Ctrl.Type = "CheckBox" ? 130 : 60
            if (Ctrl.Name = "ThumbnailTextFont")
                Width := 150
            else if (InStr(Ctrl.Name, "Color"))
                Width := 105
            Ctrl.Move(X + Offset, Y, Width, Ctrl.Type = "Button" ? 28 : 24)
            Offset += Width + 7
        }
    }

    LayoutModernColorPage(CardColor, BorderColor, Foreground) {
        C := This.S_Gui.Controls.Profile_Settings.PsDDL["Custom Colors"]
        C[1].Visible := false
        This.AddModernCard("Custom Colors", 260, 132, 830, 545, Tr("section.custom_colors"), CardColor, BorderColor, Foreground)
        C[2].Move(288, 210, 300, 22), C[7].Move(720, 207, 170, 24)
        HeadersX := [288, 478, 668, 858]
        loop 4 {
            C[A_Index + 2].Move(HeadersX[A_Index], 270, 175, 24)
            C[A_Index + 7].Move(HeadersX[A_Index], 300, 175, 280)
        }
        loop 3
            C[A_Index + 11].Move(HeadersX[A_Index + 1], 590, 175, 30)
    }

    LayoutModernHotkeysPage(CardColor, BorderColor, Foreground) {
        H := This.S_Gui.Controls.Profile_Settings.PsDDL["Hotkeys"]
        H[1].Visible := false
        This.AddModernCard("Hotkeys", 260, 132, 830, 545, Tr("section.hotkeys"), CardColor, BorderColor, Foreground)
        H[2].Move(290, 205, 350, 24), H[3].Move(290, 240, 365, 385)
        H[4].Move(690, 205, 350, 24), H[5].Move(690, 240, 365, 385)
    }

    LayoutModernGroupsPage(CardColor, BorderColor, Foreground) {
        G := This.S_Gui.Controls.Profile_Settings.PsDDL["Hotkey Groups"]
        G[1].Visible := false
        This.AddModernCard("Hotkey Groups", 260, 132, 830, 545, Tr("section.hotkey_groups"), CardColor, BorderColor, Foreground)
        G[2].Move(288, 205, 250, 22), G[3].Move(288, 235, 270, 30)
        G[4].Move(870, 235, 85, 30), G[5].Move(965, 235, 85, 30)
        G[6].Move(288, 280, 470, 330)
        G[7].Move(790, 285, 240, 22), G[8].Move(790, 315, 240, 30)
        G[9].Move(790, 385, 240, 22), G[10].Move(790, 415, 240, 30)
    }

    LayoutModernVisibilityPage(CardColor, BorderColor, Foreground) {
        V := This.S_Gui.Controls.Profile_Settings.PsDDL["Thumbnail Visibility"]
        V[1].Visible := false
        This.AddModernCard("Thumbnail Visibility", 260, 132, 830, 545, Tr("section.thumbnail_visibility"), CardColor, BorderColor, Foreground)
        V[2].Move(288, 205, 760, 40), V[3].Move(288, 260, 760, 365)
        try V[3].ModifyCol(1, 700)
    }

    StyleModernControls(IsDark, Foreground) {
        Arrays := [This.S_Gui.Controls.Global_Settings]
        for _, Controls in This.S_Gui.Controls.Profile_Settings.PsDDL
            Arrays.Push(Controls)
        Arrays.Push(This.S_Gui.Controls.Profile_Settings)
        for Controls in Arrays {
            for Ctrl in Controls {
                try Ctrl.SetFont("c" Foreground, "Segoe UI")
                try DllCall("uxtheme\SetWindowTheme", "ptr", Ctrl.Hwnd, "str", IsDark ? "DarkMode_Explorer" : "Explorer", "ptr", 0)
            }
        }
        for _, Ctrl in This.ModernNavButtons
            try DllCall("uxtheme\SetWindowTheme", "ptr", Ctrl.Hwnd, "str", IsDark ? "DarkMode_Explorer" : "Explorer", "ptr", 0)
        try DllCall("uxtheme\SetWindowTheme", "ptr", This.ModernThemeSelector.Hwnd, "str", IsDark ? "DarkMode_Explorer" : "Explorer", "ptr", 0)
    }

    EnableDarkTitleBar() {
        Value := Buffer(4, 0)
        NumPut("Int", 1, Value)
        try DllCall("dwmapi\DwmSetWindowAttribute", "ptr", This.S_Gui.Hwnd, "int", 20, "ptr", Value, "int", 4)
    }

    ModernNavigate(PageKey, *) {
        for _, Ctrl in This.S_Gui.Controls.Global_Settings
            Ctrl.Visible := false
        for _, Controls in This.S_Gui.Controls.Profile_Settings.PsDDL {
            for _, Ctrl in Controls
                Ctrl.Visible := false
        }
        if (This.HasProp("ModernPageExtras")) {
            for _, Extras in This.ModernPageExtras {
                for _, Ctrl in Extras
                    Ctrl.Visible := false
            }
        }

        Header := This.S_Gui.Controls.Profile_Settings
        loop Min(4, Header.Length)
            Header[A_Index].Visible := true
        loop Max(0, Header.Length - 4)
            Header[A_Index + 4].Visible := false

        if (PageKey = "Global Settings") {
            for _, Ctrl in This.S_Gui.Controls.Global_Settings
                Ctrl.Visible := Ctrl.Type != "GroupBox"
            This.ModernPageTitle.Text := Tr("main.global_settings")
        }
        else if (This.S_Gui.Controls.Profile_Settings.PsDDL.Has(PageKey)) {
            for _, Ctrl in This.S_Gui.Controls.Profile_Settings.PsDDL[PageKey]
                Ctrl.Visible := Ctrl.Type != "GroupBox"
            for Index, ProfileKey in This.ProfilePropKeys {
                if (ProfileKey = PageKey) {
                    This.Seetings_DDL.Value := Index
                    break
                }
            }
            This.ModernPageTitle.Text := This.ProfileSectionLabel(PageKey)
            if (This.Profiles.Count = 1 && This.SelectProfile_DDL.Text = "Default")
                ToolTip(Tr("profile.default_locked"), 270, 125)
        }

        if (This.HasProp("ModernPageExtras") && This.ModernPageExtras.Has(PageKey)) {
            for _, Ctrl in This.ModernPageExtras[PageKey]
                Ctrl.Visible := true
        }
        if (This.HasProp("ModernCardPanels") && This.ModernCardPanels.Has(PageKey)) {
            for _, Panel in This.ModernCardPanels[PageKey]
                This.SendControlToBack(Panel)
        }

        for Key, Button in This.ModernNavButtons {
            Button.Text := (Key = PageKey ? "●  " : "    ") This.ModernNavLabels[Key]
            Button.Opt("+Background" (Key = PageKey ? This.ModernAccentColor : This.ModernSidebarColor))
            Button.SetFont("c" (Key = PageKey ? "17191C" : This.ModernForegroundColor), "Segoe UI")
        }
    }

    ;This Function creates all Settings controls for the Global Settings Button
    Global_Settings(visible?) {
        This.S_Gui.Controls.Global_Settings := []
        This.S_Gui.SetFont("s10 w400")
        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("GroupBox", "x20 y80 h320 w560", Tr("global.general_group"))
        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Text", "xp+15 yp+20 Section", Tr("common.language"))
        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Text", "xs y+15", Tr("global.interface_theme"))
        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Text", "xs y+15", Tr("global.suspend_hotkeys"))
        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Text", "xs y+15", Tr("global.hotkey_scope"))
        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Text", "xs y+15", Tr("global.thumbnail_background"))
        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Text", "xs y+15", Tr("global.thumbnail_location"))
        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Text", "xs y+15", Tr("global.thumbnail_snap"))
        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Text", "xs y+15", Tr("global.thumbnail_snap_distance"))
        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Text", "xs y+15", Tr("global.minimize_delay"))

        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("DDL", "xs+290 ys-3 w180 Section vLanguage Choose" (This.Language = "de" ? 1 : 2), [Tr("common.german"), Tr("common.english")])
        This.S_Gui["Language"].OnEvent("Change", (obj, *) => gSettings_EventHandler(obj))
        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("DDL", "xp y+5 w230 vInterfaceTheme Choose" This.InterfaceThemeIndex(), This.InterfaceThemeLabels())
        This.S_Gui["InterfaceTheme"].OnEvent("Change", ObjBindMethod(This, "SwitchInterfaceTheme"))
        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Edit", "xp y+5 w150 vSuspend_Hotkeys_Hotkey", This.Suspend_Hotkeys_Hotkey)
        This.S_Gui["Suspend_Hotkeys_Hotkey"].OnEvent("Change", (obj, *) => gSettings_EventHandler(obj))
        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("DDL", "xp y+5 w230 vTTT vHotkey_Scoope Choose" (This.Global_Hotkeys ? 1 : 2), [Tr("global.scope_global"), Tr("global.scope_eve")])
        This.S_Gui["Hotkey_Scoope"].OnEvent("Change", (obj, *) => gSettings_EventHandler(obj))

        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Edit", "xp y+5 w120 section vThumbnailBackgroundColor", This.ThumbnailBackgroundColor)
        BackgroundColorButton := This.S_Gui.Add("Button", "x+5 yp-3 w105", Tr("common.choose_color"))
        This.S_Gui.Controls.Global_Settings.Push BackgroundColorButton
        BackgroundColorButton.OnEvent("Click", (*) => This.ChooseSingleColor("ThumbnailBackgroundColor"))
        This.S_Gui["ThumbnailBackgroundColor"].OnEvent("Change", (obj, *) => gSettings_EventHandler(obj))

        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Text", "xs+2 y+17 section", "x:")
        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Edit", "x+5 y+-18 w40 vThumbnailStartLocationx", This.ThumbnailStartLocation["x"])
        This.S_Gui["ThumbnailStartLocationx"].OnEvent("Change", (obj, *) => gSettings_EventHandler(obj))

        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Text", "x+8 ys ", "y:")
        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Edit", "x+5 y+-18 w40 vThumbnailStartLocationy", This.ThumbnailStartLocation["y"])
        This.S_Gui["ThumbnailStartLocationy"].OnEvent("Change", (obj, *) => gSettings_EventHandler(obj))

        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Text", "x+8 ys ", "w:")
        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Edit", "x+5 y+-18 w40 vThumbnailStartLocationwidth", This.ThumbnailStartLocation["width"])
        This.S_Gui["ThumbnailStartLocationwidth"].OnEvent("Change", (obj, *) => gSettings_EventHandler(obj))

        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Text", "x+8 ys ", "h:")
        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Edit", "x+5 y+-18 w40 vThumbnailStartLocationheight", This.ThumbnailStartLocation["height"])
        This.S_Gui["ThumbnailStartLocationheight"].OnEvent("Change", (obj, *) => gSettings_EventHandler(obj))

        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Radio", "xs y+10 w50 vThumbnailSnapOn Checked" This.ThumbnailSnap, Tr("common.on"))
        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Radio", " xp+65 yp w50 vThumbnailSnapOff Checked" (This.ThumbnailSnap ? 0 : 1), Tr("common.off"))
        This.S_Gui["ThumbnailSnapOn"].OnEvent("Click", (obj, *) => gSettings_EventHandler(obj))
        This.S_Gui["ThumbnailSnapOff"].OnEvent("Click", (obj, *) => gSettings_EventHandler(obj))

        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Text", "xs y+15 ", Tr("common.pixel") ":")
        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Edit", "x+5 y+-18 w40 vThumbnailSnap_Distance", This.ThumbnailSnap_Distance)
        This.S_Gui["ThumbnailSnap_Distance"].OnEvent("Change", (obj, *) => gSettings_EventHandler(obj))

        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Text", "xs y+9 ", Tr("common.milliseconds") ":")
        This.S_Gui.Controls.Global_Settings.Push This.S_Gui.Add("Edit", "xp+80 yp-3 w40 vMinimizeclients_Delay", This.Minimizeclients_Delay)
        This.S_Gui["Minimizeclients_Delay"].OnEvent("Change", (obj, *) => gSettings_EventHandler(obj))

        gSettings_EventHandler(obj) {
            if (obj.name = "Language") {
                This.Language := obj.value = 1 ? "de" : "en"
                This.SaveJsonToFile()
                SetTimer((*) => Reload(), -200)
            }
            else if (obj.name = "Suspend_Hotkeys_Hotkey") {
                This.Suspend_Hotkeys_Hotkey := Trim(obj.value, "`n ")
                This.NeedRestart := 1
            }
            else if (obj.name = "Hotkey_Scoope") {
                This.Global_Hotkeys := (obj.value = 1 ? 1 : 0)
                This.NeedRestart := 1
            }
            else if (obj.name = "ThumbnailBackgroundColor") {
                This.ThumbnailBackgroundColor := obj.value
                This.NeedRestart := 1
            }
            else if (obj.name = "ThumbnailStartLocationx") {
                This.ThumbnailStartLocation["x"] := obj.value
            }
            else if (obj.name = "ThumbnailStartLocationy") {
                This.ThumbnailStartLocation["y"] := obj.value
            }
            else if (obj.name = "ThumbnailStartLocationwidth") {
                This.ThumbnailStartLocation["width"] := obj.value
                SetTimer(This.ApplyThumbnailStartSize_Delay_Timer, -250)
            }
            else if (obj.name = "ThumbnailStartLocationheight") {
                This.ThumbnailStartLocation["height"] := obj.value
                SetTimer(This.ApplyThumbnailStartSize_Delay_Timer, -250)
            }
            else if (obj.name = "ThumbnailSnapOn") {
                This.ThumbnailSnap := 1
            }
            else if (obj.name = "ThumbnailSnapOff") {
                This.ThumbnailSnap := 0
            }
            else if (obj.name = "ThumbnailSnap_Distance") {
                This.ThumbnailSnap_Distance := obj.value
            }
            else if (obj.name = "Minimizeclients_Delay") {
                This.Minimizeclients_Delay := obj.value
                This.NeedRestart := 1
            }
            SetTimer(This.Save_Settings_Delay_Timer, -200)
        }
    }

    ChooseSingleColor(ControlName) {
        ColorControl := This.S_Gui[ControlName]
        SelectedColor := ColorPicker.Choose(This.S_Gui.Hwnd, ColorControl.Value)
        if (SelectedColor = "")
            return

        ColorControl.Value := SelectedColor
        switch ControlName {
            case "ThumbnailBackgroundColor":
                This.ThumbnailBackgroundColor := SelectedColor
                This.NeedRestart := 1
            case "ThumbnailTextColor":
                This.ThumbnailTextColor := SelectedColor
                This.ScheduleProfileApply()
            case "ClientHighligtColor":
                This.ClientHighligtColor := SelectedColor
                This.ScheduleProfileApply()
            case "InactiveClientBorderColor":
                This.InactiveClientBorderColor := SelectedColor
                This.ScheduleProfileApply()
        }
        SetTimer(This.Save_Settings_Delay_Timer, -200)
    }

    ChooseListColor(ControlName) {
        ColorControl := This.S_Gui[ControlName]
        if (Trim(ColorControl.Value) = "") {
            MsgBox(Tr("colors.no_client"), AppInfo.Name, "Iconi")
            return
        }

        Rows := StrSplit(ColorControl.Value, "`n")
        SelectedRow := SendMessage(0xC9, -1, 0, ColorControl.Hwnd) + 1
        if (SelectedRow < 1 || SelectedRow > Rows.Length)
            SelectedRow := 1
        InitialColor := RegExReplace(Trim(Rows[SelectedRow], "`r`n "), "^\d+\s*:\s*", "")
        SelectedColor := ColorPicker.Choose(This.S_Gui.Hwnd, InitialColor)
        if (SelectedColor = "")
            return

        Rows[SelectedRow] := SelectedRow ": " SelectedColor
        NewValue := ""
        for Index, Row in Rows
            NewValue .= (Index > 1 ? "`n" : "") Row

        switch ControlName {
            case "CBorderColor":
                This.CustomColors_AllBColors := NewValue
                ColorControl.Value := This.CustomColors_AllBColors
            case "CTextColor":
                This.CustomColors_AllTColors := NewValue
                ColorControl.Value := This.CustomColors_AllTColors
            case "IABorderColor":
                This.CustomColors_IABorder_Colors := NewValue
                ColorControl.Value := This.CustomColors_IABorder_Colors
        }
        This.ScheduleProfileApply()
    }

    ;This Function creates all Settings controls for the Profile Settings Button
    Profile_Settings(visible?) {
        This.S_Gui.Controls.Profile_Settings := [], This.S_Gui.Controls.Profile_Settings.PsDDL := Map()

        ;This.S_Gui.Controls.Profile_Settings.Push This.S_Gui.Add("GroupBox", "x20 y80 h200 w500 vPSGroupBox", "")
        This.S_Gui.Controls.Profile_Settings.Push This.S_Gui.Add("Text", "x58 y95", Tr("profile.select"))

        This.SelectProfile_DDL := This.S_Gui.Add("DDL", "w200 xp-30 yp+18 Section vSelectedProfile", This.Profiles_to_Array())
        This.S_Gui.Controls.Profile_Settings.Push This.SelectProfile_DDL
        This.SelectProfile_DDL.Choose(This.LastUsedProfile)
        This.SelectProfile_DDL.OnEvent("Change", (obj,*) => This._Button_Load(Obj))

        Button_Delete := This.S_Gui.Add("Button", "w80 xs+340 yp-2 ", Tr("common.delete"))
        This.S_Gui.Controls.Profile_Settings.Push Button_Delete
        Button_Delete.OnEvent("Click", ObjBindMethod(This, "Delete_Profile"))

        Button_New := This.S_Gui.Add("Button", "wp x+5 yp ", Tr("common.new"))
        This.S_Gui.Controls.Profile_Settings.Push Button_New
        Button_New.OnEvent("Click", ObjBindMethod(This, "Create_Profile"))

        ;*Seperator line
        This.Seperator_text := This.S_Gui.Add("Text", "xs+15 y+5 w460 h2 +0x10")
        This.S_Gui.Controls.Profile_Settings.Push This.Seperator_text

        This.S_Gui.Controls.Profile_Settings.Push This.S_Gui.Add("Text", "xp+175 y+5", Tr("profile.settings"))

        This.ProfilePropKeys := This._ProfileProps
        ProfilePropLabels := []
        for ProfilePropKey in This.ProfilePropKeys
            ProfilePropLabels.Push(This.ProfileSectionLabel(ProfilePropKey))
        This.Seetings_DDL := This.S_Gui.Add("DDL", "w240 xp-65 y+5 vSeetings_Props", ProfilePropLabels)
        This.Seetings_DDL.Choose(1)
        ;This.Seetings_DDL.OnEvent("Change", ObjBindMethod(This, "ProfileSettings_DDL"))
        This.S_Gui.Controls.Profile_Settings.Push This.Seetings_DDL

        ;*Seperator line
        This.S_Gui.Controls.Profile_Settings.Push This.S_Gui.Add("Text", "x150 yp+30 w260 h2 Section +0x10")

        ;Sets all controls invisible at beginning
        for k, v in This.S_Gui.Controls.Profile_Settings
            v.Visible := 0
    }

    ClientSettings_Ctrl(visible?) {
        This.S_Gui.Controls.Profile_Settings.PsDDL["Client Settings"] := [], ClientSettings := []

        ClientSettings.Push This.S_Gui.Add("GroupBox", "x20 y80 h400 w500 Section", "")
        ClientSettings.Push This.S_Gui.Add("Text", " xp+15 yp+140 Section ", Tr("client.minimize_inactive"))
        ClientSettings.Push This.S_Gui.Add("Text", "xs y+15 ", Tr("client.always_maximize"))
        ClientSettings.Push This.S_Gui.Add("Text", "xs y+15 ", Tr("client.dont_minimize"))

        ClientSettings.Push This.S_Gui.Add("CheckBox", "xs+280 ys Section vMinimizeInactiveClients Checked" This.MinimizeInactiveClients, Tr("common.on_off"))
        This.S_Gui["MinimizeInactiveClients"].OnEvent("Click", (obj, *) => cSettings_EventHandler(obj))

        ClientSettings.Push This.S_Gui.Add("CheckBox", "xs y+15 vAlwaysMaximize Checked" This.AlwaysMaximize, Tr("common.on_off"))
        This.S_Gui["AlwaysMaximize"].OnEvent("Click", (obj, *) => cSettings_EventHandler(obj))

        ClientSettings.Push This.S_Gui.Add("Edit", "xs y+15 w220 h180 vDont_Minimize_Clients -Wrap", This.Dont_Minimize_List())
        This.S_Gui["Dont_Minimize_Clients"].OnEvent("Change", (obj, *) => cSettings_EventHandler(obj))

        ;Pulls the GUI Object into the Map
        This.S_Gui.Controls.Profile_Settings.PsDDL["Client Settings"] := ClientSettings

        for k, v in This.S_Gui.Controls.Profile_Settings.PsDDL["Client Settings"]
            v.Visible := 0

        cSettings_EventHandler(obj) {
            if (obj.name = "MinimizeInactiveClients") {
                This.MinimizeInactiveClients := obj.value
            }
            else if (obj.name = "AlwaysMaximize") {
                This.AlwaysMaximize := obj.value
            }
            else if (obj.name = "TrackClientPossitions") {
                This.TrackClientPossitions := obj.value
            }
            else if (obj.name = "Dont_Minimize_Clients") {
                This.Dont_Minimize_Clients := obj.value
            }
            This.ScheduleProfileApply()
        }
    }

    ; User defined colors per Client
    Custom_ColorsCtrl() {
        This.S_Gui.Controls.Profile_Settings.PsDDL["Custom Colors"] := [], CustomColors := []
        CustomColors.Push This.S_Gui.Add("GroupBox", "x20 y80 h480 w565 Section", "")

        CustomColors.Push This.S_Gui.Add("Text", " xp+25 yp+140 Section ", Tr("colors.active"))
        CustomColors.Push This.S_Gui.Add("Text", " x35 yp+40  ", Tr("colors.character"))
        CustomColors.Push This.S_Gui.Add("Text", " xp+155 yp ", Tr("colors.active_border"))
        CustomColors.Push This.S_Gui.Add("Text", " xp+135 yp ", Tr("colors.text"))
        CustomColors.Push This.S_Gui.Add("Text", " xp+125 yp ", Tr("colors.inactive_border"))

        CustomColors.Push This.S_Gui.Add("CheckBox", " xs+230 ys vCcoloractive Checked" This.CustomColorsActive, Tr("common.on_off"))
        This.S_Gui["Ccoloractive"].OnEvent("Click", (obj, *) => Cclors_Eventhandler(obj))

        CustomColors.Push This.S_Gui.Add("Edit", " x30 yp+60 w150 h250 -Wrap vCchars", This.CustomColors_AllCharNames)
        This.S_Gui["Cchars"].OnEvent("Change", (obj, *) => Cclors_Eventhandler(obj))

        CustomColors.Push This.S_Gui.Add("Edit", " x+10 yp w120 hp -Wrap vCBorderColor", This.CustomColors_AllBColors)
        This.S_Gui["CBorderColor"].OnEvent("Change", (obj, *) => Cclors_Eventhandler(obj))

        CustomColors.Push This.S_Gui.Add("Edit", " x+10 yp wp hp -Wrap vCTextColor", This.CustomColors_AllTColors)
        This.S_Gui["CTextColor"].OnEvent("Change", (obj, *) => Cclors_Eventhandler(obj))

        CustomColors.Push This.S_Gui.Add("Edit", " x+10 yp wp hp -Wrap vIABorderColor", This.CustomColors_IABorder_Colors)
        This.S_Gui["IABorderColor"].OnEvent("Change", (obj, *) => Cclors_Eventhandler(obj))

        BorderPaletteButton := This.S_Gui.Add("Button", "x190 y+5 w120 h25", Tr("colors.choose_row"))
        BorderPaletteButton.OnEvent("Click", (*) => This.ChooseListColor("CBorderColor"))
        CustomColors.Push BorderPaletteButton
        TextPaletteButton := This.S_Gui.Add("Button", "x+10 yp wp hp", Tr("colors.choose_row"))
        TextPaletteButton.OnEvent("Click", (*) => This.ChooseListColor("CTextColor"))
        CustomColors.Push TextPaletteButton
        InactivePaletteButton := This.S_Gui.Add("Button", "x+10 yp wp hp", Tr("colors.choose_row"))
        InactivePaletteButton.OnEvent("Click", (*) => This.ChooseListColor("IABorderColor"))
        CustomColors.Push InactivePaletteButton

        This.S_Gui.Controls.Profile_Settings.PsDDL["Custom Colors"] := CustomColors
        for k, v in This.S_Gui.Controls.Profile_Settings.PsDDL["Custom Colors"]
            v.Visible := 0

        Cclors_Eventhandler(obj) {
            if (obj.Name = "Ccoloractive") {
                This.CustomColorsActive := obj.value
            }
            else if (obj.Name = "Cchars") {
                indexOld := This.IndexcChars
                This.CustomColors_AllCharNames := obj.value
                if (indexOld < This.IndexcChars) {
                    obj.value := This.CustomColors_AllCharNames
                    ControlSend("^{End}", obj.Hwnd)
                }
            }
            else if (obj.Name = "CBorderColor") {
                indexOld := This.IndexcBorder
                This.CustomColors_AllBColors := obj.value
                if (indexOld < This.IndexcBorder) {
                    obj.value := This.CustomColors_AllBColors
                    ControlSend("^{End}", obj.Hwnd)
                }
            }
            else if (obj.Name = "CTextColor") {
                indexOld := This.IndexcText
                This.CustomColors_AllTColors := obj.value
                if (indexOld < This.IndexcText) {
                    obj.value := This.CustomColors_AllTColors
                    ControlSend("^{End}", obj.Hwnd)
                }
            }            
            else if (obj.Name = "IABorderColor") {
                indexOld := This.IndexcText
                This.CustomColors_IABorder_Colors := obj.value
                if (indexOld < This.IndexcText) {
                    obj.value := This.CustomColors_IABorder_Colors
                    ControlSend("^{End}", obj.Hwnd)
                }
            }            
            This.ScheduleProfileApply()
        }
    }

    Hotkey_GroupsCtrl() {
        This.S_Gui.Controls.Profile_Settings.PsDDL["Hotkey Groups"] := [], Hotkey_Groups := []

        Hotkey_Groups.Push This.S_Gui.Add("GroupBox", "x20 y80 h440 w500 Section", "")
        Hotkey_Groups.Push This.S_Gui.Add("Text", "x58 yp+130", Tr("groups.select"))
        ddl := This.S_Gui.Add("DropDownList", " xp-30 yp+18 w180 vHotkeyGroupDDL", This.GetGroupList())
        Hotkey_Groups.Push ddl
        This.S_Gui["HotkeyGroupDDL"].OnEvent("Change", (*) => SetEditText(ddl, EditBox, HKForwards, HKBackwards))

        DeleteButton := This.S_Gui.Add("Button", "xs+340 yp-1 w80", Tr("common.delete"))
        NewButton := This.S_Gui.Add("Button", "x+5 yp w80", Tr("common.new"))
        DeleteButton.OnEvent("Click", (*) => Delete_Group(ddl, HKForwards, HKBackwards, EditBox))
        NewButton.OnEvent("Click", (*) => CreateNewGroup(ddl, HKForwards, HKBackwards, EditBox))

        Hotkey_Groups.Push DeleteButton
        Hotkey_Groups.Push NewButton

        EditBox := This.S_Gui.Add("Edit", "xs+8 y275 w250 h225 -Wrap +HScroll Disabled vHKCharlist")
        Hotkey_Groups.Push EditBox
        This.S_Gui["HKCharlist"].OnEvent("Change", (obj, *) => SaveHKGroupList(obj))

        Hotkey_Groups.Push This.S_Gui.Add("Text", "xs300 yp20", Tr("groups.forward"))
        HKForwards := This.S_Gui.Add("Edit", "xp yp+20 w150 Disabled vForwardsKey")
        Hotkey_Groups.Push HKForwards
        This.S_Gui["ForwardsKey"].OnEvent("Change", (obj, *) => SaveHKGroupList(obj))

        Hotkey_Groups.Push This.S_Gui.Add("Text", "xp yp50", Tr("groups.backward"))
        HKBackwards := This.S_Gui.Add("Edit", "xp yp+20 w150 Disabled vBackwardsdKey")
        Hotkey_Groups.Push HKBackwards
        This.S_Gui["BackwardsdKey"].OnEvent("Change", (obj, *) => SaveHKGroupList(obj))

        This.S_Gui.Controls.Profile_Settings.PsDDL["Hotkey Groups"] := Hotkey_Groups
        for k, v in This.S_Gui.Controls.Profile_Settings.PsDDL["Hotkey Groups"]
            v.Visible := 0


        CreateNewGroup(ddlObj, ForwardHKObj, BackwardHKObj, EditObj) {
            ArrayIndex := 0
            Obj := InputBox(Tr("groups.enter_name"), Tr("groups.create_title"), "w260 h110")
            if (Obj.Result != "OK")
                return
            This.Hotkey_Groups[Obj.value] := []
            ddlObj.Delete()
            ddlObj.Add(This.GetGroupList())
            for k in This.Hotkey_Groups {
                if k = Obj.value {
                    ArrayIndex := A_Index
                    break
                }
            }
            EditObj.value := "", ForwardHKObj.value := "", BackwardHKObj.value := ""
            ForwardHKObj.Enabled := 1, BackwardHKObj.Enabled := 1, EditObj.Enabled := 1
            ddlObj.Choose(ArrayIndex)
            This.ScheduleProfileApply()
        }

        Delete_Group(ddlObj, ForwardHKObj, BackwardHKObj, EditObj) {
            if (ddlObj.Text != "" && This.Hotkey_Groups.Has(ddlObj.Text))
                This.Hotkey_Groups.Delete(ddlObj.Text)

            ddlObj.Delete()
            ddlObj.Add(This.GetGroupList())
            ForwardHKObj.value := "", BackwardHKObj.value := "", EditObj.value := ""
            ForwardHKObj.Enabled := 0, BackwardHKObj.Enabled := 0, EditObj.Enabled := 0
            This.ScheduleProfileApply()
        }

        SetEditText(ddlObj, EditObj, ForwardHKObj?, BackwardHKObj?) {
            text := ""
            if (ddlObj.Text != "" && This.Hotkey_Groups.Has(ddlObj.Text)) {
                for index, Names in This.Hotkey_Groups[ddlObj.Text]["Characters"] {
                    text .= Names "`n"
                }
                EditObj.value := text, EditObj.Enabled := 1
                ForwardHKObj.value := This.Hotkey_Groups[ddlObj.Text]["ForwardsHotkey"], ForwardHKObj.Enabled := 1
                BackwardHKObj.value := This.Hotkey_Groups[ddlObj.Text]["BackwardsHotkey"], BackwardHKObj.Enabled := 1
            }
        }

        SaveHKGroupList(obj) {
            if (obj.Name = "HKCharlist" && ddl.Text != "") {
                Arr := []
                for k, v in StrSplit(obj.value, "`n") {
                    Chars := Trim(v, "`n ")
                    if (Chars = "")
                        continue
                    Arr.Push(Chars)
                }
                This.Hotkey_Groups[ddl.Text]["Characters"] := Arr
            }
            else if (obj.Name = "ForwardsKey" && ddl.Text != "") {
                This.Hotkey_Groups[ddl.Text]["ForwardsHotkey"] := Trim(obj.value, "`n ")
            }
            else if (obj.Name = "BackwardsdKey" && ddl.Text != "") {
                This.Hotkey_Groups[ddl.Text]["BackwardsHotkey"] := Trim(obj.value, "`n ")
            }
            This.ScheduleProfileApply()
        }
    }


    HotkeysCtrl() {

        This.S_Gui.Controls.Profile_Settings.PsDDL["Hotkeys"] := [], Hotkeys := []
        Hotkeys.Push This.S_Gui.Add("GroupBox", "x20 y80 h530 w500 Section", "")

        Charlist := "", Hklist := ""
        for index, value in This._Hotkeys {
            for name, hotkey in value {
                Charlist .= name "`n"
                Hklist .= hotkey "`n"
            }
        }

        Hotkeys.Push This.S_Gui.Add("Text", " x115 yp+130 section", Tr("hotkeys.character"))
        HKCharList := This.S_Gui.Add("Edit", " xp-30 yp20 w180 h350 -Wrap vHotkeyCharList", Charlist)
        Hotkeys.Push HKCharList
        HKCharList.OnEvent("Change", (obj, *) => EventHandler(obj))

        Hotkeys.Push This.S_Gui.Add("Text", " xs+210 ys", Tr("hotkeys.hotkey"))
        HKKeylist := This.S_Gui.Add("Edit", " xp-50 yp20 w180 h350 -Wrap vHotkeyList", Hklist)
        Hotkeys.Push HKKeylist
        HKKeylist.OnEvent("Change", (obj, *) => EventHandler(obj))

        This.S_Gui.Controls.Profile_Settings.PsDDL["Hotkeys"] := Hotkeys
        for k, v in This.S_Gui.Controls.Profile_Settings.PsDDL["Hotkeys"]
            v.Visible := 0

        ;Parse All hotkeys to a Array on value change
        EventHandler(obj) {
            tempvar := []
            ListChars := StrSplit(This.S_Gui["HotkeyCharList"].value, "`n"), ListHotkeys := StrSplit(This.S_Gui["HotkeyList"].value, "`n")
            for k, v in ListChars {
                chars := "", keys := ""
                if (A_Index <= ListChars.Length) {
                    chars := Trim(ListChars[A_Index], "`n ")
                }
                if (A_Index <= ListHotkeys.Length) {
                    keys := Trim(ListHotkeys[A_Index], "`n ")
                }
                if (A_Index > ListHotkeys.Length) {
                    keys := ""
                }
                if (chars = "")
                    continue
                tempvar.Push Map(chars, keys)
            }
            this._Hotkeys := tempvar
            This.ScheduleProfileApply()
        }

    }

    ThumbnailSettings_Ctrl() {
        This.S_Gui.Controls.Profile_Settings.PsDDL["Thumbnail Settings"] := [], ThumbnailSettings := []

        ThumbnailSettings.Push This.S_Gui.Add("GroupBox", "x20 y80 h580 w565 Section", "")

        ; A fixed two-column grid keeps every choice aligned. The previous relative
        ; placement shifted numeric fields behind their px/% labels and accumulated
        ; vertical offsets from controls with different heights.
        LabelX := 35
        ControlX := 335
        RowY := 220
        RowStep := 28

        ThumbnailSettings.Push This.S_Gui.Add("Text", "x" LabelX " y" RowY " w285", Tr("thumbnail.show_text"))
        ThumbnailSettings.Push This.S_Gui.Add("CheckBox", "x" ControlX " y" RowY " vShowThumbnailTextOverlay Checked" This.ShowThumbnailTextOverlay, Tr("common.on_off"))
        This.S_Gui["ShowThumbnailTextOverlay"].OnEvent("Click", (obj, *) => ThumbnailSettings_EventHandler(obj))

        RowY += RowStep
        ThumbnailSettings.Push This.S_Gui.Add("Text", "x" LabelX " y" RowY " w285", Tr("thumbnail.text_color"))
        ThumbnailSettings.Push This.S_Gui.Add("Edit", "x" ControlX " y" RowY " w120 vThumbnailTextColor -Wrap", This.ThumbnailTextColor)
        ThumbnailTextColorButton := This.S_Gui.Add("Button", "x" (ControlX + 125) " y" RowY " w105", Tr("common.choose_color"))
        ThumbnailTextColorButton.OnEvent("Click", (*) => This.ChooseSingleColor("ThumbnailTextColor"))
        ThumbnailSettings.Push ThumbnailTextColorButton
        This.S_Gui["ThumbnailTextColor"].OnEvent("Change", (obj, *) => ThumbnailSettings_EventHandler(obj))

        RowY += RowStep
        ThumbnailSettings.Push This.S_Gui.Add("Text", "x" LabelX " y" RowY " w285", Tr("thumbnail.text_size"))
        ThumbnailSettings.Push This.S_Gui.Add("Edit", "x" ControlX " y" RowY " w40 vThumbnailTextSize -Wrap", This.ThumbnailTextSize)
        This.S_Gui["ThumbnailTextSize"].OnEvent("Change", (obj, *) => ThumbnailSettings_EventHandler(obj))

        RowY += RowStep
        ThumbnailSettings.Push This.S_Gui.Add("Text", "x" LabelX " y" RowY " w285", Tr("thumbnail.text_font"))
        ThumbnailSettings.Push This.S_Gui.Add("Edit", "x" ControlX " y" RowY " w230 vThumbnailTextFont -Wrap", This.ThumbnailTextFont)
        This.S_Gui["ThumbnailTextFont"].OnEvent("Change", (obj, *) => ThumbnailSettings_EventHandler(obj))

        RowY += RowStep
        ThumbnailSettings.Push This.S_Gui.Add("Text", "x" LabelX " y" RowY " w285", Tr("thumbnail.text_margins"))
        ThumbnailSettings.Push This.S_Gui.Add("Edit", "x" ControlX " y" RowY " w40 vThumbnailTextMarginsx -Wrap", This.ThumbnailTextMargins["x"])
        ThumbnailSettings.Push This.S_Gui.Add("Text", "x" (ControlX + 46) " y" RowY " w75", "px " Tr("common.width"))
        This.S_Gui["ThumbnailTextMarginsx"].OnEvent("Change", (obj, *) => ThumbnailSettings_EventHandler(obj))
        ThumbnailSettings.Push This.S_Gui.Add("Edit", "x" (ControlX + 130) " y" RowY " w40 vThumbnailTextMarginsy -Wrap", This.ThumbnailTextMargins["y"])
        ThumbnailSettings.Push This.S_Gui.Add("Text", "x" (ControlX + 176) " y" RowY " w65", "px " Tr("common.height"))
        This.S_Gui["ThumbnailTextMarginsy"].OnEvent("Change", (obj, *) => ThumbnailSettings_EventHandler(obj))

        RowY += RowStep
        ThumbnailSettings.Push This.S_Gui.Add("Text", "x" LabelX " y" RowY " w285", Tr("thumbnail.highlight_color"))
        ThumbnailSettings.Push This.S_Gui.Add("Edit", "x" ControlX " y" RowY " w120 vClientHighligtColor -Wrap", This.ClientHighligtColor)
        HighlightColorButton := This.S_Gui.Add("Button", "x" (ControlX + 125) " y" RowY " w105", Tr("common.choose_color"))
        HighlightColorButton.OnEvent("Click", (*) => This.ChooseSingleColor("ClientHighligtColor"))
        ThumbnailSettings.Push HighlightColorButton
        This.S_Gui["ClientHighligtColor"].OnEvent("Change", (obj, *) => ThumbnailSettings_EventHandler(obj))

        RowY += RowStep
        ThumbnailSettings.Push This.S_Gui.Add("Text", "x" LabelX " y" RowY " w285", Tr("thumbnail.highlight_thickness"))
        ThumbnailSettings.Push This.S_Gui.Add("Edit", "x" ControlX " y" RowY " w40 vClientHighligtBorderthickness -Wrap", This.ClientHighligtBorderthickness)
        ThumbnailSettings.Push This.S_Gui.Add("Text", "x" (ControlX + 46) " y" RowY, "px")
        This.S_Gui["ClientHighligtBorderthickness"].OnEvent("Change", (obj, *) => ThumbnailSettings_EventHandler(obj))

        RowY += RowStep
        ThumbnailSettings.Push This.S_Gui.Add("Text", "x" LabelX " y" RowY " w285", Tr("thumbnail.show_highlight"))
        ThumbnailSettings.Push This.S_Gui.Add("CheckBox", "x" ControlX " y" RowY " vShowClientHighlightBorder Checked" This.ShowClientHighlightBorder, Tr("common.on_off"))
        This.S_Gui["ShowClientHighlightBorder"].OnEvent("Click", (obj, *) => ThumbnailSettings_EventHandler(obj))

        RowY += RowStep
        ThumbnailSettings.Push This.S_Gui.Add("Text", "x" LabelX " y" RowY " w285", Tr("thumbnail.hide_lost_focus"))
        ThumbnailSettings.Push This.S_Gui.Add("CheckBox", "x" ControlX " y" RowY " vHideThumbnailsOnLostFocus Checked" This.HideThumbnailsOnLostFocus, Tr("common.on_off"))
        This.S_Gui["HideThumbnailsOnLostFocus"].OnEvent("Click", (obj, *) => ThumbnailSettings_EventHandler(obj))

        RowY += RowStep
        ThumbnailSettings.Push This.S_Gui.Add("Text", "x" LabelX " y" RowY " w285", Tr("thumbnail.opacity"))
        ThumbnailSettings.Push This.S_Gui.Add("Edit", "x" ControlX " y" RowY " w40 vThumbnailOpacity -Wrap", IntegerToPercentage(This.ThumbnailOpacity))
        ThumbnailSettings.Push This.S_Gui.Add("Text", "x" (ControlX + 46) " y" RowY, "%")
        This.S_Gui["ThumbnailOpacity"].OnEvent("Change", (obj, *) => ThumbnailSettings_EventHandler(obj))

        RowY += RowStep
        ThumbnailSettings.Push This.S_Gui.Add("Text", "x" LabelX " y" RowY " w285", Tr("thumbnail.always_on_top"))
        ThumbnailSettings.Push This.S_Gui.Add("CheckBox", "x" ControlX " y" RowY " vShowThumbnailsAlwaysOnTop Checked" This.ShowThumbnailsAlwaysOnTop, Tr("common.on_off"))
        This.S_Gui["ShowThumbnailsAlwaysOnTop"].OnEvent("Click", (obj, *) => ThumbnailSettings_EventHandler(obj))

        RowY += RowStep
        ThumbnailSettings.Push This.S_Gui.Add("Text", "x" LabelX " y" RowY " w285", Tr("thumbnail.lock_positions"))
        ThumbnailSettings.Push This.S_Gui.Add("CheckBox", "x" ControlX " y" RowY " vLockThumbnailPositions Checked" This.LockThumbnailPositions, Tr("common.on_off"))
        This.S_Gui["LockThumbnailPositions"].OnEvent("Click", (obj, *) => ThumbnailSettings_EventHandler(obj))

        RowY += RowStep
        ThumbnailSettings.Push This.S_Gui.Add("Text", "x" LabelX " y" RowY " w285", Tr("thumbnail.show_all_borders"))
        ThumbnailSettings.Push This.S_Gui.Add("CheckBox", "x" ControlX " y" RowY " vShowAllBorders Checked" This.ShowAllColoredBorders, Tr("common.on_off"))
        This.S_Gui["ShowAllBorders"].OnEvent("Click", (obj, *) => ThumbnailSettings_EventHandler(obj))

        RowY += RowStep
        ThumbnailSettings.Push This.S_Gui.Add("Text", "x" LabelX " y" RowY " w285", Tr("thumbnail.inactive_thickness"))
        ThumbnailSettings.Push This.S_Gui.Add("Edit", "x" ControlX " y" RowY " w40 vInactiveClientBorderthickness -Wrap", This.InactiveClientBorderthickness)
        ThumbnailSettings.Push This.S_Gui.Add("Text", "x" (ControlX + 46) " y" RowY, "px")
        This.S_Gui["InactiveClientBorderthickness"].OnEvent("Change", (obj, *) => ThumbnailSettings_EventHandler(obj))

        RowY += RowStep
        ThumbnailSettings.Push This.S_Gui.Add("Text", "x" LabelX " y" RowY " w285", Tr("thumbnail.inactive_color"))
        ThumbnailSettings.Push This.S_Gui.Add("Edit", "x" ControlX " y" RowY " w120 vInactiveClientBorderColor -Wrap", This.InactiveClientBorderColor)
        InactiveColorButton := This.S_Gui.Add("Button", "x" (ControlX + 125) " y" RowY " w105 vInactiveClientBorderColorPicker", Tr("common.choose_color"))
        InactiveColorButton.OnEvent("Click", (*) => This.ChooseSingleColor("InactiveClientBorderColor"))
        ThumbnailSettings.Push InactiveColorButton
        This.S_Gui["InactiveClientBorderColor"].OnEvent("Change", (obj, *) => ThumbnailSettings_EventHandler(obj))

        This.S_Gui.Controls.Profile_Settings.PsDDL["Thumbnail Settings"] := ThumbnailSettings
        for k, v in This.S_Gui.Controls.Profile_Settings.PsDDL["Thumbnail Settings"] {
            v.Visible := 0
        }

        ;Parse All hotkeys to a Array on value change
        ThumbnailSettings_EventHandler(obj) {
            if (obj.name = "ShowThumbnailTextOverlay") {
                This.ShowThumbnailTextOverlay := obj.value
            }
            else if (obj.name = "ThumbnailTextColor") {
                This.ThumbnailTextColor := obj.value
            }
            else if (obj.name = "ThumbnailTextSize") {
                This.ThumbnailTextSize := obj.value
            }
            else if (obj.name = "ThumbnailTextFont") {
                This.ThumbnailTextFont := obj.value
            }
            else if (obj.name = "ThumbnailTextMarginsx") {
                This.ThumbnailTextMargins["x"] := obj.value
            }
            else if (obj.name = "ThumbnailTextMarginsy") {
                This.ThumbnailTextMargins["y"] := obj.value
            }
            else if (obj.name = "ClientHighligtColor") {
                This.ClientHighligtColor := obj.value
            }
            else if (obj.name = "ClientHighligtBorderthickness") {
                This.ClientHighligtBorderthickness := obj.value
            }
            else if (obj.name = "ShowClientHighlightBorder") {
                This.ShowClientHighlightBorder := obj.value
            }
            else if (obj.name = "HideThumbnailsOnLostFocus") {
                This.HideThumbnailsOnLostFocus := obj.value
            }
            else if (obj.name = "ThumbnailOpacity") {
                This.ThumbnailOpacity := obj.value
            }
            else if (obj.name = "ShowThumbnailsAlwaysOnTop") {
                This.ShowThumbnailsAlwaysOnTop := obj.value
            }
            else if (obj.name = "LockThumbnailPositions") {
                This.LockThumbnailPositions := obj.value
            }
            else if (obj.Name = "ShowAllBorders") {
                This.ShowAllColoredBorders := obj.value
                This.S_Gui["InactiveClientBorderthickness"].Enabled := This.ShowAllColoredBorders
                This.S_Gui["InactiveClientBorderColor"].Enabled := This.ShowAllColoredBorders
                This.S_Gui["InactiveClientBorderColorPicker"].Enabled := This.ShowAllColoredBorders
            }
            else if (obj.Name = "InactiveClientBorderColor") {
                This.InactiveClientBorderColor := obj.value
            }
            else if (obj.Name = "InactiveClientBorderthickness") {
                This.InactiveClientBorderthickness := obj.value
            }

            This.ScheduleProfileApply()
        }
    }

    Thumbnail_visibilityCtrl() {
        This.S_Gui.Controls.Profile_Settings.PsDDL["Thumbnail Visibility"] := [], Thumbnail_visibility := []

        Thumbnail_visibility.Push This.S_Gui.Add("GroupBox", "x20 y80 h610 w500 Section", "")
        Thumbnail_visibility.Push This.S_Gui.Add("Text", "xp+90 yp+130 w360", Tr("visibility.help"))
        This.Tv_LV := This.S_Gui.Add("ListView", "xp+65 yp+30 w260 Checked -LV0x10 -Multi r20 -Sort vVisibility_List", [Tr("visibility.client")])
        Thumbnail_visibility.Push This.Tv_LV

        for k, v in This.compare_openclients_with_list() {
            if (k != "EVE" || v != "") {
                if This.Thumbnail_visibility.Has(v)
                    This.Tv_LV.Add("Check", v,)
                else
                    This.Tv_LV.Add("", v,)
            }
        }

        This.Tv_LV.ModifyCol(1, 150), This.Tv_LV.ModifyCol(2, 115)
        This.Tv_LV.OnEvent("ItemCheck", ObjBindMethod(This, "_Tv_LVSelectedRow"))

        This.S_Gui.Controls.Profile_Settings.PsDDL["Thumbnail Visibility"] := Thumbnail_visibility
        for k, v in This.S_Gui.Controls.Profile_Settings.PsDDL["Thumbnail Visibility"]
            v.Visible := 0
    }

    On_WM_MOUSEMOVE(wParam, lParam, msg, Hwnd) {
        static PrevHwnd := 0
        if (Hwnd != PrevHwnd) {
            Text := "", ToolTip() ; Turn off any previous tooltip.
            CurrControl := GuiCtrlFromHwnd(Hwnd)
            if CurrControl {
                if !CurrControl.HasProp("ToolTip")
                    return ; No tooltip for this control.
                Text := CurrControl.ToolTip
                SetTimer () => ToolTip(Text), -1000
                SetTimer () => ToolTip(), -4000 ; Remove the tooltip.
            }
            PrevHwnd := Hwnd
        }
    }

    ProfileSectionLabel(ProfileKey) {
        Labels := Map(
            "Client Settings", "section.client_settings",
            "Custom Colors", "section.custom_colors",
            "Hotkey Groups", "section.hotkey_groups",
            "Hotkeys", "section.hotkeys",
            "Thumbnail Settings", "section.thumbnail_settings",
            "Thumbnail Visibility", "section.thumbnail_visibility"
        )
        return Labels.Has(ProfileKey) ? Tr(Labels[ProfileKey]) : ProfileKey
    }

    GetSelectedProfileSection() {
        if (!This.HasProp("ProfilePropKeys") || !This.ProfilePropKeys.Length)
            return ""
        SelectedIndex := This.Seetings_DDL.Value
        if (SelectedIndex < 1 || SelectedIndex > This.ProfilePropKeys.Length)
            return ""
        return This.ProfilePropKeys[SelectedIndex]
    }

    Profiles_to_Array() {
        ll := []
        for k, v in This.Profiles
            ll.Push(k)
        return ll
    }

    Dont_Minimize_List() {
        list := ""
        for k in This.Dont_Minimize_Clients {
            list .= k "`n"
        }
        return list
    }

    _Button_Load(obj?,*) {
        SelectedProfile := This.S_Gui["SelectedProfile"].Text
        if (IsSet(obj) && SelectedProfile != This.LastUsedProfile) {
            ; Store the outgoing profile before switching the property target.
            This.Save_Settings()
            This.AutoSaveClientPositions()
            This.SaveJsonToFile()
            This.LastUsedProfile := SelectedProfile
        }
        This.Refresh_ControlValues()

        if (This.S_Gui["SelectedProfile"].Text = "Default") {
            for k, v in This.S_Gui.Controls.Profile_Settings.PsDDL {
                for _, ob in v {
                    ob.Enabled := 0
                }
            }
        }
        if (IsSet(obj))
            This.ApplyProfileSettings(true, false)
        else
            SetTimer(This.Save_Settings_Delay_Timer, -200)
    }

    Refresh_ControlValues() {
        ; Global Settings
        This.S_Gui["Language"].value := (This.Language = "de" ? 1 : 2)
        This.S_Gui["InterfaceTheme"].value := This.InterfaceThemeIndex()
        This.S_Gui["Suspend_Hotkeys_Hotkey"].value := This.Suspend_Hotkeys_Hotkey
        This.S_Gui["Hotkey_Scoope"].value := (This.Global_Hotkeys ? 1 : 2)
        This.S_Gui["ThumbnailBackgroundColor"].value := This.ThumbnailBackgroundColor
        This.S_Gui["ThumbnailStartLocationx"].value := This.ThumbnailStartLocation["x"]
        This.S_Gui["ThumbnailStartLocationy"].value := This.ThumbnailStartLocation["y"]
        This.S_Gui["ThumbnailStartLocationwidth"].value := This.ThumbnailStartLocation["width"]
        This.S_Gui["ThumbnailStartLocationheight"].value := This.ThumbnailStartLocation["height"]
        This.S_Gui["ThumbnailSnapOn"].value := This.ThumbnailSnap
        This.S_Gui["ThumbnailSnapOff"].value := (This.ThumbnailSnap ? 0 : 1)
        This.S_Gui["ThumbnailSnap_Distance"].value := This.ThumbnailSnap_Distance

        ;Client Settings
        This.S_Gui["MinimizeInactiveClients"].value := This.MinimizeInactiveClients
        This.S_Gui["Minimizeclients_Delay"].value := This.Minimizeclients_Delay
        This.S_Gui["AlwaysMaximize"].value := This.AlwaysMaximize
        This.S_Gui["Dont_Minimize_Clients"].value := This.Dont_Minimize_List()

        ;Custom Colors
        This.S_Gui["Ccoloractive"].value := This.CustomColorsActive
        This.S_Gui["Cchars"].value := This.CustomColors_AllCharNames
        This.S_Gui["CBorderColor"].value := This.CustomColors_AllBColors
        This.S_Gui["CTextColor"].value := This.CustomColors_AllTColors
        This.S_Gui["IABorderColor"].value := This.CustomColors_IABorder_Colors

        ;Hotkey Groups
        This.S_Gui["HotkeyGroupDDL"].Delete()
        This.S_Gui["HotkeyGroupDDL"].Add(This.GetGroupList())
        This.S_Gui["ForwardsKey"].value := "", This.S_Gui["ForwardsKey"].Enabled := 0
        This.S_Gui["BackwardsdKey"].value := "", This.S_Gui["BackwardsdKey"].Enabled := 0
        This.S_Gui["HKCharlist"].value := "", This.S_Gui["HKCharlist"].Enabled := 0

        ;Hotkeys
        Charlist := "", Hklist := ""
        for index, value in This._Hotkeys {
            for name, hotkey in value {
                Charlist .= name "`n"
                Hklist .= hotkey "`n"
            }
        }
        This.S_Gui["HotkeyCharList"].value := Charlist
        This.S_Gui["HotkeyList"].value := Hklist

        ;Thumbnail Settings
        This.S_Gui["ShowThumbnailTextOverlay"].value := This.ShowThumbnailTextOverlay
        This.S_Gui["ThumbnailTextColor"].value := This.ThumbnailTextColor
        This.S_Gui["ThumbnailTextSize"].value := This.ThumbnailTextSize
        This.S_Gui["ThumbnailTextFont"].value := This.ThumbnailTextFont
        This.S_Gui["ThumbnailTextMarginsx"].value := This.ThumbnailTextMargins["x"]
        This.S_Gui["ThumbnailTextMarginsy"].value := This.ThumbnailTextMargins["y"]
        This.S_Gui["ClientHighligtColor"].value := This.ClientHighligtColor
        This.S_Gui["ClientHighligtBorderthickness"].value := This.ClientHighligtBorderthickness
        This.S_Gui["ShowClientHighlightBorder"].value := This.ShowClientHighlightBorder
        This.S_Gui["HideThumbnailsOnLostFocus"].value := This.HideThumbnailsOnLostFocus
        This.S_Gui["ThumbnailOpacity"].value := IntegerToPercentage(This.ThumbnailOpacity)
        This.S_Gui["ShowThumbnailsAlwaysOnTop"].value := This.ShowThumbnailsAlwaysOnTop
        This.S_Gui["LockThumbnailPositions"].value := This.LockThumbnailPositions
        This.S_Gui["ShowAllBorders"].value := This.ShowAllColoredBorders
        This.S_Gui["InactiveClientBorderthickness"].value := This.InactiveClientBorderthickness
        This.S_Gui["InactiveClientBorderColor"].value := This.InactiveClientBorderColor

        ;Thumbnail Visibility
        This.S_Gui["Visibility_List"].Delete()
        for k, v in This.compare_openclients_with_list() {
            if (k != "EVE" || v != "") {
                if This.Thumbnail_visibility.Has(v)
                    This.Tv_LV.Add("Check", v,)
                else
                    This.Tv_LV.Add("", v,)
            }
        }

        for k, v in This.S_Gui.Controls.Profile_Settings.PsDDL {
            for _, ob in v {
                ob.Enabled := 1
            }
            This.S_Gui["HKCharlist"].Enabled := 0
            This.S_Gui["ForwardsKey"].Enabled := 0
            This.S_Gui["BackwardsdKey"].Enabled := 0
        }
        This.S_Gui["InactiveClientBorderthickness"].Enabled := This.ShowAllColoredBorders
        This.S_Gui["InactiveClientBorderColor"].Enabled := This.ShowAllColoredBorders
        This.S_Gui["InactiveClientBorderColorPicker"].Enabled := This.ShowAllColoredBorders
    }


    compare_openclients_with_list() {
        EvENameList := []
        for EveHwnd in This.ThumbWindows.OwnProps() {
            try {
                if title := This.CleanTitle(WinGetTitle("Ahk_Id " EveHwnd) = "") {
                    continue
                }
                EvENameList.Push This.CleanTitle(WinGetTitle("Ahk_Id " EveHwnd))
            }
        }
        return EvENameList
    }


    GetGroupList() {
        List := []
        if (IsObject(This.Hotkey_Groups)) {
            for k in This.Hotkey_Groups {
                List.Push(k)
            }
            return List
        }
        else
            return []
    }
}
;Class End


IntegerToPercentage(integerValue) {
    percentage := (integerValue < 0 ? 0 : integerValue > 255 ? 100 : Round(integerValue * 100 / 255))
    return percentage
}


CompareArrays(arr1, arr2) {
    commonValues := {}

    for _, value in arr1 {
        if (IsInArray(value, arr2))
            commonValues.%value% := 1
        else
            commonValues.%value% := 0
    }

    for _, value in arr2 {
        if (!IsInArray(value, arr1))
            commonValues.%value% := 0
    }

    return commonValues
}

IsInArray(value, arr) {
    for _, item in arr {
        if (item = value)
            return true
    }
    return false
}
