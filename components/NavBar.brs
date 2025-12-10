sub init()
    m.menuGroup      = m.top.findNode("menuGroup")
    m.tabFeatured    = m.top.findNode("tabFeatured")
    m.tabHome        = m.top.findNode("tabHome")
    m.tabLive        = m.top.findNode("tabLive")
    m.tabSports      = m.top.findNode("tabSports")
    m.tabSettings    = m.top.findNode("tabSettings")

    m.focusUnderline = m.top.findNode("focusUnderline")
    m.measureLabel   = m.top.findNode("measureLabel")

    ' -------------------------------------------------------
    ' Tabs — Featured is now fully focusable (index 0)
    ' -------------------------------------------------------
    m.tabs = [
        m.tabFeatured,   ' index 0
        m.tabHome,       ' index 1
        m.tabLive,       ' index 2
        m.tabSports,     ' index 3
        m.tabSettings    ' index 4
    ]

    ' IDs that NavBar communicates to MainScene
    m.tabIds = [
        "feature",
        "home",
        "live",
        "sports",
        "settings"
    ]

    ' Default starting tab
    m.currentIndex = 0      ' Featured (focusable)
    'm.currentIndex = 1     ' Uncomment to start on Home instead

    if m.focusUnderline <> invalid then
        m.focusUnderline.visible = true
    end if

    UpdateHighlight()

    ' NavBar receives focus
    m.menuGroup.setFocus(true)
end sub


' -------------------------------------------------------
' Focus underline visibility
' -------------------------------------------------------
sub onFocusChanged(isFocused as Boolean)
    if m.focusUnderline <> invalid then
        m.focusUnderline.visible = isFocused
    end if
end sub


' -------------------------------------------------------
' Key handling for tab navigation
' -------------------------------------------------------
function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false

    if key = "right"
        m.currentIndex = m.currentIndex + 1
        if m.currentIndex >= m.tabs.count()
            m.currentIndex = 0
        end if

        UpdateHighlight()
        return true

    else if key = "left"
        m.currentIndex = m.currentIndex - 1
        if m.currentIndex < 0
            m.currentIndex = m.tabs.count() - 1
        end if

        UpdateHighlight()
        return true

    else if key = "OK"
        ' Send selected tab ID to MainScene
        m.top.selectedId = m.tabIds[m.currentIndex]
        return true

    else if key = "down"
        ' Allow focus to leave the NavBar
        return false
    end if

    return false
end function


' -------------------------------------------------------
' Highlight active tab + position ESPN-style underline
' -------------------------------------------------------
sub UpdateHighlight()
    if m.focusUnderline = invalid then return

    ' Dim all tabs
    for each t in m.tabs
        t.color = "0xAAAAAAFF"
    end for

    ' Highlight selected tab
    currentTab = m.tabs[m.currentIndex]
    currentTab.color = "0xFFFFFFFF"

    ' Compute underline width via measurement label
    m.measureLabel.text = currentTab.text
    textRect = m.measureLabel.boundingRect()

    ' Bounding rect of tab relative to NavBar
    tabRect  = currentTab.boundingRect()
    groupPos = m.menuGroup.translation

    labelX = groupPos[0] + tabRect.x
    labelY = groupPos[1] + tabRect.y

    underlineWidth = textRect.width

    ' Center underline beneath tab text
    x = labelX + (tabRect.width - underlineWidth) / 2 + m.top.underlineOffsetX
    y = labelY + tabRect.height + 10 + m.top.underlineOffsetY

    m.focusUnderline.width       = underlineWidth
    m.focusUnderline.translation = [x, y]
end sub
