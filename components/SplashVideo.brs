' ============================================================
'  SplashVideo.brs — ESPN Intro Splash Video Component
' ============================================================

sub init()
    m.video   = m.top.findNode("videoPlayer")
    m.bg      = m.top.findNode("bg")

    ' Play the intro video file
    m.video.content = {
        url: "pkg:/videos/ESPN_Splash.mp4"
    }

    ' When the video finishes
    m.video.observeField("state", "OnVideoStateChanged")

    ' Start playback immediately
    m.video.control = "play"

    ' Allow user to skip with OK or BACK
    m.top.setFocus(true)
end sub


' ============================================================
' Video state handler
' ============================================================
sub OnVideoStateChanged()
    state = m.video.state

    if state = "finished" or state = "error"
        FinishSplash()
    end if
end sub


' ============================================================
' Skip splash via remote
' ============================================================
function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false

    if key = "OK" or key = "back" or key = "play"
        FinishSplash()
        return true
    end if

    return false
end function


' ============================================================
' Finish splash → notify MainScene
' ============================================================
sub FinishSplash()
    ' Fade-out effect (optional)
    m.bg.opacity = 0.0
    m.video.control = "stop"

    m.top.finished = true
end sub
