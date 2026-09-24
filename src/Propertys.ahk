

class Propertys extends TrayMenu {


    ;######################
    ;## Script Propertys

    SetThumbnailText[hwnd, *] {
        set {
            if (This.ThumbWindows.HasProp(hwnd)) {
                ;RegExReplace(Value, "(EVE)(?: - )?", "")
                newtext := Value

                for k, v in This.ThumbWindows.%hwnd% {
                    if (k = "Thumbnail" || k = "Border")
                        continue
                    if (k = "TextOverlay") {
                        for chwnd, cobj in v {
                            cobj.Value := newtext
                            ;ControlSetText "New Text Here", cobj
                        }
                    }
                    if (k = "Window")
                        v.Title := newtext
                }
            }
        }
    }

    Profiles => This._JSON["_Profiles"]


    ;######################
    ;## global Settings
    Language {
        get => This._JSON["global_Settings"]["Language"]
        set => This._JSON["global_Settings"]["Language"] := value
    }

    LastNotifiedVersion {
        get => This._JSON["global_Settings"]["LastNotifiedVersion"]
        set => This._JSON["global_Settings"]["LastNotifiedVersion"] := value
    }

    SettingsWindowTitle => Tr("app.settings_title")

    ThumbnailStartLocation[key] {
        get => This._JSON["global_Settings"]["ThumbnailStartLocation"][key]
        set => This._JSON["global_Settings"]["ThumbnailStartLocation"][key] := value


    }

    Minimizeclients_Delay {
        get => This._JSON["global_Settings"]["Minimize_Delay"]
        set => This._JSON["global_Settings"]["Minimize_Delay"] := (value < 50 ? "50" : value)
    }

    Suspend_Hotkeys_Hotkey {
        get => This._JSON["global_Settings"]["Suspend_Hotkeys_Hotkey"]
        set => This._JSON["global_Settings"]["Suspend_Hotkeys_Hotkey"] := value
    }

    ThumbnailBackgroundColor {
        get => convertToHex(This._JSON["global_Settings"]["ThumbnailBackgroundColor"])
        set => This._JSON["global_Settings"]["ThumbnailBackgroundColor"] := convertToHex(value)
    }

    ThumbnailSnap[*] {
        get => This._JSON["global_Settings"]["ThumbnailSnap"]
        set => This._JSON["global_Settings"]["ThumbnailSnap"] := Value
    }

    Global_Hotkeys {
        get => This._JSON["global_Settings"]["Global_Hotkeys"]
        set => This._JSON["global_Settings"]["Global_Hotkeys"] := value
    }

    ThumbnailSnap_Distance {
        get => This._JSON["global_Settings"]["ThumbnailSnap_Distance"]
        set => This._JSON["global_Settings"]["ThumbnailSnap_Distance"] := (value ? value : "20")
    }


    ;########################
    ;## Profile ThumbnailSettings

    ShowAllColoredBorders {
        get => This._JSON["_Profiles"][This.LastUsedProfile]["Thumbnail Settings"]["ShowAllColoredBorders"]
        set => This._JSON["_Profiles"][This.LastUsedProfile]["Thumbnail Settings"]["ShowAllColoredBorders"] := value
    }

    LastUsedProfile {
        get => This._JSON["global_Settings"]["LastUsedProfile"]
        set => This._JSON["global_Settings"]["LastUsedProfile"] := value
    }

    _ProfileProps {
        get {
            Arr := []
            for k in This._JSON["_Profiles"][This.LastUsedProfile] {
                If (k = "Thumbnail Positions" || k = "Client Possitions")
                    continue
                Arr.Push(k)
            }
            return Arr
        }
    }

    Thumbnail_visibility[key?] {
        get {
            return This._JSON["_Profiles"][This.LastUsedProfile]["Thumbnail Visibility"]

            ; if IsSet(Key) {
            ;     Arr := Array()
            ;     for k, v in This._JSON["_Profiles"][This.LastUsedProfile]["Thumbnail_visibility"]
            ;         Arr.Push(k)
            ; return Arr
            ; }
            ; else
            ;     return This._JSON["_Profiles"][This.LastUsedProfile]["Thumbnail_visibility"]
        }
        set {
            if (IsObject(value)) {
                This._JSON["_Profiles"][This.LastUsedProfile]["Thumbnail Visibility"] := value
                ;     for k, v in Value {
                ;         This._JSON["_Profiles"][This.LastUsedProfile]["Thumbnail_visibility"][k] := v
                ;     }
            }
            This.Save_Settings()

        }
    }


