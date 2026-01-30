#NoEnv
#Persistent
#SingleInstance Force
SendMode Input
SetWorkingDir %A_ScriptDir%
SetKeyDelay, 0, 0
SetWinDelay, 0
SetBatchLines, -1
SetControlDelay, 0
SetTitleMatchMode, 2

; ========= SETTINGS =========
ruleName := "123456"
blockIP   := "192.81.241.171"
; ============================

; --- Admin elevation ---
if !A_IsAdmin
{
    Run, *RunAs "%A_ScriptFullPath%",, UseErrorLevel
    if (ErrorLevel != 0)
        MsgBox, 48, Error, This script requires administrator privileges. Please run it again as admin.
    ExitApp
}

OnExit("AppExit")

; ===== HOTKEYS =====
^F9::  ; Ctrl+F9 = ON
    SoundBeep, 750, 80
    ToggleNoSave(true)
return

^F12:: ; Ctrl+F12 = OFF
    SoundBeep, 600, 80
    ToggleNoSave(false)
return

; ===== FUNCTIONS =====
ToggleNoSave(isOn)
{
    global ruleName, blockIP

    if (isOn)
    {
        ; Add/replace rule safely
        RunWait, %ComSpec% /c netsh advfirewall firewall delete rule name="%ruleName%" >nul 2>&1, , Hide
        RunWait, %ComSpec% /c netsh advfirewall firewall add rule name="%ruleName%" dir=out action=block remoteip=%blockIP% >nul 2>&1, , Hide

        ToolTip, NO SAVING MODE ON, 10, 10
        SetTimer, __ClearTip, -3000
    }
    else
    {
        RunWait, %ComSpec% /c netsh advfirewall firewall delete rule name="%ruleName%" >nul 2>&1, , Hide

        ToolTip, NO SAVING MODE OFF, 10, 10
        SetTimer, __ClearTip, -3000
    }
}

__ClearTip:
ToolTip
return

AppExit(ExitReason := "", ExitCode := 0)
{
    global ruleName
    RunWait, %ComSpec% /c netsh advfirewall firewall delete rule name="%ruleName%" >nul 2>&1, , Hide
}
