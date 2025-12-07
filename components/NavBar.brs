sub init()
    m.menuGroup      = m.top.findNode("menuGroup")
    m.tabHome        = m.top.findNode("tabHome")
    m.tabLive        = m.top.findNode("tabLive")
    m.tabSports      = m.top.findNode("tabSports")
    m.tabSettings    = m.top.findNode("tabSettings")
    m.focusUnderline = m.top.findNode("focusUnderline")
    m.measureLabel   = m.top.findNode("measureLabel")  ' 👈 add this

    ' Menu order and IDs
    m.tabs    = [ m.tabHome, m.tabLive, m.tabSports, m.tabSettings ]
    m.tabIds  = [ "home", "live", "sports", "settings" ]
    m.currentIndex = 0

    UpdateHighlight()

        ' 🔥 REQUIRED for LEFT/RIGHT to work
    m.menuGroup.setFocus(true)
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false

    if key = "right"
        m.currentIndex = (m.currentIndex + 1) mod m.tabs.Count()
        UpdateHighlight()
        return true
    else if key = "left"
        m.currentIndex = (m.currentIndex - 1)
        if m.currentIndex < 0 then m.currentIndex = m.tabs.Count() - 1
        UpdateHighlight()
        return true
    else if key = "OK" or key = "down"
        ' Update selectedId so MainScene can switch screens
        m.top.selectedId = m.tabIds[m.currentIndex]
        return true
    end if

    return false
end function

sub UpdateHighlight()
    ' Dim all tabs
    for each t in m.tabs
        t.color = "0xAAAAAAFF"
    end for

    ' Highlight current tab
    currentTab = m.tabs[m.currentIndex]
    currentTab.color = "0xFFFFFFFF"

    ' Label's bounding rect (approx position)
    rect = currentTab.boundingRect()

    ' --- Measure actual text width using hidden Label ---
    measureLabel = m.top.findNode("measureLabel")
    measureLabel.text = currentTab.text

    textRect = measureLabel.boundingRect()
    textWidth = textRect.width

    underlineWidth = m.focusUnderline.width

    ' Center underline under actual rendered text
    x =   rect.x + rect.width / 2 + 40 ' 40 is adjustment in pixels of the Rect

    ' Place underline below label
    y = rect.y + rect.height + 20  ' 5 pixels below

    m.focusUnderline.translation = [x, y]
end sub