    HideThumbnailsOnLostFocus {
        get => This._JSON["_Profiles"][This.LastUsedProfile]["Thumbnail Settings"]["HideThumbnailsOnLostFocus"]
        set => This._JSON["_Profiles"][This.LastUsedProfile]["Thumbnail Settings"]["HideThumbnailsOnLostFocus"] := value
    }
    ShowThumbnailsAlwaysOnTop {
        get => This._JSON["_Profiles"][This.LastUsedProfile]["Thumbnail Settings"]["ShowThumbnailsAlwaysOnTop"]
        set => This._JSON["_Profiles"][This.LastUsedProfile]["Thumbnail Settings"]["ShowThumbnailsAlwaysOnTop"] := value
    }
    LockThumbnailPositions {
        get {
            ThumbnailSettings := This._JSON["_Profiles"][This.LastUsedProfile]["Thumbnail Settings"]
            if (!ThumbnailSettings.Has("LockThumbnailPositions"))
                ThumbnailSettings["LockThumbnailPositions"] := false
            return ThumbnailSettings["LockThumbnailPositions"]
        }
        set => This._JSON["_Profiles"][This.LastUsedProfile]["Thumbnail Settings"]["LockThumbnailPositions"] := value
    }

    ThumbnailOpacity {
        get {
            percentage := This._JSON["_Profiles"][This.LastUsedProfile]["Thumbnail Settings"]["ThumbnailOpacity"]
            return Round((percentage < 0 ? 0 : percentage > 100 ? 100 : percentage) * 2.55)
        }
        set {
            This._JSON["_Profiles"][This.LastUsedProfile]["Thumbnail Settings"]["ThumbnailOpacity"] := Value
        }
    }

    ClientHighligtBorderthickness {
        get => This._JSON["_Profiles"][This.LastUsedProfile]["Thumbnail Settings"]["ClientHighligtBorderthickness"]
        set => This._JSON["_Profiles"][This.LastUsedProfile]["Thumbnail Settings"]["ClientHighligtBorderthickness"] := (Trim(value, "`n ") <= 0 ? 1 : Trim(value, "`n "))
    }

    ClientHighligtColor {
        get => convertToHex(This._JSON["_Profiles"][This.LastUsedProfile]["Thumbnail Settings"]["ClientHighligtColor"])
        set => This._JSON["_Profiles"][This.LastUsedProfile]["Thumbnail Settings"]["ClientHighligtColor"] := convertToHex(Trim(value, "`n "))
    }
    ShowClientHighlightBorder {
        get => This._JSON["_Profiles"][This.LastUsedProfile]["Thumbnail Settings"]["ShowClientHighlightBorder"]
        set => This._JSON["_Profiles"][This.LastUsedProfile]["Thumbnail Settings"]["ShowClientHighlightBorder"] := value
    }
    ThumbnailTextFont {
        get => This._JSON["_Profiles"][This.LastUsedProfile]["Thumbnail Settings"]["ThumbnailTextFont"]
        set => This._JSON["_Profiles"][This.LastUsedProfile]["Thumbnail Settings"]["ThumbnailTextFont"] := Trim(value, "`n ")
    }
    ThumbnailTextSize {
        get => This._JSON["_Profiles"][This.LastUsedProfile]["Thumbnail Settings"]["ThumbnailTextSize"]
        set => This._JSON["_Profiles"][This.LastUsedProfile]["Thumbnail Settings"]["ThumbnailTextSize"] := Trim(value, "`n ")
    }

