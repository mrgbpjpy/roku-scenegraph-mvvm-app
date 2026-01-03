' =========================================================
' MainScene.brs — DEBUG / TRACE VERSION (STEP 3 FINAL)
' =========================================================

sub init()
    print "=============================="
    print "MAIN ▶ init() START"
    print "=============================="

    m.top.backgroundColor = "0x000000FF"

    ' -----------------------------
    ' Core nodes
    ' -----------------------------
    m.splash        = m.top.findNode("splash")
    m.navBar        = m.top.findNode("navBar")
    m.navBarLayer   = m.top.findNode("navBarLayer")
    m.screenLayer   = m.top.findNode("screenLayer")
    m.detailLayer   = m.top.findNode("detailLayer")
    m.detailScreen  = m.top.findNode("detailScreen")
    m.introLayer    = m.top.findNode("introLayer")
    m.debugLabel    = m.top.findNode("debugLabel")
    m.mainVideo     = m.top.findNode("mainVideo")

    print "MAIN ▶ Nodes:"
    print "  splash       =", m.splash
    print "  navBar       =", m.navBar
    print "  screenLayer  =", m.screenLayer
    print "  detailLayer  =", m.detailLayer
    print "  detailScreen =", m.detailScreen
    print "  mainVideo    =", m.mainVideo
    

    ' -----------------------------
    ' Persistent screens
    ' -----------------------------
    m.featuredScreen        = m.top.findNode("featuredScreen")
    m.homeScreen            = m.top.findNode("homeScreen")
    m.liveScreen            = m.top.findNode("liveScreen")
    m.sportsScreen          = m.top.findNode("sportsScreen")
    m.developerInfoScreen   = m.top.findNode("developerInfoScreen")
    



    print "MAIN ▶ Screens:"
    print "  featured  =", m.featuredScreen
    print "  home      =", m.homeScreen
    print "  live      =", m.liveScreen
    print "  sports    =", m.sportsScreen
    print "  developer =", m.developerInfoScreen

    ' -----------------------------
    ' State
    ' -----------------------------
    m.currentScreen     = invalid
    m.lastFocusedScreen = invalid
    m.detailOpen        = false
    m.isPlayingVideo    = false

    if m.liveScreen <> invalid
        m.liveScreen.observeField("requestDialog", "OnLiveScreenRequestDialog")
    end if

    ' 🔒 IMPORTANT: initialize NavBar reselect flag
    if m.navBar <> invalid
        m.navBar.reselect = false
    end if

    InitScreenStack()

    if m.splash <> invalid
        m.splash.observeField("finished", "OnSplashFinished")
    end if

    if m.sportsScreen <> invalid
    m.sportsScreen.observeField("requestDialog", "OnSportsScreenRequestDialog")
    end if


    print "MAIN ▶ init() COMPLETE"
    print "=============================="
end sub

sub OnDialogButtonSelected()
    if m.top.dialog <> invalid
        print "MAIN ▶ Dialog OK pressed"
        m.top.dialog.close = true
    end if
end sub


sub OnSportsScreenRequestDialog()
    if m.sportsScreen = invalid then return

    dialogType = m.sportsScreen.requestDialog
    print "MAIN ▶ SportsScreen requested dialog:", dialogType

    ' Clear request immediately (important)
    m.sportsScreen.requestDialog = ""

    ' Always clear existing dialog
    m.top.dialog = invalid

    dialog = CreateObject("roSGNode", "InfoDialog")

    if dialogType = "nba"
        dialog.dialogTitle = "NBA"
        dialog.dialogText  = "Scores, highlights, standings, and full game replays from across the NBA."
    else if dialogType = "nfl"
        dialog.dialogTitle = "NFL"
        dialog.dialogText  = "Live games, weekly matchups, replays, and analysis from the NFL."
    else if dialogType = "mlb"
        dialog.dialogTitle = "MLB"
        dialog.dialogText  = "Daily recaps, standings, and top plays from Major League Baseball."
    else if dialogType = "nhl"
        dialog.dialogTitle = "NHL"
        dialog.dialogText  = "Goals, highlights, and full-game coverage from the NHL."
    else if dialogType = "ncaa"
        dialog.dialogTitle = "NCAA"
        dialog.dialogText  = "College sports coverage including football, basketball, and more."
    else
        dialog.dialogTitle = "Sports"
        dialog.dialogText  = "More sports content coming soon."
    end if

    ' Show dialog (focus handled automatically)
    m.top.dialog = dialog
end sub


