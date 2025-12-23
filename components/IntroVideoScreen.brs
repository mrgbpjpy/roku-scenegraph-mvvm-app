sub init()
    m.video = m.top.findNode("videoPlayer")
    m.bg    = m.top.findNode("bg")

    ' ---------------------------------------------
    ' Build ContentNode for the splash video
    ' ---------------------------------------------
    contentNode = CreateObject("roSGNode", "ContentNode")
    contentNode.url = "https://videos.erickrokudev.org/ESPN_Splash.mp4"
    contentNode.streamFormat = "mp4"

    m.video.content = contentNode

    ' ---------------------------------------------
    ' Monitor video state (MUST be before play)
    ' ---------------------------------------------
    m.video.observeField("state", "onVideoStateChange")

    ' ---------------------------------------------
    ' Small delay before starting playback
    ' Helps slower Roku models buffer correctly
    ' ---------------------------------------------
    m.top.setFocus(true)
    m.top.callFunc("StartVideo")
end sub

sub enterMenu()
    print "HOME ▶ enterMenu()"
    m.rowList.setFocus(true)
end sub


' ---------------------------------------------
' Start video after the screen initializes
' ---------------------------------------------
sub StartVideo()
    print "▶️ Starting intro splash video"
    m.video.control = "play"
end sub


' ---------------------------------------------
' Handle completion or playback error
' ---------------------------------------------
sub onVideoStateChange()
    state = m.video.state
    print "Intro video state: "; state

    ' Some Roku models report “stopped” instead of “finished”
    if state = "finished" or state = "error" or state = "stopped"
        print "🎬 Intro complete — notifying MainScene"
        m.top.done = true      ' Fires field observer in MainScene
    end if
end sub