    ThumbnailTextColor {
        get => convertToHex(This._JSON["_Profiles"][This.LastUsedProfile]["Thumbnail Settings"]["ThumbnailTextColor"])
        set => This._JSON["_Profiles"][This.LastUsedProfile]["Thumbnail Settings"]["ThumbnailTextColor"] := convertToHex(Trim(value, "`n "))
    }
    ShowThumbnailTextOverlay {
        get => This._JSON["_Profiles"][This.LastUsedProfile]["Thumbnail Settings"]["ShowThumbnailTextOverlay"]
        set => This._JSON["_Profiles"][This.LastUsedProfile]["Thumbnail Settings"]["ShowThumbnailTextOverlay"] := value
    }
    ThumbnailTextMargins[var] {
        get => This._JSON["_Profiles"][This.LastUsedProfile]["Thumbnail Settings"]["ThumbnailTextMargins"][var]
        set => This._JSON["_Profiles"][This.LastUsedProfile]["Thumbnail Settings"]["ThumbnailTextMargins"][var] := Trim(value, "`n ")
    }
    InactiveClientBorderthickness {
        get {
            if ( !This._JSON["_Profiles"][This.LastUsedProfile]["Thumbnail Settings"].Has("InactiveClientBorderthickness") ) 
                This._JSON["_Profiles"][This.LastUsedProfile]["Thumbnail Settings"]["InactiveClientBorderthickness"] := "2"
            return This._JSON["_Profiles"][This.LastUsedProfile]["Thumbnail Settings"]["InactiveClientBorderthickness"]
        } 
        set => This._JSON["_Profiles"][This.LastUsedProfile]["Thumbnail Settings"]["InactiveClientBorderthickness"] := (Trim(value, "`n ") <= 0 ? 1 : Trim(value, "`n "))
    }
    InactiveClientBorderColor {
        get {
            if ( !This._JSON["_Profiles"][This.LastUsedProfile]["Thumbnail Settings"].Has("InactiveClientBorderColor") )
                This._JSON["_Profiles"][This.LastUsedProfile]["Thumbnail Settings"]["InactiveClientBorderColor"] := "#8A8A8A"

             return convertToHex(This._JSON["_Profiles"][This.LastUsedProfile]["Thumbnail Settings"]["InactiveClientBorderColor"])
        }
        set => This._JSON["_Profiles"][This.LastUsedProfile]["Thumbnail Settings"]["InactiveClientBorderColor"] := convertToHex(Trim(value, "`n "))
    }


    ;########################
    ;## Profile ClientSettings


    EnsureCustomColorData(ProfileName := "") {
        if (ProfileName = "")
            ProfileName := This.LastUsedProfile
        if (!This._JSON["_Profiles"].Has(ProfileName))
            return false

        Profile := This._JSON["_Profiles"][ProfileName]
        Changed := false
        if (!Profile.Has("Custom Colors") || Type(Profile["Custom Colors"]) != "Map") {
            Profile["Custom Colors"] := Map("cColorActive", "0", "cColors", Map())
            Changed := true
        }
        if (!Profile["Custom Colors"].Has("cColorActive")) {
            Profile["Custom Colors"]["cColorActive"] := "0"
            Changed := true
        }
        if (!Profile["Custom Colors"].Has("cColors") || Type(Profile["Custom Colors"]["cColors"]) != "Map") {
            Profile["Custom Colors"]["cColors"] := Map()
            Changed := true
        }

        Colors := Profile["Custom Colors"]["cColors"]
        for ColorKey in ["CharNames", "TextColor", "Bordercolor", "IABordercolor"] {
            if (!Colors.Has(ColorKey) || Type(Colors[ColorKey]) != "Array") {
                Colors[ColorKey] := []
                Changed := true
            }
        }

        ThumbnailSettings := Profile["Thumbnail Settings"]
        Defaults := Map(
            "TextColor", convertToHex(ThumbnailSettings.Has("ThumbnailTextColor") ? ThumbnailSettings["ThumbnailTextColor"] : "FFFFFF"),
            "Bordercolor", convertToHex(ThumbnailSettings.Has("ClientHighligtColor") ? ThumbnailSettings["ClientHighligtColor"] : "FFFFFF"),
            "IABordercolor", convertToHex(ThumbnailSettings.Has("InactiveClientBorderColor") ? ThumbnailSettings["InactiveClientBorderColor"] : "FFFFFF")
        )
        TargetLength := Colors["CharNames"].Length
        for ColorKey in ["TextColor", "Bordercolor", "IABordercolor"] {
            while (Colors[ColorKey].Length < TargetLength) {
                Colors[ColorKey].Push(Defaults[ColorKey])
                Changed := true
            }
            while (Colors[ColorKey].Length > TargetLength) {
                Colors[ColorKey].Pop()
                Changed := true
            }
        }

        if (Changed && This.HasProp("Save_Settings_Delay_Timer"))
            SetTimer(This.Save_Settings_Delay_Timer, -200)
        return Colors
    }

