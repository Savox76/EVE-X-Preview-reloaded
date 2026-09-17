#Requires AutoHotkey v2.0

#Include <DefaultJSON> ; The Default Settings Values
#Include <JSON>
#Include <LiveThumb>
#Include <../src/AppInfo>
#Include <../src/ColorPicker>
#Include <../src/UpdateChecker>
#Include <../src/GroupCycle>
#Include <../src/Main_Class>
#Include <../src/ThumbWindow>
#Include <../src/TrayMenu>
#Include <../src/Propertys>
#Include <../src/Settings_Gui>

#SingleInstance Force
Persistent
ListLines False
KeyHistory 0

CoordMode "Mouse", "Screen" ; to track Window Mouse possition while DragMoving the thumbnails
SetWinDelay -1
FileEncoding("UTF-8") ; Encoding for JSSON file

SetTitleMatchMode 3

A_MaxHotKeysPerInterval := 10000 

/*
TODO #########################
*/

;@Ahk2Exe-SetVersion 2.0.2.0
;@Ahk2Exe-SetFileVersion 2.0.2.0
;@Ahk2Exe-SetCopyright g0nzo83 and Savox76 contributors
;@Ahk2Exe-SetDescription EVE-X-Preview Reloaded
;@Ahk2Exe-SetProductName EVE-X-Preview Reloaded
;@Ahk2Exe-ExeName EVE-X-Preview-Reloaded

;@Ahk2Exe-AddResource icon.ico, 160  ; Replaces 'H on blue'
;@Ahk2Exe-AddResource icon-suspend.ico, 206  ; Replaces 'S on green'
;@Ahk2Exe-AddResource icon.ico, 207  ; Replaces 'H on red'
;@Ahk2Exe-AddResource icon-suspend.ico, 208  ; Replaces 'S on red'

;@Ahk2Exe-SetMainIcon icon.ico

if !(A_IsCompiled)
    TraySetIcon("icon.ico",,true)

; Catch all unhandled Errors to prevent the Script from stopping 
OnError(Error_Handler)

I18n.Initialize("en")
Call := Main_Class()



Load_JSON() {
    DJSON := JSON.Load(default_JSON)
    if !(FileExist("EVE-X-Preview.json")) {
        FileAppend(JSON.Dump(DJSON,,"    " ), "EVE-X-Preview.json")
        _JSON :=  JSON.Load(FileRead("EVE-X-Preview.json"))
        return _JSON
    }
    else {
        Try {
            if (FileExist("EVE-X-Preview.json")) {
                ;if needed because of Backward combativity from the alpha versions 
                MergeJson()
            }
            _JSON := JsonMergeNoOverwrite(
                                            DJSON,
                                            JSON.Load(FileRead("EVE-X-Preview.json"))
                                        )
            RemoveExampleClients(_JSON)
            FileDelete("EVE-X-Preview.json")   
            FileAppend(JSON.Dump(_JSON,,"    " ), "EVE-X-Preview.json")
        }
        catch as e  {
            value := MsgBox(Tr("dialog.settings_corrupt"), AppInfo.Name, "OKCancel")
            if (value = "Cancel") 
                ExitApp()

            FileDelete("EVE-X-Preview.json")
            FileAppend(JSON.Dump(DJSON,, "    "), "EVE-X-Preview.json")
            _JSON :=  JSON.Load(FileRead("EVE-X-Preview.json"))
        }
    }
    return _JSON
}

