class ColorPicker {
    static CustomColors := Buffer(16 * 4, 0)

    static Choose(OwnerHwnd, InitialColor := "FFFFFF") {
        ColorHex := convertToHex(InitialColor)
        if (!RegExMatch(ColorHex, "i)^[0-9a-f]{6}$"))
            ColorHex := "FFFFFF"

        Red := ("0x" SubStr(ColorHex, 1, 2)) + 0
        Green := ("0x" SubStr(ColorHex, 3, 2)) + 0
        Blue := ("0x" SubStr(ColorHex, 5, 2)) + 0
        ColorRef := Red | (Green << 8) | (Blue << 16)

        DialogSize := A_PtrSize = 8 ? 72 : 36
        OwnerOffset := A_PtrSize = 8 ? 8 : 4
        ResultOffset := A_PtrSize = 8 ? 24 : 12
        CustomColorsOffset := A_PtrSize = 8 ? 32 : 16
        FlagsOffset := A_PtrSize = 8 ? 40 : 20

        ChooseColorData := Buffer(DialogSize, 0)
        NumPut("UInt", DialogSize, ChooseColorData, 0)
        NumPut("Ptr", OwnerHwnd, ChooseColorData, OwnerOffset)
        NumPut("UInt", ColorRef, ChooseColorData, ResultOffset)
        NumPut("Ptr", This.CustomColors.Ptr, ChooseColorData, CustomColorsOffset)
        NumPut("UInt", 0x1 | 0x2 | 0x80, ChooseColorData, FlagsOffset)

        if (!DllCall("Comdlg32\ChooseColorW", "Ptr", ChooseColorData, "Int"))
            return ""

        SelectedColor := NumGet(ChooseColorData, ResultOffset, "UInt")
        return Format(
            "#{:02X}{:02X}{:02X}",
            SelectedColor & 0xFF,
            (SelectedColor >> 8) & 0xFF,
            (SelectedColor >> 16) & 0xFF
        )
    }
}
