' ============================================================
' FeatureScreen.brs — auto-plays promo once + WATCH NOW action
' ============================================================

sub init()
    m.bgVideo       = m.top.findNode("bgVideo")
    m.title         = m.top.findNode("featuredTitle")
    m.subtitle      = m.top.findNode("featuredSubtitle")
    m.watchButton   = m.top.findNode("watchButton")

    ' --------------------------------------------------------
    ' Create ContentNode for video (required format)
    ' --------------------------------------------------------
    videoContent = CreateObject("roSGNode", "ContentNode")
    videoContent.url = "pkg:/videos/New_Football_Promo.mp4"
    videoContent.streamFormat = "mp4"

    m.bgVideo.content = videoContent

    ' Listen for playback finishing
    m.bgVideo.observeField("state", "onVideoStateChange")

    ' Auto-play video once
    m.bgVideo.control = "play"

    ' Track focus changes to pause/resume video
    m.top.observeField("hasFocus", "onScreenFocusChanged")

    ' If created with focus, start playing
    if m.top.hasFocus()
        playBackgroundVideo()
    end if

    ' Default UI focus
    m.watchButton.setFocus(true)
end sub


' --------------------------------------------------------
' Auto-play helpers
' --------------------------------------------------------
sub playBackgroundVideo()
    if m.bgVideo <> invalid
        print "FeatureScreen: PLAY promo"
        m.bgVideo.control = "play"
    end if
end sub

sub stopBackgroundVideo()
    if m.bgVideo <> invalid
        print "FeatureScreen: STOP promo"
        m.bgVideo.control = "stop"
    end if
end sub


' --------------------------------------------------------
' Focus changed → play/stop video
' --------------------------------------------------------
sub onScreenFocusChanged()
    if m.top.hasFocus()
        playBackgroundVideo()
    else
        stopBackgroundVideo()
    end if
end sub


' --------------------------------------------------------
' Detect when promo finishes (PLAY ONCE BEHAVIOR)
' --------------------------------------------------------
sub onVideoStateChange()
    state = m.bgVideo.state
    print "Feature Promo Video State: "; state

    if state = "finished"
        print "Promo done — switching NavBar to HOME"

        stopBackgroundVideo()

        scene = m.top.getScene()
        if scene <> invalid
            navBar = scene.findNode("navBar")

            if navBar <> invalid
                navBar.selectedId = "home"
                navBar.setFocus(true)
            end if
        end if
    end if
end sub


' --------------------------------------------------------
' Key handler
' --------------------------------------------------------
function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false

    ' WATCH NOW (opens detail modal)
    if key = "OK"
        print "▶ Feature Watch button pressed!"

        scene = m.top.getScene()
        if scene <> invalid
            scene.ShowDetail({
                title: "Featured Highlight",
                videoUrl: "pkg:/videos/New_Football_Promo.mp4"
            })
        end if

        return true
    end if

    ' BACK → return focus to NavBar
    if key = "back"
        scene = m.top.getScene()
        if scene <> invalid
            navBar = scene.findNode("navBar")

            if navBar <> invalid
                navBar.setFocus(true)
            end if
        end if

        return true
    end if

    return false
end function
