sub init()
    ' The screen handles focus only for its rowList, not the component itself
    m.rowList = m.top.findNode("rowList")
    m.top.listenPort = invalid
    
    ' Make sure RowList can take focus when AppScene requests it
    m.rowList.focusable = true

    ' Start unfocused – NavBar owns focus when app loads
    m.top.focusable = true
end sub


' Called by AppScene when user presses DOWN on the NavBar
sub giveFocus()
    if m.rowList <> invalid then
        m.rowList.setFocus(true)
    end if
end sub


' Handle key events only when this screen has focus
function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false

    ' When user presses UP at the top of the first row, return focus to NavBar
    if key = "up" then
        if m.rowList.itemFocused = 0 then
            nav = m.top.getScene().findNode("navBar")
            if nav <> invalid then
                nav.setFocus(true)
                return true
            end if
        end if
    end if

    return false
end function
