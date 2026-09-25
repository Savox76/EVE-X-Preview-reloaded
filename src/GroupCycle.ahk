class GroupCycle {
    static SelectIndex(Characters, ActiveTitle, AvailableTitles, Direction) {
        if (!IsObject(Characters) || Characters.Length = 0)
            return 0

        ActiveTitle := This.NormalizeTitle(ActiveTitle)
        CurrentIndex := 0
        for Index, Character in Characters {
            if (This.NormalizeTitle(Character) = ActiveTitle) {
                CurrentIndex := Index
                break
            }
        }

        ; Match the direction labels used by the settings UI. The detected client
        ; order is traversed towards the preceding entry for Forward and towards
        ; the following entry for Backward.
        Step := Direction = "ForwardsHotkey" ? -1 : 1
        CandidateIndex := CurrentIndex
            ? CurrentIndex + Step
            : (Step > 0 ? 1 : Characters.Length)

        ; Check each configured entry at most once. This stays bounded even if
        ; EVE windows disappear while a hotkey is being processed.
        loop Characters.Length {
            if (CandidateIndex > Characters.Length)
                CandidateIndex := 1
            else if (CandidateIndex <= 0)
                CandidateIndex := Characters.Length

            CandidateTitle := This.NormalizeTitle(Characters[CandidateIndex])
            if (CandidateTitle != "" && This.ContainsTitle(AvailableTitles, CandidateTitle))
                return CandidateIndex

            CandidateIndex += Step
        }
        return 0
    }

    static ContainsTitle(Titles, CandidateTitle) {
        for Title in Titles {
            if (This.NormalizeTitle(Title) = CandidateTitle)
                return true
        }
        return false
    }

    static NormalizeTitle(Title) {
        Title := Trim(Title)
        if (RegExMatch(Title, "i)^EVE\s*$"))
            return ""
        return RegExReplace(Title, "i)^EVE\s*-\s*", "")
    }
}
