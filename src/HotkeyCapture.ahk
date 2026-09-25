class HotkeyCapture {
    static CaptureKeyboardHotkey(TimeoutSeconds := 0) {
        Hook := InputHook("L0")
        Hook.Timeout := TimeoutSeconds
        Hook.VisibleText := false
        Hook.VisibleNonText := false
        Hook.KeyOpt("{All}", "E")
        Hook.KeyOpt("{LCtrl}{RCtrl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}", "-E")
        Hook.Start()
        Hook.Wait()

        if (Hook.EndReason = "Timeout")
            return ""
        if (Hook.EndKey = "Escape" && Hook.EndMods = "")
            return ""
        return This.NormalizeModifiers(Hook.EndMods) . Hook.EndKey
    }

    static NormalizeModifiers(Modifiers) {
        Prefix := ""
        for Symbol in ["^", "!", "+", "#"] {
            if (InStr(Modifiers, Symbol))
                Prefix .= Symbol
        }
        return Prefix
    }
}
