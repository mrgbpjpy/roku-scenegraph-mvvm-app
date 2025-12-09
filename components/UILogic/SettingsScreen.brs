sub init()
    m.cursor = m.top.findNode("cursor")

    m.items = [
        m.top.findNode("st1"),
        m.top.findNode("st2"),
        m.top.findNode("st3"),
        m.top.findNode("st4"),
        m.top.findNode("st5")
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
    ' Reset
    for each item in m.items
        item.color = "0xAAAAAAFF"
    end for

    ' Highlight active
    m.items[m.index].color = "0xFFFFFFFF"

    ' Move highlight cursor
    m.cursor.translation = [60, 140 + m.index * 60]
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false

    if key = "down"
        if m.index < m.items.count() - 1
            m.index++
            updateNav()
        end if
        return true

    else if key = "up"
        if m.index = 0
            navBar = m.top.getScene().findNode("navBar")
            navBar.setFocus(true)
        else
            m.index--
            updateNav()
        end if
        return true

    else if key = "OK"
        print "Selected setting: "; m.items[m.index].text
        return true
    end if

    return false
end function
