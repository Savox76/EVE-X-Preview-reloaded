#Requires AutoHotkey v2.0
#Include ../src/HotkeyCapture.ahk

AssertEqual("3", CaptureSentKey("3"), "The number row must remain distinct")
AssertEqual("Numpad3", CaptureSentKey("{Numpad3}"), "Numpad 3 must keep its physical key name")
AssertEqual("Numpad1", CaptureSentKey("{Numpad1}"), "Numpad 1 must keep its physical key name")
AssertEqual("F1", CaptureSentKey("{F1}"), "Function keys must be captured by name")
AssertEqual("^!F12", CaptureSentKey("{LCtrl down}{LAlt down}{F12}{LAlt up}{LCtrl up}"), "Modifier combinations must be captured atomically")
AssertEqual("^!+#", HotkeyCapture.NormalizeModifiers("<^>!<+>#"), "Left and right modifiers must be normalized")
AssertEqual("", CaptureSentKey("{Escape}"), "Escape must cancel capture")
ExitApp(0)

CaptureSentKey(KeySequence) {
    SetTimer((*) => SendEvent(KeySequence), -100)
    return HotkeyCapture.CaptureKeyboardHotkey(2)
}

AssertEqual(Expected, Actual, Message) {
    if (Actual = Expected)
        return
    FileAppend(Message ": expected '" Expected "', got '" Actual "'`n", "*")
    ExitApp(1)
}
