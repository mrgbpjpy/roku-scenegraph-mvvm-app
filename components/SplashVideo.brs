' ============================================================
'  SplashVideo.brs — ESPN Intro Splash Video Component (FINAL)
' ============================================================

sub init()
    print "SPLASH: init()"

    m.video = m.top.findNode("videoPlayer")
    m.bg    = m.top.findNode("bg")

    m.hasFinished = false

    ' ------------------------------------------------------------
    ' Build ContentNode
    ' ------------------------------------------------------------
    content = CreateObject("roSGNode", "ContentNode")
    content.streamFormat = "mp4"
    content.url = "https://videos.erickrokudev.org/ESPN_Splash.mp4"

    m.video.content = content

    ' ------------------------------------------------------------
    ' Observe playback state
    ' ------------------------------------------------------------
    m.video.observeField("state", "OnVideoStateChanged")

    ' ------------------------------------------------------------
    ' Start playback AFTER init completes
    ' ------------------------------------------------------------
    StartPlayback()
end sub


' ============================================================
' Start video safely
' ============================================================
sub StartPlayback()
    if m.video = invalid then return

    print "SPLASH: ▶️ Starting ESPN splash video"

    ' Must be visible BEFORE play
    m.bg.visible    = true
    m.video.visible = true

    m.video.control = "stop"
    m.video.control = "play"
end sub


' ============================================================
' Handle video lifecycle
' ============================================================
sub OnVideoStateChanged()
    state = m.video.state
    print "SPLASH: video state → "; state

    ' Only treat real endings as completion
    if state = "finished" or state = "error"
        FinishSplash()
    end if
end sub


' ============================================================
' Allow user to skip splash
' ============================================================
function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false

    if key = "OK" or key = "back" or key = "play"
        print "SPLASH: ⏭️ User skipped splash"
        FinishSplash()
        return true
    end if

    return false
end function


' ============================================================
' Cleanup + notify MainScene (ONCE)
' ============================================================
sub FinishSplash()
    if m.hasFinished then return
    m.hasFinished = true

    print "SPLASH: 🎬 Finished — notifying MainScene"

    if m.video <> invalid
        m.video.control = "stop"
        m.video.visible = false
    end if

    if m.bg <> invalid
        m.bg.visible = false
    end if

    ' Notify MainScene
    m.top.finished = true
end sub
