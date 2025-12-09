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

    ' ⚠️ MUST match the id="" of each screen node in your Scene/AppScene XML
    ' Example:
    '   <HomeScreen  id="homeScreen" .../>
    '   <LiveScreen  id="liveScreen" .../>
    '   <SportsScreen id="sportsScreen" .../>
    '   <SettingsScreen id="settingsScreen" .../>
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

' 🔧 Helper: move focus into the screen that matches the current tab
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
        ' ✅ ONLY tells MainScene which tab; MainScene will switch & move focus
        m.top.selectedId = m.tabIds[m.currentIndex]
        return true

    else if key = "down" then
        ' For now, don't force focus from here. We’ll wire DOWN later if needed.
        return false
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

    ' Measure text for underline width
    m.measureLabel.text = currentTab.text
    measureRect = m.measureLabel.boundingRect()
    textWidth = measureRect.width

    underlinePadding = 12
    underlineWidth = textWidth + underlinePadding * 2

    rect = currentTab.boundingRect()
    x = rect.x + (rect.width - underlineWidth) / 2
    y = rect.y + rect.height + 8

    m.focusUnderline.width = underlineWidth
    m.focusUnderline.translation = [x, y]
end sub
