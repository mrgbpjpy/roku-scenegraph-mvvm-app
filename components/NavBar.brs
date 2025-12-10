sub init()
    m.menuGroup      = m.top.findNode("menuGroup")
    m.tabHome        = m.top.findNode("tabHome")
    m.tabLive        = m.top.findNode("tabLive")
    m.tabSports      = m.top.findNode("tabSports")
    m.tabSettings    = m.top.findNode("tabSettings")
    m.focusUnderline = m.top.findNode("focusUnderline")
    m.measureLabel   = m.top.findNode("measureLabel")

    ' Menu order and IDs
    m.tabs    = [ m.tabHome, m.tabLive, m.tabSports, m.tabSettings ]
    m.tabIds  = [ "home", "live", "sports", "settings" ]

    m.currentIndex = 0

    ' Ensure underline visible
    if m.focusUnderline <> invalid then
        m.focusUnderline.visible = true
    end if

    UpdateHighlight()

    ' Parent NavBar holds focus; all key events route to it
    m.menuGroup.setFocus(true)
end sub


' -------------------------------------------------------------------
' NavBar focus changes → underline hides/shows accordingly
' -------------------------------------------------------------------
sub onFocusChanged(isFocused as Boolean)
    if m.focusUnderline <> invalid then
        m.focusUnderline.visible = isFocused
    end if
end sub


' -------------------------------------------------------------------
' Main Key Handling
' -------------------------------------------------------------------
function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false

    if key = "right"
        m.currentIndex = (m.currentIndex + 1) mod m.tabs.count()
        UpdateHighlight()
        return true

    else if key = "left"
        m.currentIndex--
        if m.currentIndex < 0 then m.currentIndex = m.tabs.count() - 1
        UpdateHighlight()
        return true

    else if key = "OK"
        ' Notify MainScene which screen to load
        m.top.selectedId = m.tabIds[m.currentIndex]
        return true

    else if key = "down"
        ' Let MainScene handle focus transfer
        return false
    end if

    return false
end function


' -------------------------------------------------------------------
' Update underline + colors
' ESPN-style precision underline alignment
' -------------------------------------------------------------------
sub UpdateHighlight()
    if m.focusUnderline = invalid then return

    ' Dim all tabs
    for each t in m.tabs
        t.color = "0xAAAAAAFF"
    end for

    ' Highlight current tab
    currentTab = m.tabs[m.currentIndex]
    currentTab.color = "0xFFFFFFFF"

    ' Measure real text width
    m.measureLabel.text = currentTab.text
    textRect = m.measureLabel.boundingRect()

    ' Coordinates of tab label relative to NavBar
    tabRect  = currentTab.boundingRect()
    groupPos = m.menuGroup.translation

    labelX = groupPos[0] + tabRect.x
    labelY = groupPos[1] + tabRect.y

    ' Width of underline = real text width
    underlineWidth = textRect.width

    ' Center underline under text
    x = labelX + (tabRect.width - underlineWidth) / 2 + m.top.underlineOffsetX
    y = labelY + tabRect.height + 10 + m.top.underlineOffsetY

    m.focusUnderline.width       = underlineWidth
    m.focusUnderline.translation = [x, y]
end sub
