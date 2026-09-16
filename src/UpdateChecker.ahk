class UpdateChecker {
    static Check() {
        try {
            Request := ComObject("WinHttp.WinHttpRequest.5.1")
            Request.SetTimeouts(2500, 2500, 2500, 4000)
            Request.Open("GET", AppInfo.ReleasesApiUrl, false)
            Request.SetRequestHeader("Accept", "application/vnd.github+json")
            Request.SetRequestHeader("User-Agent", AppInfo.Name "/" AppInfo.Version)
            Request.Send()

            if (Request.Status != 200)
                return Map("status", "error", "http_status", Request.Status)

            Releases := JSON.Load(Request.ResponseText)
            for Release in Releases {
                if (Release["draft"])
                    continue

                RemoteVersion := RegExReplace(Release["tag_name"], "i)^v")
                if (This.IsNewer(RemoteVersion, AppInfo.Version)) {
                    return Map(
                        "status", "update",
                        "version", RemoteVersion,
                        "url", Release["html_url"]
                    )
                }
                return Map("status", "current", "version", AppInfo.Version)
            }
            return Map("status", "current", "version", AppInfo.Version)
        }
        catch as ErrorObject {
            return Map("status", "error", "message", ErrorObject.Message)
        }
    }

    static IsNewer(RemoteVersion, CurrentVersion) {
        Remote := This.ParseVersion(RemoteVersion)
        Current := This.ParseVersion(CurrentVersion)

        loop 3 {
            if (Remote["numbers"][A_Index] > Current["numbers"][A_Index])
                return true
            if (Remote["numbers"][A_Index] < Current["numbers"][A_Index])
                return false
        }

        if (Remote["stage"] > Current["stage"])
            return true
        if (Remote["stage"] < Current["stage"])
            return false
        return Remote["sequence"] > Current["sequence"]
    }

    static ParseVersion(Version) {
        Match := ""
        if (!RegExMatch(Version, "i)^v?(\d+)\.(\d+)\.(\d+)(?:-([a-z]+)(?:\.(\d+))?)?$", &Match))
            return Map("numbers", [0, 0, 0], "stage", 0, "sequence", 0)

        StageName := StrLower(Match[4])
        Stage := StageName = "" ? 4 : StageName = "rc" ? 3 : StageName = "beta" ? 2 : StageName = "preview" ? 1 : 0
        Sequence := Match[5] = "" ? 0 : Integer(Match[5])
        return Map(
            "numbers", [Integer(Match[1]), Integer(Match[2]), Integer(Match[3])],
            "stage", Stage,
            "sequence", Sequence
        )
    }
}
