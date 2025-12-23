' ============================================================
'  SportsScreen.brs — Clean ESPN-style horizontal selector
' ============================================================

sub init()
    m.row    = m.top.findNode("sportsRow")
    m.cursor = m.top.findNode("cursor")

    m.items = [
        m.top.findNode("sportNFL"),
        m.top.findNode("sportNBA"),
        m.top.findNode("sportMLB"),
        m.top.findNode("sportNHL"),
        m.top.findNode("sportUFC"),
        m.top.findNode("sportSOC")
    ]

    m.index = 0

    m.top.observeField("hasFocus", "onFocusChanged")

    updateNav()
end sub

sub enterMenu()
    print "HOME ▶ enterMenu()"
    m.rowList.setFocus(true)
end sub

' ============================================================
' Focus Handling
' ============================================================
sub onFocusChanged()
    if m.top.hasFocus()
        m.cursor.opacity = 1.0
        updateNav()
    else
        m.cursor.opacity = 0.0
    end if
end sub


' ============================================================
' Update Highlight + Cursor Position
' ============================================================
sub updateNav()
    ' Reset all labels to dim color
    for each lbl in m.items
        lbl.color = "0xAAAAAAFF"
    end for

    ' Highlight active label
    current = m.items[m.index]
    current.color = "0xFFFFFFFF"

    ' Measure the label
    rect  = current.boundingRect()
    group = m.row.translation

    ' Cursor underline positioning
    underlineX = group[0] + rect.x
    underlineY = group[1] + rect.y + rect.height + 6

    m.cursor.width       = rect.width
    m.cursor.translation = [ underlineX, underlineY ]
end sub


' ============================================================
' Remote Control Navigation
' ============================================================
function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false

    if key = "right"
        if m.index < m.items.count() - 1
            m.index++
            updateNav()
        end if
        return true

    else if key = "left"
        if m.index > 0
            m.index--
            updateNav()
        end if
        return true

    else if key = "up"
        ' Return to NavBar
        scene = m.top.getScene()
        navBar = scene.findNode("navBar")
        if navBar <> invalid then navBar.setFocus(true)
        return true

    else if key = "OK"
        print "Sports Category selected: "; m.items[m.index].text
        ' TODO: Load vertical rows for selected sport
        return true
    end if

    return false
end function
