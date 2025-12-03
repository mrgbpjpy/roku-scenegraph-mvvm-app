sub init()
    m.searchBox = m.top.findNode("searchBox") ' or whatever id
    m.top.focusable = true
end sub

sub giveFocus()
    if m.searchBox <> invalid then
        m.searchBox.setFocus(true)
    end if
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    if not press then return false

    if key = "up" then
        m.top.getScene().callFunc("focusNavBar")
        return true
    end if

    return false
end function
