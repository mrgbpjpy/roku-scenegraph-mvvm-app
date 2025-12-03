sub init()
    m.navBar        = m.top.findNode("navBar")
    m.homeScreen    = m.top.findNode("homeScreen")
    m.searchScreen  = m.top.findNode("searchScreen")
    m.liveScreen    = m.top.findNode("liveScreen")
    m.sportsScreen  = m.top.findNode("sportsScreen")
    m.replaysScreen = m.top.findNode("replaysScreen")
    m.profileScreen = m.top.findNode("profileScreen")
    m.settingsScreen= m.top.findNode("settingsScreen")

    if m.navBar <> invalid then
        m.navBar.setFocus(true)
        m.navBar.observeField("selectedId", "onNavChanged")
    end if

    ' Start with Home visible
    hideAll()
    if m.homeScreen <> invalid then m.homeScreen.visible = true
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    ' Let NavBar or subscreens handle keys directly
    return false
end function

sub onNavChanged()
    if m.navBar = invalid then return

    id = m.navBar.selectedId
    print "AppScene onNavChanged: "; id

    hideAll()

    if id = "home" then
        if m.homeScreen <> invalid then m.homeScreen.visible = true
    else if id = "search" then
        if m.searchScreen <> invalid then m.searchScreen.visible = true
    else if id = "live" then
        if m.liveScreen <> invalid then m.liveScreen.visible = true
    else if id = "sports" then
        if m.sportsScreen <> invalid then m.sportsScreen.visible = true
    else if id = "replays" then
        if m.replaysScreen <> invalid then m.replaysScreen.visible = true
    else if id = "profile" then
        if m.profileScreen <> invalid then m.profileScreen.visible = true
    else if id = "settings" then
        if m.settingsScreen <> invalid then m.settingsScreen.visible = true
    end if
end sub

sub focusNavBar()
    if m.navBar <> invalid then
        m.navBar.setFocus(true)
    end if

    if m.liveScreen <> invalid then
        m.liveScreen.callFunc("hideCursor")
    end if
end sub

sub hideAll()
    if m.homeScreen    <> invalid then m.homeScreen.visible    = false
    if m.searchScreen  <> invalid then m.searchScreen.visible  = false
    if m.liveScreen    <> invalid then m.liveScreen.visible    = false
    if m.sportsScreen  <> invalid then m.sportsScreen.visible  = false
    if m.replaysScreen <> invalid then m.replaysScreen.visible = false
    if m.profileScreen <> invalid then m.profileScreen.visible = false
    if m.settingsScreen<> invalid then m.settingsScreen.visible= false
end sub

' Called by NavBar on DOWN/OK
sub enterCurrentScreen()
    if m.navBar = invalid then return

    id = m.navBar.selectedId
    print "AppScene enterCurrentScreen: "; id

    if id = "home" then
        if m.homeScreen <> invalid then m.homeScreen.callFunc("giveFocus")
    else if id = "live" then
        if m.liveScreen <> invalid then m.liveScreen.callFunc("giveFocus")
    else if id = "search" then
        if m.searchScreen <> invalid then m.searchScreen.callFunc("giveFocus")
    else if id = "sports" then
        if m.sportsScreen <> invalid then m.sportsScreen.callFunc("giveFocus")
    else if id = "replays" then
        if m.replaysScreen <> invalid then m.replaysScreen.callFunc("giveFocus")
    else if id = "profile" then
        if m.profileScreen <> invalid then m.profileScreen.callFunc("giveFocus")
    else if id = "settings" then
        if m.settingsScreen <> invalid then m.settingsScreen.callFunc("giveFocus")
    end if
end sub

' Called by subscreens when they want to return focus
sub focusNavBar()
    if m.navBar <> invalid then
        m.navBar.setFocus(true)
    end if
end sub
