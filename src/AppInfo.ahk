class AppInfo {
    static Name := "EVE-X-Preview Reloaded"
    static Version := "2.0.1"
    static Repository := "Savox76/EVE-X-Preview-reloaded"
    static ReleasesUrl := "https://github.com/" AppInfo.Repository "/releases"
    static ReleasesApiUrl := "https://api.github.com/repos/" AppInfo.Repository "/releases?per_page=10"
}

class I18n {
    static Language := "en"
    static English := Map()
    static Current := Map()

    static Initialize(Language := "en") {
        This.English := This.LoadLanguage("en")
        This.SetLanguage(Language)
    }

    static SetLanguage(Language) {
        Language := StrLower(Language)
        if (Language != "de" && Language != "en")
            Language := "en"

        This.Language := Language
        This.Current := (Language = "en") ? This.English : This.LoadLanguage(Language)
        if (!This.Current.Count)
            This.Current := This.English
    }

    static LoadLanguage(Language) {
        try {
            LocalePath := A_ScriptDir "\locales\" Language ".json"
            return JSON.Load(FileRead(LocalePath, "UTF-8"))
        }
        catch {
            return Map()
        }
    }

    static Get(Key, Values*) {
        Text := Key
        if (This.Current.Has(Key))
            Text := This.Current[Key]
        else if (This.English.Has(Key))
            Text := This.English[Key]

        for Index, Value in Values
            Text := StrReplace(Text, "{" Index "}", Value)
        return Text
    }
}

Tr(Key, Values*) {
    return I18n.Get(Key, Values*)
}