    CustomColorRows(ProfileName := "") {
        Colors := This.EnsureCustomColorData(ProfileName)
        Rows := []
        if (!Colors)
            return Rows

        for Index, ClientName in Colors["CharNames"] {
            Rows.Push(Map(
                "Char", ClientName,
                "Border", Colors["Bordercolor"][Index],
                "Text", Colors["TextColor"][Index],
                "IABorder", Colors["IABordercolor"][Index]
            ))
        }
        return Rows
    }

    SetCustomColorValue(ClientName, ColorKey, ColorValue, ProfileName := "") {
        if (ColorKey != "Bordercolor" && ColorKey != "TextColor" && ColorKey != "IABordercolor")
            return false
        ColorHex := convertToHex(ColorValue)
        if (!RegExMatch(ColorHex, "i)^[0-9a-f]{6}$"))
            return false

        Colors := This.EnsureCustomColorData(ProfileName)
        if (!Colors)
            return false
        for Index, StoredName in Colors["CharNames"] {
            if (StoredName = ClientName) {
                Colors[ColorKey][Index] := StrLower(ColorHex)
                SetTimer(This.Save_Settings_Delay_Timer, -200)
                return true
            }
        }
        return false
    }

    AddCustomColorCharacter(ClientName, ProfileName := "") {
        ClientName := Trim(This.CleanTitle(ClientName))
        if (ClientName = "")
            return false
        if (ProfileName = "")
            ProfileName := This.LastUsedProfile

        Colors := This.EnsureCustomColorData(ProfileName)
        if (!Colors)
            return false
        for StoredName in Colors["CharNames"] {
            if (StoredName = ClientName)
                return false
        }

        ThumbnailSettings := This._JSON["_Profiles"][ProfileName]["Thumbnail Settings"]
        Colors["CharNames"].Push(ClientName)
        Colors["TextColor"].Push(convertToHex(ThumbnailSettings["ThumbnailTextColor"]))
        Colors["Bordercolor"].Push(convertToHex(ThumbnailSettings["ClientHighligtColor"]))
        Colors["IABordercolor"].Push(convertToHex(ThumbnailSettings["InactiveClientBorderColor"]))
        SetTimer(This.Save_Settings_Delay_Timer, -200)
        return true
    }

    RemoveCustomColorCharacter(ClientName, ProfileName := "") {
        Colors := This.EnsureCustomColorData(ProfileName)
        if (!Colors)
            return false
        for Index, StoredName in Colors["CharNames"] {
            if (StoredName = ClientName) {
                Colors["CharNames"].RemoveAt(Index)
                Colors["TextColor"].RemoveAt(Index)
                Colors["Bordercolor"].RemoveAt(Index)
                Colors["IABordercolor"].RemoveAt(Index)
                SetTimer(This.Save_Settings_Delay_Timer, -200)
                return true
            }
        }
        return false
    }

    CustomColorsGet[CName?] {
        get {
            Colors := This.EnsureCustomColorData()
            TargetName := IsSet(CName) ? CName : ""
            if (Colors) {
                for Index, StoredName in Colors["CharNames"] {
                    if (StoredName = TargetName) {
                        return Map(
                            "Char", StoredName,
                            "Border", Colors["Bordercolor"][Index],
                            "Text", Colors["TextColor"][Index],
                            "IABorder", Colors["IABordercolor"][Index]
                        )
                    }
                }
            }
            return Map("Char", "", "Border", "", "Text", "", "IABorder", "")
        }
    }
    CustomColorsActive {
        get => This._JSON["_Profiles"][This.LastUsedProfile]["Custom Colors"]["cColorActive"]
        set => This._JSON["_Profiles"][This.LastUsedProfile]["Custom Colors"]["cColorActive"] := Value
    }


