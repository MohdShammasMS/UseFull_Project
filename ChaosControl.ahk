; List of social media app process names
socialMediaApps := ["chrome.exe", "firefox.exe", "Telegram.exe", "Discord.exe", "WhatsApp.exe", "X.exe", "Instagram.exe"]

; Time limit for idle (procrastination detection), in milliseconds (1 minute here)
idleLimit := 10000
lastActiveTime := A_TickCount
lastX := 0
lastY := 0

; Path to MP3 audio file
audioFile := "C:\Users\HP\Downloads.wav"

; Activate periodic checking
SetTimer, CheckActiveApp, 1000
SetTimer, CheckIdleTime, 5000

; Variables for "run-away" social media app blocker
isAppRunningAway := false

; Opening Message
ToolTip, % "Chaos Control Activated!`nPrepare for some productivity madness!"
Sleep, 2500  ; Display message for 2.5 seconds
ToolTip  ; Clear tooltip

; Function to display random messages
DisplayRandomMessage()
{
    messages := ["Don't procrastinate!", "Social media can wait!", "Focus on your tasks!", "Do something productive!", "Stay on track!"]
    Random, idx, 1, % messages.MaxIndex()
    ToolTip, % messages[idx]
    Sleep, 1500
    ToolTip  ; Clear tooltip
}

; Check for active app
CheckActiveApp:
    WinGet, active_id, ID, A
    WinGet, active_name, ProcessName, ahk_id %active_id%

    ; Check if it's a social media app
    for each, app in socialMediaApps
    {
        if (active_name = app)
        {
            ; Display random message
            DisplayRandomMessage()

            ; Initiate "run-away" effect if user attempts to click social media
            if (!isAppRunningAway)
            {
                isAppRunningAway := true
                RunAwayApp(active_id)
            }
            return  ; Exit after handling the social media app
        }
    }
    ; Reset if not on social media
    isAppRunningAway := false
return

; Idle Time Check for Chaos Mode
CheckIdleTime:
    if (A_TickCount - lastActiveTime > idleLimit)
    {
        ; Play the audio alert when chaos mode is triggered
        SoundPlay, %audioFile%
        InitiateChaosMode()
        lastActiveTime := A_TickCount
    }
return

; Reset idle time on user activity
#If
~LButton::
~RButton::
~WheelUp::
~WheelDown::
    lastActiveTime := A_TickCount
return
#If  ; End of context-sensitive hotkeys

; Detecting mouse movement indirectly by checking cursor position change
SetTimer, CheckMouseMove, 100
CheckMouseMove:
{
    global lastX, lastY  ; Make lastX and lastY global
    MouseGetPos, x, y
    if (x != lastX or y != lastY)
    {
        lastActiveTime := A_TickCount
        lastX := x
        lastY := y
    }
    return
}

; Run-away effect for social media apps
RunAwayApp(active_id)
{
    Loop, 10
    {
        Random, x, 100, 800
        Random, y, 100, 600
        WinMove, ahk_id %active_id%, , %x%, %y%
        Sleep, 100
    }
}

; Initiate Chaos Mode (UI effects, etc.)
InitiateChaosMode()
{
    ToolTip, % "Chaos Mode Activated! Good luck escaping!"
    Sleep, 1500
    ToolTip

    ; Example of window shaking and random tooltips
    Loop, 15
    {
        DisplayRandomMessage()
        WinGetPos, x, y, , , A
        Random, shakeX, -20, 20
        Random, shakeY, -20, 20
        WinMove, A, , x + shakeX, y + shakeY
        Sleep, 100
    }

    ; Start chase game to exit
    MsgBox, % "Chase the moving character to exit chaos mode!"
    StartExitChase()
}

; Exit Chase Game
StartExitChase()
{
    ; Use a simple character
    exitIcon := "^"

    Loop
    {
        Random, x, 100, 800
        Random, y, 100, 600
        ToolTip, % exitIcon
        MouseMove, %x%, %y%
        Sleep, 1000  ; Make it easier to catch over time

        ; Check if user clicks to "catch" and exit
        if (GetKeyState("LButton", "P"))
        {
            ToolTip, % "Congratulations, you escaped!"
            Sleep, 1500
            ToolTip
            ExitApp
        }
    }
}

; Hotkey to manually stop the script
^Esc::ExitApp
