' =========================================================
' MainScene.brs — DEBUG / TRACE VERSION
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
    m.featuredScreen = m.top.findNode("featuredScreen")
    m.homeScreen     = m.top.findNode("homeScreen")
    m.liveScreen     = m.top.findNode("liveScreen")
    m.sportsScreen   = m.top.findNode("sportsScreen")
    m.settingsScreen = m.top.findNode("settingsScreen")

    print "MAIN ▶ Screens:"
    print "  featured =", m.featuredScreen
    print "  home     =", m.homeScreen
    print "  live     =", m.liveScreen
    print "  sports   =", m.sportsScreen
    print "  settings =", m.settingsScreen

    ' -----------------------------
    ' State
    ' -----------------------------
    m.currentScreen     = invalid
    m.lastFocusedScreen = invalid
    m.detailOpen        = false
    m.isPlayingVideo    = false

    InitScreenStack()

    if m.splash <> invalid
        m.splash.observeField("finished", "OnSplashFinished")
    end if

    print "MAIN ▶ init() COMPLETE"
    print "=============================="
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

    m.navBarLayer.visible = true
    m.screenLayer.visible = true

    m.navBar.observeField("selectedId", "OnNavSelectionChanged")

    m.navBar.selectedId = "featured"
    FocusScreenById("featured")

    m.navBar.setFocus(true)

    print "MAIN ▶ Splash exit complete"
end sub


' =========================================================
' NavBar selection
' =========================================================
sub OnNavSelectionChanged()
    print "MAIN ▶ OnNavSelectionChanged()"

    if m.detailOpen then
        print "MAIN ⚠️ Nav ignored — detailOpen"
        return
    end if

    if m.isPlayingVideo then
        print "MAIN ⚠️ Nav ignored — video playing"
        return
    end if

    print "MAIN ▶ Nav selected:", m.navBar.selectedId
    m.debugLabel.text = "Selected: " + m.navBar.selectedId

    FocusScreenById(m.navBar.selectedId)
end sub


' =========================================================
' Screen switching
' =========================================================
sub FocusScreenById(id as String)
    print "MAIN ▶ FocusScreenById(", id, ")"

    idLower = LCase(id)

    screens = {
        featured: m.featuredScreen
        home: m.homeScreen
        live: m.liveScreen
        sports: m.sportsScreen
        settings: m.settingsScreen
    }

    for each key in screens
        if screens[key] <> invalid
            screens[key].visible = false
        end if
    end for

    if screens[idLower] <> invalid
        screens[idLower].visible = true
        screens[idLower].setFocus(true)
        m.currentScreen = screens[idLower]
        print "MAIN ▶ Active screen:", idLower
    else
        print "MAIN ❌ Unknown screen id:", id
    end if
end sub


' =========================================================
' Show Detail Modal
' =========================================================
sub ShowDetail(data as Object)
    print "=============================="
    print "MAIN ▶ ShowDetail()"
    print "=============================="

    if data = invalid then
        print "MAIN ❌ ShowDetail called with INVALID data"
        return
    end if

    if m.detailOpen then
        print "MAIN ⚠️ Detail already open"
        return
    end if

    print "MAIN ▶ Detail data:"
    print data

    m.detailOpen = true
    m.lastFocusedScreen = m.currentScreen

    print "MAIN ▶ lastFocusedScreen =", m.lastFocusedScreen

    m.navBarLayer.visible = false
    m.screenLayer.visible = false

    m.detailLayer.visible = true
    m.detailScreen.itemData = data
    m.detailScreen.setFocus(true)

    print "MAIN ▶ DetailScreen visible + focused"
end sub


' =========================================================
' START VIDEO PLAYBACK
' =========================================================
sub StartPlayback(data as Object)
    print "=============================="
    print "MAIN ▶ StartPlayback()"
    print "=============================="

    if data = invalid then
        print "MAIN ❌ StartPlayback invalid data"
        return
    end if

    print "MAIN ▶ Playing:", data.title

    m.isPlayingVideo = true
    m.detailOpen = false

    m.detailLayer.visible = false
    m.navBarLayer.visible = false
    m.screenLayer.visible = false

    m.mainVideo.control = "stop"

    videoContent = CreateObject("roSGNode", "ContentNode")
    videoContent.url = data.videoUrl
    videoContent.streamFormat = "mp4"
    videoContent.title = data.title

    m.mainVideo.content = videoContent
    m.mainVideo.visible = true
    m.mainVideo.control = "play"
    m.mainVideo.setFocus(true)

    print "MAIN ▶ Video started"
end sub


' =========================================================
' STOP VIDEO
' =========================================================
sub StopPlayback()
    print "=============================="
    print "MAIN ▶ StopPlayback()"
    print "=============================="

    m.isPlayingVideo = false

    m.mainVideo.control = "stop"
    m.mainVideo.visible = false

    m.navBarLayer.visible = true
    m.screenLayer.visible = true

    if m.lastFocusedScreen <> invalid
        print "MAIN ▶ Restoring focus to last screen"
        m.lastFocusedScreen.setFocus(true)
    else
        print "MAIN ⚠️ No lastFocusedScreen"
    end if
end sub


' =========================================================
' Close Detail Modal — FINAL, FOCUS-SAFE
' =========================================================
sub HideDetail_afterFade()
    print "=============================="
    print "MAIN ▶ HideDetail_afterFade()"
    print "=============================="

    ' ------------------------------------------------
    ' Reset state flags FIRST
    ' ------------------------------------------------
    m.detailOpen = false

    ' ------------------------------------------------
    ' HARD RELEASE focus from DetailScreen
    ' ------------------------------------------------
    if m.detailScreen <> invalid
        m.detailScreen.setFocus(false)
    end if

    ' ------------------------------------------------
    ' Hide detail modal layer completely
    ' ------------------------------------------------
    if m.detailLayer <> invalid
        m.detailLayer.visible = false
    end if

    ' ------------------------------------------------
    ' Restore main UI layers
    ' ------------------------------------------------
    if m.navBarLayer <> invalid
        m.navBarLayer.visible = true
    end if

    if m.screenLayer <> invalid
        m.screenLayer.visible = true
    end if

    ' ------------------------------------------------
    ' Restore focus to last active screen
    ' ------------------------------------------------
    if m.lastFocusedScreen <> invalid
        print "MAIN ▶ Restoring focus to last screen:", m.lastFocusedScreen.id

        m.lastFocusedScreen.visible = true
        m.lastFocusedScreen.setFocus(true)
    else
        print "MAIN ⚠️ No lastFocusedScreen to restore"
    end if

    ' ------------------------------------------------
    ' Re-enable NavBar observation ONLY
    ' ------------------------------------------------
    if m.navBar <> invalid
        m.navBar.observeField("selectedId", "OnNavSelectionChanged")
    end if

    print "MAIN ▶ Detail closed — focus restored"
end sub




' =========================================================
' Global BACK handling
' =========================================================
function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false

    print "MAIN ▶ onKeyEvent:", key

    if m.isPlayingVideo and key = "back"
        print "MAIN ▶ BACK → stopping video"
        StopPlayback()
        return true
    end if

    return false
end function