    MinimizeInactiveClients {
        get => This._JSON["_Profiles"][This.LastUsedProfile]["Client Settings"]["MinimizeInactiveClients"]
        set => This._JSON["_Profiles"][This.LastUsedProfile]["Client Settings"]["MinimizeInactiveClients"] := value
    }
    AlwaysMaximize {
        get => This._JSON["_Profiles"][This.LastUsedProfile]["Client Settings"]["AlwaysMaximize"]
        set => This._JSON["_Profiles"][This.LastUsedProfile]["Client Settings"]["AlwaysMaximize"] := value
    }
    TrackClientPossitions {
        get => This._JSON["_Profiles"][This.LastUsedProfile]["Client Settings"]["TrackClientPossitions"]
        set => This._JSON["_Profiles"][This.LastUsedProfile]["Client Settings"]["TrackClientPossitions"] := value
    }
    Dont_Minimize_Clients {
        get => This._JSON["_Profiles"][This.LastUsedProfile]["Client Settings"]["Dont_Minimize_Clients"]
        set {
            This._JSON["_Profiles"][This.LastUsedProfile]["Client Settings"]["Dont_Minimize_Clients"] := []

            For index, Client in StrSplit(Value, ["`n", ","]) {
                if (Client = "")
                    continue
                This._JSON["_Profiles"][This.LastUsedProfile]["Client Settings"]["Dont_Minimize_Clients"].Push(Trim(Client, "`n "))
            }
        }
    }

    ThumbnailPositions[wTitle?] {
        get {
            if (IsSet(wTitle))
                return This._JSON["_Profiles"][This.LastUsedProfile]["Thumbnail Positions"][wTitle]
            return This._JSON["_Profiles"][This.LastUsedProfile]["Thumbnail Positions"]
        }
        set {
            form := ["x", "y", "width", "height"]

            if !(This._JSON["_Profiles"][This.LastUsedProfile]["Thumbnail Positions"].Has(wTitle))
                This._JSON["_Profiles"][This.LastUsedProfile]["Thumbnail Positions"][wTitle] := Map()

            for v in form {
                This._JSON["_Profiles"][This.LastUsedProfile]["Thumbnail Positions"][wTitle][v] := value[A_Index]
            }
            SetTimer(This.Save_Settings_Delay_Timer, -200)
        }

    }

    ClientPossitions[wTitle] {
        get {
            if (This._JSON["_Profiles"][This.LastUsedProfile]["Client Possitions"].Has(wTitle))
                return This._JSON["_Profiles"][This.LastUsedProfile]["Client Possitions"][wTitle]
            else
                return 0
        }
        set {
            form := ["x", "y", "width", "height", "IsMaximized"]
            if !(This._JSON["_Profiles"][This.LastUsedProfile]["Client Possitions"].Has(wTitle))
                This._JSON["_Profiles"][This.LastUsedProfile]["Client Possitions"][wTitle] := Map()
            for v in form {
                This._JSON["_Profiles"][This.LastUsedProfile]["Client Possitions"][wTitle][v] := value[A_Index]
            }

        }
    }

