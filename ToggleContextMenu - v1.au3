#RequireAdmin
#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>

Global Const $sKey = "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}"
Global Const $sSubKey = $sKey & "\InprocServer32"

GUICreate("Toggle Context Menu - Windows 11 x64", 380, 150, -1, -1)
GUICtrlCreateLabel("Comuta intre meniul clasic si cel modern in Windows 11.", 20, 20, 340, 20)
Global $btn = GUICtrlCreateButton("Verificare...", 110, 60, 160, 35)
GUISetState(@SW_SHOW)

GUICtrlCreateLabel("Creat de eOL.", 160, 120, 340, 20)

UpdateButton()

While 1
    Switch GUIGetMsg()
        Case $GUI_EVENT_CLOSE
            Exit
        Case $btn
            ToggleMenuStyle()
            UpdateButton()
    EndSwitch
WEnd

Func IsClassic()
    Local $val = RegRead($sSubKey, "")
    Return @error = 0 And $val == ""
EndFunc

Func ToggleMenuStyle()
    If IsClassic() Then
        ; Trecem la meniu modern: stergem cheia complet
        RegDelete($sKey)
        MsgBox($MB_OK + $MB_ICONINFORMATION, "Meniu", "Ai trecut la meniul modern (Windows 11 style). Explorer va fi repornit.")
    Else
        ; Activam meniul clasic
        RegWrite($sSubKey, "", "REG_SZ", "")
        MsgBox($MB_OK + $MB_ICONINFORMATION, "Meniu", "Ai activat meniul clasic (Windows 10 style). Explorer va fi repornit.")
    EndIf
    RestartExplorer()
EndFunc

Func UpdateButton()
    If IsClassic() Then
        GUICtrlSetData($btn, "Comuta la Meniul Modern")
    Else
        GUICtrlSetData($btn, "Comuta la Meniul Clasic")
    EndIf
EndFunc

Func RestartExplorer()
    RunWait("taskkill /f /im explorer.exe", "", @SW_HIDE)
    Sleep(700)
    Run("explorer.exe", "", @SW_HIDE)
EndFunc
