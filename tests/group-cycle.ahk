#Requires AutoHotkey v2.0
#Include ..\src\GroupCycle.ahk

AssertEqual(Actual, Expected, Label) {
    if (Actual != Expected)
        throw Error(Label ": expected " Expected ", got " Actual)
}

Characters := ["Alpha", "Bravo", "Charlie", "Delta"]
AllAvailable := ["Alpha", "Bravo", "Charlie", "Delta"]

AssertEqual(GroupCycle.SelectIndex(Characters, "Alpha", AllAvailable, "ForwardsHotkey"), 2, "forward next")
AssertEqual(GroupCycle.SelectIndex(Characters, "Delta", AllAvailable, "ForwardsHotkey"), 1, "forward wrap")
AssertEqual(GroupCycle.SelectIndex(Characters, "Alpha", AllAvailable, "BackwardsHotkey"), 4, "backward wrap")
AssertEqual(GroupCycle.SelectIndex(Characters, "Charlie", AllAvailable, "BackwardsHotkey"), 2, "backward previous")

PartlyAvailable := ["Alpha", "Charlie", "Delta"]
AssertEqual(GroupCycle.SelectIndex(Characters, "Alpha", PartlyAvailable, "ForwardsHotkey"), 3, "skip unavailable forward")
AssertEqual(GroupCycle.SelectIndex(Characters, "Charlie", ["Alpha", "Charlie"], "BackwardsHotkey"), 1, "skip unavailable backward")
AssertEqual(GroupCycle.SelectIndex(Characters, "Outside", PartlyAvailable, "ForwardsHotkey"), 1, "outside group forward")
AssertEqual(GroupCycle.SelectIndex(Characters, "Outside", PartlyAvailable, "BackwardsHotkey"), 4, "outside group backward")
AssertEqual(GroupCycle.SelectIndex(Characters, "Alpha", [], "ForwardsHotkey"), 0, "no available client")

NameCharacters := ["Eve Phillips", "Riinn Garner"]
AssertEqual(GroupCycle.NormalizeTitle("Eve Phillips"), "Eve Phillips", "Eve name remains intact")
AssertEqual(GroupCycle.NormalizeTitle("EVE - Eve Phillips"), "Eve Phillips", "window prefix removed once")
AssertEqual(GroupCycle.SelectIndex(NameCharacters, "Riinn Garner", ["EVE - Eve Phillips"], "ForwardsHotkey"), 1, "Eve name remains selectable")

FileAppend("PASS group cycle regression tests`n", "*")
ExitApp(0)