    ;########################
    ;## Profile Hotkeys
    EnsureDefaultHotkeyGroup(ProfileName := "") {
        if (ProfileName = "")
            ProfileName := This.LastUsedProfile
        if (!This._JSON["_Profiles"].Has(ProfileName))
            return ""

        Profile := This._JSON["_Profiles"][ProfileName]
        Changed := false
        if (!Profile.Has("Hotkey Groups") || Type(Profile["Hotkey Groups"]) != "Map") {
            Profile["Hotkey Groups"] := Map()
            Changed := true
        }
        Groups := Profile["Hotkey Groups"]

        AutoGroupName := ""
        for GroupName, Group in Groups {
            if (Type(Group) = "Map" && Group.Has("AutoIncludeDetectedClients") && Group["AutoIncludeDetectedClients"]) {
                AutoGroupName := GroupName
                break
            }
        }

        if (AutoGroupName = "") {
            AutoGroupName := "Default"
            if (Groups.Has(AutoGroupName)) {
                AutoGroupName := "Default (Auto)"
                Suffix := 2
                while (Groups.Has(AutoGroupName)) {
                    AutoGroupName := "Default (Auto " Suffix ")"
                    Suffix += 1
                }
            }
            Groups[AutoGroupName] := Map(
                "Characters", [],
                "ForwardsHotkey", "",
                "BackwardsHotkey", "",
                "AutoIncludeDetectedClients", true
            )
            Changed := true
        }

        AutoGroup := Groups[AutoGroupName]
        if (!AutoGroup.Has("Characters") || Type(AutoGroup["Characters"]) != "Array") {
            AutoGroup["Characters"] := []
            Changed := true
        }
        for HotkeyName in ["ForwardsHotkey", "BackwardsHotkey"] {
            if (!AutoGroup.Has(HotkeyName)) {
                AutoGroup[HotkeyName] := ""
                Changed := true
            }
        }

        if (Profile.Has("Hotkeys") && Type(Profile["Hotkeys"]) = "Array") {
            for HotkeyEntry in Profile["Hotkeys"] {
                if (Type(HotkeyEntry) != "Map")
                    continue
                for ClientName, _ in HotkeyEntry {
                    FoundClient := false
                    for StoredName in AutoGroup["Characters"] {
                        if (StoredName = ClientName) {
                            FoundClient := true
                            break
                        }
                    }
                    if (!FoundClient && ClientName != "") {
                        AutoGroup["Characters"].Push(ClientName)
                        Changed := true
                    }
                }
            }
        }

        if (Changed && This.HasProp("Save_Settings_Delay_Timer"))
            SetTimer(This.Save_Settings_Delay_Timer, -200)
        return AutoGroupName
    }

    EnsureDefaultHotkeyGroups() {
        for ProfileName in This._JSON["_Profiles"]
            This.EnsureDefaultHotkeyGroup(ProfileName)
    }

    AddClientToDefaultHotkeyGroup(ClientName, ProfileName := "") {
        ClientName := Trim(This.CleanTitle(ClientName))
        if (ClientName = "")
            return ""
        if (ProfileName = "")
            ProfileName := This.LastUsedProfile

        AutoGroupName := This.EnsureDefaultHotkeyGroup(ProfileName)
        if (AutoGroupName = "")
            return ""
        Characters := This._JSON["_Profiles"][ProfileName]["Hotkey Groups"][AutoGroupName]["Characters"]
        for StoredName in Characters {
            if (StoredName = ClientName)
                return ""
        }

        Characters.Push(ClientName)
        SetTimer(This.Save_Settings_Delay_Timer, -200)
        return AutoGroupName
    }

    Hotkey_Groups[key?] {
        get {
            if (IsSet(key)) {
                return This._JSON["_Profiles"][This.LastUsedProfile]["Hotkey Groups"][key]
            }
            else
                return This._JSON["_Profiles"][This.LastUsedProfile]["Hotkey Groups"]
        }
        set {
            This._JSON["_Profiles"][This.LastUsedProfile]["Hotkey Groups"][Key] := Map("Characters", value, "ForwardsHotkey", "", "BackwardsHotkey", "")
        }
    }
    ; Hotkey_Groups_Hotkeys[Name?, Hotkey?] {
    ;     get {

    ;     }
    ;     set {
    ;         This._JSON["_Profiles"][This.LastUsedProfile]["Hotkey_Groups"][Name][Hotkey] := Value
    ;     }
    ; }


    _Hotkeys[key?] {
        get {
            if (IsSet(Key)) {
                loop This._JSON["_Profiles"][This.LastUsedProfile]["Hotkeys"].Length {
                    if (This._JSON["_Profiles"][This.LastUsedProfile]["Hotkeys"][A_Index].Has(key)) {
                        return This._JSON["_Profiles"][This.LastUsedProfile]["Hotkeys"][A_Index][key]
                    }
                }
                return 0
            }
            if !(IsSet(Key))
                return This._JSON["_Profiles"][This.LastUsedProfile]["Hotkeys"]
        }
        set => This._JSON["_Profiles"][This.LastUsedProfile]["Hotkeys"] := Value
    }

