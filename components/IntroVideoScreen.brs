sub init()
    m.video = m.top.findNode("videoPlayer")
    m.bg    = m.top.findNode("bg")

    ' -------------------------------------------------------------
    ' Create a valid ContentNode for the splash video
    ' -------------------------------------------------------------
    contentNode = CreateObject("roSGNode", "ContentNode")
    contentNode.url = "pkg:/videos/ESPN_Splash.mp4"
    contentNode.streamformat = "mp4"

    m.video.content = contentNode

    ' -------------------------------------------------------------
    ' Listen for when the video finishes or errors out
    ' -------------------------------------------------------------
    m.video.observeField("state", "onVideoStateChange")

    ' -------------------------------------------------------------
    ' Start playback (after focus is safely applied)
    ' -------------------------------------------------------------
    m.top.setFocus(true)
    m.video.control = "play"
end sub


sub onVideoStateChange()
    state = m.video.state
    print "Intro video state: "; state

    if state = "finished" or state = "error"
        print "Intro finished — signaling MainScene"
        m.top.done = true
    end if
end sub