; Removes placeholder clients from configurations created by older versions.
RemoveExampleClients(Settings) {
    PlaceholderNames := Map(
        "Example Name1", true,
        "Example Name2", true,
        "Example Name3", true,
        "Example Name4", true,
        "Example Char", true
    )

    for _, Profile in Settings["_Profiles"] {
        if (Profile.Has("Client Settings") && Profile["Client Settings"].Has("Dont_Minimize_Clients")) {
            ClientSettings := Profile["Client Settings"]
            FilteredExceptions := []
            for ClientName in ClientSettings["Dont_Minimize_Clients"] {
                if (!PlaceholderNames.Has(ClientName))
                    FilteredExceptions.Push(ClientName)
            }
            ClientSettings["Dont_Minimize_Clients"] := FilteredExceptions
        }

        if (Profile.Has("Hotkeys")) {
            FilteredHotkeys := []
            for HotkeyEntry in Profile["Hotkeys"] {
                KeepEntry := true
                for ClientName, _ in HotkeyEntry {
                    if (PlaceholderNames.Has(ClientName)) {
                        KeepEntry := false
                        break
                    }
                }
                if (KeepEntry)
                    FilteredHotkeys.Push(HotkeyEntry)
            }
            Profile["Hotkeys"] := FilteredHotkeys
        }

        if (!Profile.Has("Custom Colors") || !Profile["Custom Colors"].Has("cColors"))
            continue
        Colors := Profile["Custom Colors"]["cColors"]
        Names := Colors["CharNames"]
        TextColors := Colors["TextColor"]
        BorderColors := Colors["Bordercolor"]
        if (!Colors.Has("IABordercolor"))
            Colors["IABordercolor"] := []
        InactiveBorderColors := Colors["IABordercolor"]
        FilteredNames := [], FilteredText := [], FilteredBorders := [], FilteredInactiveBorders := []

        for Index, ClientName in Names {
            if (PlaceholderNames.Has(ClientName))
                continue
            FilteredNames.Push(ClientName)
            FilteredText.Push(TextColors.Length >= Index ? TextColors[Index] : "FFFFFF")
            FilteredBorders.Push(BorderColors.Length >= Index ? BorderColors[Index] : "FFFFFF")
            FilteredInactiveBorders.Push(InactiveBorderColors.Length >= Index ? InactiveBorderColors[Index] : "FFFFFF")
        }
        Colors["CharNames"] := FilteredNames
        Colors["TextColor"] := FilteredText
        Colors["Bordercolor"] := FilteredBorders
        Colors["IABordercolor"] := FilteredInactiveBorders
    }
}

;Compare the User json wit the default Json to check if any key changed for possible future updates.
JsonMergeNoOverwrite(obj1, obj2) {
    for key, value in obj1 {
        if (obj2.Has(key)) {
            if (IsObject(value) && IsObject(obj2[key]))
                obj2[key] := JsonMergeNoOverwrite(value, obj2[key])
        } else {
            obj2[key] := value
        }
    }
    return obj2
}


;THis function is only used to merge the Json from old versions into the new one 
MergeJson(Settingsfile := "EVE-X-Preview.json", dJson := JSON.Load(default_JSON)) {    
    ;Load the content from the existing Json File
    fileObj := FileOpen(Settingsfile,"r", "Utf-8")
    JsonRaw := fileObj.Read(), fileObj.Close()
    OldJson := JSON.Load(JsonRaw)
    savetofile := 0

       
    for Profiles, settings in OldJson["_Profiles"] {
        if (Profiles = "Default") {
           continue
        }
        dJson["_Profiles"][Profiles] := Map()
        for k, v in settings { 
            if (OldJson["_Profiles"][Profiles].Has("ClientPossitions")) { 
                savetofile := 1
                if (k = "ClientPossitions")
                    dJson["_Profiles"][Profiles]["Client Possitions"] := v            
                else if (k = "ClientSettings")
                    dJson["_Profiles"][Profiles]["Client Settings"] :=  v
                else if (k = "ThumbnailSettings")
                    dJson["_Profiles"][Profiles]["Thumbnail Settings"] := v
                else if (k = "ThumbnailPositions")
                    dJson["_Profiles"][Profiles]["Thumbnail Positions"] :=  v
                else if (k = "Thumbnail_visibility")
                    dJson["_Profiles"][Profiles]["Thumbnail Visibility"] := v
                else if (k = "Custom_Colors")
                    dJson["_Profiles"][Profiles]["Custom Colors"] := dJson["_Profiles"]["Default"]["Custom Colors"]
                else if (k = "Hotkey_Groups")
                    dJson["_Profiles"][Profiles]["Hotkey Groups"] := v
                else if (k = "Hotkeys") {
                    if (Type(v) = "Map") {
                        Arr := []
                        for char, hotkey in v
                            Arr.Push(Map(char, hotkey))
                        dJson["_Profiles"][Profiles]["Hotkeys"] := Arr
                    }                
                }
            }
        }
    }
    if savetofile {
        dJson["global_Settings"] := OldJson["global_Settings"]  
        
        fileObj := FileOpen(Settingsfile,"w", "Utf-8")
        fileObj.Write(JSON.Dump(dJson,, "    ")), fileObj.Close()
    }
}

; Hanles unmanaged Errors
Error_Handler(Thrown, Mode) {
    return -1
}
