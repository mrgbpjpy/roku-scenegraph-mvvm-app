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

    ' MUST match the id="" of each screen node in your Scene/AppScene XML
    m.screenNodeIds = [ "homeScreen", "liveScreen", "sportsScreen", "settingsScreen" ]

    m.currentIndex = 0

    if m.focusUnderline <> invalid then
        m.focusUnderline.visible = true
    end if

    UpdateHighlight()

    ' Logical NavBar: parent owns focus, but internal group receives key events
    m.menuGroup.setFocus(true)
end sub

sub onFocusChanged(isFocused as Boolean)
    print "NavBar onFocusChanged: "; isFocused

    if m.focusUnderline <> invalid then
        m.focusUnderline.visible = isFocused
    end if
end sub

' Move focus into the screen that matches the current tab
function FocusCurrentScreen() as Boolean
    scene = m.top.getScene()
    if scene = invalid then
        print "NavBar: getScene() returned invalid"
        return false
    end if

    if m.currentIndex < 0 or m.currentIndex >= m.screenNodeIds.count() then
        print "NavBar: currentIndex out of range: "; m.currentIndex
        return false
    end if

    screenId = m.screenNodeIds[m.currentIndex]
    print "NavBar: trying to focus screen id = "; screenId

    screenNode = scene.findNode(screenId)
    if screenNode = invalid then
        print "NavBar: screenNode INVALID for id = "; screenId
        return false
    end if

    if not screenNode.focusable then
        print "NavBar: screenNode is not focusable: "; screenId
    end if

    print "NavBar: setFocus(true) on "; screenId
    screenNode.setFocus(true)

    return true
end function

function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false

    print "NavBar onKeyEvent key="; key; " index="; m.currentIndex

    if key = "right" then
        m.currentIndex = (m.currentIndex + 1) mod m.tabs.Count()
        UpdateHighlight()
        return true

    else if key = "left" then
        m.currentIndex = m.currentIndex - 1
        if m.currentIndex < 0 then m.currentIndex = m.tabs.Count() - 1
        UpdateHighlight()
        return true

    else if key = "OK" then
        ' Tell MainScene which tab; MainScene will switch & move focus
        m.top.selectedId = m.tabIds[m.currentIndex]
        return true

    else if key = "down" then
        ' For now, don't force focus from here.
        return false
    end if

    return false
end function

sub UpdateHighlight()
    if m.focusUnderline = invalid then return

    ' Dim all tabs
    for each t in m.tabs
        t.color = "0xAAAAAAFF"
    end for

    ' Highlight current tab
    currentTab = m.tabs[m.currentIndex]
    currentTab.color = "0xFFFFFFFF"

    ' Optional pixel offsets (fields on the NavBar component)
    offsetX = m.top.underlineOffsetX
    offsetY = m.top.underlineOffsetY

    ' --- Get tab rect in NavBar coordinates (not just inside menuGroup) ---
    tabRect   = currentTab.boundingRect()      ' coords relative to menuGroup
    groupPos  = m.menuGroup.translation        ' menuGroup coords relative to NavBar

    tabX      = groupPos[0] + tabRect.x        ' now in NavBar space
    tabY      = groupPos[1] + tabRect.y
    tabWidth  = tabRect.width
    tabHeight = tabRect.height

    ' --- Underline width: almost full tab width (slightly inset) ---
    margin = 12                                ' shrink a bit from each side
    underlineWidth = tabWidth - (margin * 2)
    if underlineWidth < 0 then underlineWidth = tabWidth

    ' --- Center underline under the tab ---
    centerX = tabX + (tabWidth / 2.0)
    x = centerX - (underlineWidth / 2.0) + offsetX
    y = tabY + tabHeight + 8 + offsetY         ' 8px below the tab

    m.focusUnderline.width       = underlineWidth
    m.focusUnderline.translation = [ x, y ]
end sub