sub OnLiveScreenRequestDialog()
    if m.liveScreen = invalid then return

    dialogType = m.liveScreen.requestDialog
    m.liveScreen.requestDialog = ""  ' prevent retrigger

    if dialogType = "upcomingGames"
        ' Clear any existing dialog
        m.top.dialog = invalid

        dialog = CreateObject("roSGNode", "InfoDialog")
        dialog.dialogTitle = "Upcoming Games"
        dialog.dialogText = "Lakers vs Warriors – 7:00 PM ET" + chr(10) + "Celtics vs Heat – 9:30 PM ET"

        ' 🔑 THIS IS REQUIRED
        dialog.observeField("buttonSelected", "OnDialogButtonSelected")
        dialog.observeField("wasClosed", "OnDialogClosed")

        m.top.dialog = dialog


        m.top.dialog = dialog

        ' THIS shows the dialog
        m.top.dialog = dialog
    end if

    if dialogType = "highlights"
    m.top.dialog = invalid
    dialog = CreateObject("roSGNode", "InfoDialog")

    dialog.dialogTitle = "Highlights"
    dialog.dialogText = "Top Plays" + chr(10) + "Game Winners" + chr(10) + "Clutch Moments"

    ' 🔑 REQUIRED FOR EVERY DIALOG
    dialog.observeField("buttonSelected", "OnDialogButtonSelected")
    dialog.observeField("wasClosed", "OnDialogClosed")

    m.top.dialog = dialog


end if

end sub



sub OnNavPulse()
    if m.detailOpen or m.isPlayingVideo then return

    id = LCase(m.navBar.selectedId)

    action = "select"
    if m.navBar.navAction <> invalid
        action = m.navBar.navAction
    end if

    print "MAIN ▶ Pulse"
    print "MAIN ▶ Action:", action
    print "MAIN ▶ Target:", id

    ' -----------------------------
    ' ENTER → re-enter current screen
    ' -----------------------------
    if action = "enter" and m.currentScreen <> invalid
        print "MAIN ▶ Re-enter screen:", id

        ' HARD focus transfer
        m.navBar.setFocus(false)
        m.currentScreen.setFocus(true)
        m.currentScreen.callFunc("enterMenu")

        return
    end if

    ' -----------------------------
    ' SELECT → switch screen
    ' -----------------------------
    if m.currentScreenId = id
        print "MAIN ▶ Already active — ignoring select"
        return
    end if

    FocusScreenById(id)
end sub

sub OnDialogClosed()
    print "MAIN ▶ Dialog closed"

    m.top.dialog = invalid

    if m.currentScreen <> invalid
        m.currentScreen.setFocus(true)
    end if
end sub




sub EnterCurrentScreen()
    if m.currentScreen = invalid then return

    print "MAIN ▶ Entering screen menu"

    ' Convention: screens expose enterMenu() if they have one
    if m.currentScreen.hasMethod("enterMenu")
        m.currentScreen.enterMenu()
    else
        ' Fallback: just give focus to screen
        m.currentScreen.setFocus(true)
    end if
end sub



' =========================================================
' Splash → App UI
' =========================================================
sub OnSplashFinished()
    print "MAIN ▶ OnSplashFinished()"

    if m.splash <> invalid
        m.splash.control = "stop"
        m.splash.visible = false
    end if

    if m.introLayer <> invalid
        m.introLayer.visible = false
    end if

    if m.navBarLayer <> invalid then m.navBarLayer.visible = true
    if m.screenLayer <> invalid then m.screenLayer.visible = true

    if m.navBar <> invalid
       ' m.navBar.observeField("selectedId", "OnNavSelectionChanged")
       m.navBar.observeField("navPulse", "OnNavPulse")

        m.navBar.selectedId = "featured"
        m.navBar.setFocus(true)
    end if

    FocusScreenById("featured")

    print "MAIN ▶ Splash exit complete"
end sub


