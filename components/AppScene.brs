sub init()
    m.navBar     = m.top.findNode("navBar")
    m.liveScreen = m.top.findNode("liveScreen")
    m.debugLabel = m.top.findNode("debugLabel")

    ' Start with NavBar focused
    m.navBar.setFocus(true)

    if m.debugLabel <> invalid then
        m.debugLabel.text = "Debug(init): focus=NavBar"
    end if
end sub
