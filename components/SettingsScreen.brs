' ============================================================
' SettingsScreen.brs — Stable Navigation + Cursor Highlight
' ============================================================

sub init()
    m.cursor = m.top.findNode("cursor")

    ' Collect vertical menu options
    m.items = [
        m.top.findNode("st1"),
        m.top.findNode("st2"),
        m.top.findNode("st3"),
        m.top.findNode("st4"),
        m.top.findNode("st5")
    ]

    ' Defensive: remove any invalid items
    validItems = []
    for each i in m.items
        if i <> invalid then
            validItems.push(i)
        end if
    end for
    m.items = validItems

    if m.items.count() = 0
        print "❌ ERROR: Settings screen has no menu items!"
        return
    end if

    m.index = 0

    m.top.observeField("hasFocus", "onFocusChanged")

    updateNav()
end sub


' ============================================================
' Focus Handling
' ============================================================
sub onFocusChanged()
    if m.cursor = invalid then return

    if m.top.hasFocus()
        m.cursor.opacity = 1.0
        updateNav()
    else
        m.cursor.opacity = 0.0
    end if
end sub


' ============================================================
' Update Menu Highlight + Cursor Position
' ============================================================
sub updateNav()
    if m.items.count() = 0 then return

    ' Reset all menu item colors
    for each item in m.items
        if item <> invalid
            item.color = "0xAAAAAAFF"
        end if
    end for

    ' Highlight current focused item
    currentItem = m.items[m.index]
    currentItem.color = "0xFFFFFFFF"

    ' Move cursor
    if m.cursor <> invalid
        m.cursor.translation = [ 60, 140 + (m.index * 60) ]
    end if
end sub


' ============================================================
' Key Input Handler
' ============================================================
function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false

    ' ↓ Move down the list
    if key = "down"
        if m.index < m.items.count() - 1
            m.index++
            updateNav()
        end if
        return true

    ' ↑ Move up, or pass focus back to NavBar
    else if key = "up"
        if m.index = 0
            scene = m.top.getScene()
            navBar = scene.findNode("navBar")

            if navBar <> invalid
                navBar.setFocus(true)
            end if
        else
            m.index--
            updateNav()
        end if
        return true

    ' OK selects an item
    else if key = "OK"
        selectedItem = m.items[m.index]
        print "⚙️ Selected setting: "; selectedItem.text
        return true
    end if

    return false
end function
