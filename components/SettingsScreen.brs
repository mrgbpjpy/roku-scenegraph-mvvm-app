sub init()
    ' Allow this screen to participate in focus handling
    m.top.focusable = true
end sub

' Called by AppScene when NavBar is on "settings"
' and the user presses DOWN or OK
sub giveFocus()
    ' For now, just let the screen itself take focus
    m.top.setFocus(true)
end sub

' Handle key navigation for this screen
function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false

    ' Pressing UP from Settings returns to NavBar
    if key = "up" then
        scene = m.top.getScene()
        if scene <> invalid then
            scene.callFunc("focusNavBar")
            return true
        end if
    end if

    ' No other special keys yet
    return false
end function
