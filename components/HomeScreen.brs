sub init()
    ' Grab the RowList used for the home content
    m.rowList = m.top.findNode("rowList")

    ' HomeScreen itself can receive focus (so AppScene can call giveFocus)
    m.top.focusable = true

    if m.rowList <> invalid then
        ' Let RowList handle its own navigation when it has focus
        m.rowList.focusable = true

        ' Optional: if there is content, start on first row/item
        if m.rowList.content <> invalid then
            ' Row 0, item 0
            m.rowList.jumpToRowItem = [0, 0]
        end if
    end if
end sub

' Called by AppScene.enterCurrentScreen when NavBar is on "home"
' and the user presses DOWN/OK
sub giveFocus()
    if m.rowList <> invalid then
        m.rowList.setFocus(true)

        ' Make sure we’re on the first tile
        m.rowList.jumpToRowItem = [0, 0]
    else
        ' Fallback: focus the group itself
        m.top.setFocus(true)
    end if
end sub

' Handle special key behavior when bubbling from children (RowList)
function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false
    if m.rowList = invalid then return false

    ' We only care about UP from the very first item
    if key = "up" then
        ' rowItemFocused is [rowIndex, itemIndex] or invalid
        pos = m.rowList.rowItemFocused

        if pos <> invalid then
            rowIndex  = pos[0]
            itemIndex = pos[1]

            ' At very top-left (row 0, item 0) → return focus to NavBar
            if rowIndex = 0 and itemIndex = 0 then
                scene = m.top.getScene()
                if scene <> invalid then
                    ' Use the same pattern as LiveScreen: let AppScene decide
                    scene.callFunc("focusNavBar")
                    return true
                end if
            end if
        end if
    end if

    ' For all other keys, let RowList handle them
    return false
end function