    _Hotkey_Delete(*) {
        if (This.LV_Item) {
            try {
                HKey_Char_Name := This.LV.GetText(This.LV_Item)
                if (This._Hotkeys.Has(HKey_Char_Name)) {
                    This._Hotkeys.Delete(HKey_Char_Name)
                    This.LV.Delete(This.LV_Item)

                    ;This.Save_Settings()
                }
            }
        }
    }

    _Hotkey_Add(*) {
        Obj := InputBox(Tr("dialog.char_name"), Tr("dialog.char_add"), "w260 h110")
        if (Obj.Result = "OK") {
            This._Hotkeys[Trim(Obj.Value, " ")] := ""
            This.LV.Add(, Trim(Obj.Value, " "))

            ;This.Save_Settings()
        }
    }

    _Hotkey_Edit(*) {
        if (This.LV_Item) {
            HKey_Char_Key := This.LV.GetText(This.LV_Item, 2), HKey_Char_Name := This.LV.GetText(This.LV_Item)
            if (This._Hotkeys.Has(HKey_Char_Name)) {
                Obj := InputBox(HKey_Char_Key, Tr("dialog.hotkey_edit", HKey_Char_Name), "w300 h120")
                if (Obj.Result = "OK") {
                    This._Hotkeys[HKey_Char_Name] := Trim(Obj.Value, " ")
                    This.LV.Modify(This.LV_Item, , , Trim(Obj.Value, " "))
                    This.LV.Modify(This.LV_Item, "+Focus +Select")

                    ;This.Save_Settings()
                }
            }
        }
    }


    _Tv_LVSelectedRow(GuiCtrlObj, Item, Checked) {
        Obj := Map()
        if (GuiCtrlObj == This.Tv_LV) {
            loop {
                RowNumber := This.Tv_LV.GetNext(A_Index - 1, "Checked")
                if not RowNumber  ; The above returned zero, so there are no more selected rows.
                    break

                Obj[This.Tv_LV.GetText(RowNumber)] := 1
                This.Thumbnail_visibility[This.Tv_LV.GetText(RowNumber)] := 1
                ;MsgBox(GuiCtrlObj.value)
            }
            This.Thumbnail_visibility := Obj
            This.ScheduleProfileApply()
            ;This.LV_Item := Item
            ; ddd := GuiCtrlObj.GetText(Item)
            ; ToolTip(Item ", " ddd " -, " Checked)
        }
    }


    _LVSelectedRow(GuiCtrlObj, Item, Selected) {
        if (GuiCtrlObj == This.LV && Selected) {
            This.LV_Item := Item
            ddd := GuiCtrlObj.GetText(Item)
            ;ToolTip(Item ", " ddd " -, " Selected)
        }
    }


    ;######################
    ;## Methods


    Suspend_Hotkeys(*) {
        static state := 0
        ToolTip()
        state := !state
        state ? ToolTip(Tr("tooltip.hotkeys_disabled")) : ToolTip(Tr("tooltip.hotkeys_enabled"))
        Suspend(-1)

        SetTimer((*) => ToolTip(), -1500)
    }

    Delete_Profile(*) {
        if (This.SelectProfile_DDL.Text = "Default") {
            MsgBox(Tr("dialog.default_delete"), AppInfo.Name)
            Return
        }

        DeletedActiveProfile := This.SelectProfile_DDL.Text = This.LastUsedProfile
        if (DeletedActiveProfile) {
            This.LastUsedProfile := "Default"
        }

        This._JSON["_Profiles"].Delete(This.SelectProfile_DDL.Text)

        if (This.LastUsedProfile = "" || !This.Profiles.Has(This.LastUsedProfile))
            This.LastUsedProfile := "Default"

        ; FileDelete("EVE-X-Preview.json")
        ; FileAppend(JSON.Dump(This._JSON, , "    "), "EVE-X-Preview.json")
        SetTimer(This.Save_Settings_Delay_Timer, -200)

        ;Index := This.SelectProfile_DDL.Value
        This.SelectProfile_DDL.Delete(This.SelectProfile_DDL.Value)
        This.SelectProfile_DDL.Redraw()

        if (DeletedActiveProfile) {
            ControlChooseString("Default", This.SelectProfile_DDL, This.SettingsWindowTitle)
            This.Refresh_ControlValues()
            This.ApplyProfileSettings(true, false)
        }

        for k, v in This.S_Gui.Controls.Profile_Settings.PsDDL {
            for _, ob in v {
                ob.Enabled := 0
            }
        }

        ;This.S_Gui.Show("AutoSize")
    }


