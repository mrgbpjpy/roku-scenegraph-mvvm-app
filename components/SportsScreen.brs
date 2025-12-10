sub init()
    m.row = m.top.findNode("sportsRow")
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

sub onFocusChanged()
    if m.top.hasFocus()
        m.cursor.opacity = 1.0
        updateNav()
    else
        m.cursor.opacity = 0.0
    end if
end sub

sub updateNav()
    ' Reset all items
    for each lbl in m.items
        lbl.color = "0xAAAAAAFF"
    end for

    ' Highlight active sport
    current = m.items[m.index]
    current.color = "0xFFFFFFFF"

    ' Move cursor under label
    rect = current.boundingRect()
    m.cursor.translation = [
        rect.x + 60,
        rect.y + rect.height + 5
    ]
end sub


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
        scene = m.top.getScene()
        navBar = scene.findNode("navBar")
        navBar.setFocus(true)
        return true

    else if key = "OK"
        print "Sports Category selected: "; m.items[m.index].text
        ' Later: Load dynamic rows for selected sport
        return true
    end if

    return false
end function
