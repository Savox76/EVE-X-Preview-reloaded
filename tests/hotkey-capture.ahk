#Requires AutoHotkey v2.0
#Include ../src/HotkeyCapture.ahk

AssertEqual("3", CaptureSentKey("3"), "The number row must remain distinct")
AssertEqual("Numpad3", CaptureSentKey("{Numpad3}"), "Numpad 3 must keep its physical key name")
AssertEqual("Numpad1", CaptureSentKey("{Numpad1}"), "Numpad 1 must keep its physical key name")
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