    Create_Profile(*) {
        Obj := InputBox(Tr("dialog.profile_name"), Tr("dialog.profile_create"), "w260 h110")
        ProfileName := Trim(Obj.Value)
        if (Obj.Result != "OK" || ProfileName = "")
            return
        if (This.Profiles.Has(ProfileName)) {
            MsgBox(Tr("dialog.profile_exists"), AppInfo.Name)
            return
        }
        if !(This.LastUsedProfile = "Default") {
            Result := MsgBox(Tr("dialog.profile_copy"), AppInfo.Name, "YesNo")
        }
        else
            Result := "No"

        if Result = "Yes"
            SourceProfile := This._JSON["_Profiles"][This.LastUsedProfile]
        else if Result = "No"
            SourceProfile := This.default_JSON["_Profiles"]["Default"]
        else
            Return 0

        ; Use a deep copy so later changes cannot leak into the source profile.
        This._JSON["_Profiles"][ProfileName] := JSON.Load(JSON.Dump(SourceProfile))
        This.LastUsedProfile := ProfileName
        This.PopulateProfileWithActiveClients(ProfileName)
        This.SaveJsonToFile()

        This.SelectProfile_DDL.Delete()
        This.SelectProfile_DDL.Add(This.Profiles_to_Array())
        ControlChooseString(ProfileName, This.SelectProfile_DDL, This.SettingsWindowTitle)
        This._Button_Load()
        This.ApplyProfileSettings(true, false)
        Return
    }
    Save_ThumbnailPossitions() {
        for EvEHwnd, GuiObj in This.ThumbWindows.OwnProps() {
            for Names, Obj in GuiObj {
                if (Names = "Window" && Obj.Title = "" || Obj.Title = "EVE")
                    continue
                Else if (Names = "Window") {
                    WinGetPos(&wX, &wY, &wWidth, &wHeight, Obj.Hwnd)
                    This.ThumbnailPositions[Obj.Title] := [wX, wY, wWidth, wHeight]
                }
            }
        }
    }

    ;### Stores the Thumbnail Size and Possitions in the Json file
    Save_Settings() {
        for EvEHwnd, GuiObj in This.ThumbWindows.OwnProps() {
            for Names, Obj in GuiObj {
                if (Names = "Window" && Obj.Title = "" || Obj.Title = "EVE")
                    continue
                Else if (Names = "Window") {
                    WinGetPos(&wX, &wY, &wWidth, &wHeight, Obj.Hwnd)
                    This.ThumbnailPositions[Obj.Title] := [wX, wY, wWidth, wHeight]
                }
            }
        }
        SetTimer(This.Save_Settings_Delay_Timer, -200)
    }
}


;########################
;## Functions

Add_New_Profile() {
    return
}

convertToHex(rgbString) {
    ; Check if the string corresponds to the decimal value format (e.g. "255, 255, 255" or "rgb(255, 255, 255)")
    if (RegExMatch(rgbString, "^\s*(rgb\s*\(?)?\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\)?\s*$", &matches)) {
        red := matches[2], green := matches[3], blue := matches[4]

        ; covert decimal to hex
        hexValue := Format("{:02X}{:02X}{:02X}", red, green, blue)
        return hexValue
    }

    ; Check whether the string corresponds to the hexadecimal value format (e.g "#FFFFFF" or "0xFFFFFF")
    if (RegExMatch(rgbString, "^\s*(#|0x)?([0-9A-Fa-f]{6})\s*$", &matches)) {
        hexValue := matches[2]
        hexValue := StrLower(hexValue)
        return hexValue
    }
    ;  If no match was found or the string is already in hexadecimal value format, return directly
    return rgbString
}
