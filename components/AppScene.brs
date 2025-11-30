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

    showHome()
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    ' Let NavBar handle keys – this keeps the “working pattern”
    return false
end function

sub onNavChanged()
    if m.navBar = invalid then return

    id = m.navBar.selectedId
    print "AppScene onNavChanged: "; id

    if id = "home" then
        showHome()
    else if id = "search" then
        showSearch()
    else if id = "live" then
        showLive()
    else if id = "sports" then
        showSports()
    else if id = "replays" then
        showReplays()
    else if id = "profile" then
        showProfile()
    else if id = "settings" then
        showSettings()
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

sub showHome()
    hideAll()
    if m.homeScreen <> invalid then m.homeScreen.visible = true
end sub

sub showSearch()
    hideAll()
    if m.searchScreen <> invalid then m.searchScreen.visible = true
end sub

sub showLive()
    hideAll()
    if m.liveScreen <> invalid then m.liveScreen.visible = true
end sub

sub showSports()
    hideAll()
    if m.sportsScreen <> invalid then m.sportsScreen.visible = true
end sub

sub showReplays()
    hideAll()
    if m.replaysScreen <> invalid then m.replaysScreen.visible = true
end sub

sub showProfile()
    hideAll()
    if m.profileScreen <> invalid then m.profileScreen.visible = true
end sub

sub showSettings()
    hideAll()
    if m.settingsScreen <> invalid then m.settingsScreen.visible = true
end sub
