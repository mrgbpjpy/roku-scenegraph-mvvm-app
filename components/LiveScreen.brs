' ============================================================
' LiveScreen.brs — Stable Vertical Menu Navigation
' ============================================================

sub init()
    print "LiveScreen init()"

    ' UI references
    m.liveMenu = m.top.findNode("liveMenu")
    m.cursor   = m.top.findNode("cursor")

    m.options = [
        m.top.findNode("opt1"),
        m.top.findNode("opt2"),
        m.top.findNode("opt3"),
        m.top.findNode("opt4")
    ]

    m.currentIndex = 0

    ' Watch focus state for visibility toggles
    m.top.observeField("hasFocus", "onFocusChanged")

    updateMenuVisuals()
end sub


' ============================================================
' Focus Handling
' ============================================================
sub onFocusChanged()
    focused = m.top.hasFocus()

    if m.cursor <> invalid then
        if focused then
            m.cursor.opacity = 1.0
        else
            m.cursor.opacity = 0.0
        end if
    end if

    if focused then
        updateMenuVisuals()
    end if
end sub



' ============================================================
' Update Label Highlight + Underline Cursor
' ============================================================
sub updateMenuVisuals()
    if m.options = invalid or m.cursor = invalid then return

    for i = 0 to m.options.count() - 1
        opt = m.options[i]

        if opt <> invalid then
            if i = m.currentIndex then
                opt.color = "0xFFFFFFFF"   ' highlight
            else
                opt.color = "0xAAAAAAFF"   ' dim
            end if
        end if
    end for

    selected = m.options[m.currentIndex]
    if selected = invalid then return

    rect = selected.boundingRect()
    if rect = invalid then return

    menuPos = m.liveMenu.translation

    ' Move underline under selection
    m.cursor.translation = [
        menuPos[0] + rect.x,
        menuPos[1] + rect.y + rect.height + 6
    ]

    m.cursor.width  = rect.width
    m.cursor.height = 4
    m.cursor.opacity = 1.0
end sub


' ============================================================
' Remote Key Handling
' ============================================================
function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false

    ' Move DOWN
    if key = "down"
        if m.currentIndex < m.options.count() - 1
            m.currentIndex++
            updateMenuVisuals()
        end if
        return true
    end if

    ' Move UP
    if key = "up"
        if m.currentIndex > 0
            m.currentIndex--
            updateMenuVisuals()
        else
            ' Move focus back to NavBar when UP on top item
            scene = m.top.getScene()
            if scene <> invalid
                navBar = scene.findNode("navBar")
                if navBar <> invalid then navBar.setFocus(true)
            end if
        end if
        return true
    end if

    ' OK selection
    if key = "OK"
        print "LiveScreen selection index: "; m.currentIndex
        ' TODO: add DetailScreen integration later
        return true
    end if

    return false
end function
