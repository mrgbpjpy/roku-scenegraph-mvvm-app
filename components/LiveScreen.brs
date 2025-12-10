' ============================================================
' LiveScreen.brs — revised navigation + UI consistency
' ============================================================

sub init()
    m.title    = m.top.findNode("title")
    m.liveMenu = m.top.findNode("liveMenu")
    m.cursor   = m.top.findNode("cursor")

    m.options = [
        m.top.findNode("opt1"),
        m.top.findNode("opt2"),
        m.top.findNode("opt3"),
        m.top.findNode("opt4")
    ]

    m.currentIndex = 0

    m.top.observeField("hasFocus", "onFocusChanged")

    updateMenuVisuals()
end sub


' -------------------------------------------------------------
' Focus Handling
' -------------------------------------------------------------
sub onFocusChanged()
    focused = m.top.hasFocus()

    if m.cursor <> invalid
        m.cursor.visible = focused
    end if

    if focused
        updateMenuVisuals()
    end if
end sub


' -------------------------------------------------------------
' Update underline + label colors
' -------------------------------------------------------------
sub updateMenuVisuals()
    if m.options = invalid then return

    for i = 0 to m.options.count() - 1
        opt = m.options[i]

        if i = m.currentIndex
            opt.color = "0xFFFFFFFF"
        else
            opt.color = "0xAAAAAAFF"
        end if
    end for

    selected = m.options[m.currentIndex]
    rect = selected.boundingRect()

    ' Position underline
    m.cursor.translation = [
        rect.x,
        rect.y + rect.height + 4
    ]

    m.cursor.width  = rect.width
    m.cursor.height = 4
end sub


' -------------------------------------------------------------
' Key Input
' -------------------------------------------------------------
function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false

    if key = "down"
        if m.currentIndex < m.options.count() - 1
            m.currentIndex++
            updateMenuVisuals()
        end if
        return true

    else if key = "up"
        if m.currentIndex > 0
            m.currentIndex--
            updateMenuVisuals()
        else
            ' Move to NavBar if at top
            scene = m.top.getScene()
            navBar = scene.findNode("navBar")
            if navBar <> invalid then navBar.setFocus(true)
        end if
        return true

    else if key = "OK"
        print "LiveScreen selection: "; m.currentIndex
        ' Later: hook into DetailScreen just like HomeScreen
        return true
    end if

    return false
end function