' =========================================================
' NavBar selection (STEP 3 – FINAL, ESPN-STYLE)
' =========================================================
' =========================================================
' NavBar selection — FINAL (Contract-based, ESPN-style)
' =========================================================
sub OnNavSelectionChanged()
    print "MAIN ▶ OnNavSelectionChanged()"

    if m.detailOpen or m.isPlayingVideo then return

    id = LCase(m.navBar.selectedId)

    ' 🔒 ALWAYS initialize action
    action = "select"
    if m.navBar.navAction <> invalid
        action = m.navBar.navAction
    end if

    print "MAIN ▶ Action:", action
    print "MAIN ▶ Target:", id

    ' ---------------------------------
    ' ENTER → HARD re-enter screen
    ' ---------------------------------
    if action = "enter" and m.currentScreen <> invalid
        print "MAIN ▶ Re-enter screen:", id

        ' 1️⃣ Break NavBar focus lock
        m.navBar.setFocus(false)

        ' 2️⃣ Force screen to own focus
        m.currentScreen.setFocus(true)

        ' 3️⃣ Screen decides internal focus
        m.currentScreen.callFunc("enterMenu")

        return
    end if

    ' ---------------------------------
    ' SELECT → switch screen
    ' ---------------------------------
    FocusScreenById(id)
end sub



' =========================================================
' Screen switching (STEP 1 FIX PRESERVED)
' =========================================================
sub FocusScreenById(id as String)
    print "MAIN ▶ FocusScreenById(", id, ")"

    idLower = LCase(id)

    idMap = {
        "featured": "featured"
        "home": "home"
        "live": "live"
        "sports": "sports"
        "developer": "developer"
    }

    if idMap[idLower] <> invalid
        resolvedKey = idMap[idLower]
    else
        resolvedKey = idLower
    end if

    print "MAIN ▶ Requested:", idLower, "→ Resolved:", resolvedKey

    screens = {
        featured:    m.featuredScreen
        home:        m.homeScreen
        live:        m.liveScreen
        sports:      m.sportsScreen
        developer:   m.developerInfoScreen
    }

    for each key in screens
        if screens[key] <> invalid
            screens[key].visible = false
        end if
    end for

    if screens[resolvedKey] <> invalid
        screens[resolvedKey].visible = true
        screens[resolvedKey].setFocus(true)
        m.currentScreen = screens[resolvedKey]
        print "MAIN ▶ Active screen:", resolvedKey
    else
        print "MAIN ❌ Unknown screen key:", resolvedKey
    end if
end sub


' =========================================================
' Show Detail Modal
' =========================================================
sub ShowDetail(data as Object)
    if data = invalid or m.detailOpen then return

    m.detailOpen = true
    m.lastFocusedScreen = m.currentScreen

    if m.navBarLayer <> invalid then m.navBarLayer.visible = false
    if m.screenLayer <> invalid then m.screenLayer.visible = false

    if m.detailLayer <> invalid
        m.detailLayer.visible = true
    end if

    if m.detailScreen <> invalid
        m.detailScreen.itemData = data
        m.detailScreen.setFocus(true)
    end if
end sub


' =========================================================
' START VIDEO PLAYBACK
' =========================================================
sub StartPlayback(data as Object)
    if data = invalid then return

    m.isPlayingVideo = true
    m.detailOpen = false

    if m.detailLayer <> invalid then m.detailLayer.visible = false
    if m.navBarLayer <> invalid then m.navBarLayer.visible = false
    if m.screenLayer <> invalid then m.screenLayer.visible = false

    videoContent = CreateObject("roSGNode", "ContentNode")
    videoContent.url = data.videoUrl
    videoContent.streamFormat = "mp4"
    videoContent.title = data.title

    m.mainVideo.content = videoContent
    m.mainVideo.visible = true
    m.mainVideo.control = "play"
    m.mainVideo.setFocus(true)
end sub


' =========================================================
' STOP VIDEO
' =========================================================
sub StopPlayback()
    m.isPlayingVideo = false

    m.mainVideo.control = "stop"
    m.mainVideo.visible = false

    if m.navBarLayer <> invalid then m.navBarLayer.visible = true
    if m.screenLayer <> invalid then m.screenLayer.visible = true

    if m.lastFocusedScreen <> invalid
        m.lastFocusedScreen.setFocus(true)
    end if
end sub


' =========================================================
' Close Detail Modal
' =========================================================
sub HideDetail_afterFade()
    m.detailOpen = false

    if m.detailScreen <> invalid
        m.detailScreen.setFocus(false)
    end if

    if m.detailLayer <> invalid then m.detailLayer.visible = false
    if m.navBarLayer <> invalid then m.navBarLayer.visible = true
    if m.screenLayer <> invalid then m.screenLayer.visible = true

    if m.lastFocusedScreen <> invalid
        m.lastFocusedScreen.visible = true
        m.lastFocusedScreen.setFocus(true)
    end if
end sub


' =========================================================
' Global BACK handling
' =========================================================
function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false

    if m.isPlayingVideo and key = "back"
        StopPlayback()
        return true
    end if

    return false
end function
