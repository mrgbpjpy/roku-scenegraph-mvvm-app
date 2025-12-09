sub init()
    m.title    = m.top.findNode("title")
    m.liveMenu = m.top.findNode("liveMenu")
    m.cursor   = m.top.findNode("cursor")

    m.options = [
        m.top.findNode("opt1"),
        m.top.findNode("opt2"),
        m.top.findNode("opt3"),
        m.top.findNode("opt4")
    ]

    m.currentIndex = 0

    ' Watch focus so we can toggle the yellow line
    m.top.observeField("hasFocus", "onFocusChanged")

    updateMenuVisuals()
end sub

sub onFocusChanged()
    isFocused = m.top.hasFocus()
    print "LiveScreen hasFocus = "; isFocused

    if m.cursor <> invalid then
        m.cursor.visible = isFocused
    end if

    if isFocused then
        updateMenuVisuals()
    end if
end sub

sub updateMenuVisuals()
    if m.options = invalid or m.options.count() = 0 then return

    ' Label colors
    for i = 0 to m.options.count() - 1
        opt = m.options[i]
        if i = m.currentIndex then
            opt.color = &hFFFFFFFF
        else
            opt.color = &hAAAAAAFF
        end if
    end for

    ' Underline position
    if m.cursor = invalid then return

    selected = m.options[m.currentIndex]
    rect = selected.localBoundingRect()

    m.cursor.translation = [rect.x, rect.y + rect.height + 4]
    m.cursor.width       = rect.width
    m.cursor.height      = 4
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false

    print "LiveScreen onKeyEvent: "; key; " index="; m.currentIndex

    if key = "down" then
        if m.currentIndex < m.options.count() - 1 then
            m.currentIndex = m.currentIndex + 1
            updateMenuVisuals()
        end if
        return true

    else if key = "up" then
        if m.currentIndex > 0 then
            ' Move up within the Live menu
            m.currentIndex = m.currentIndex - 1
            updateMenuVisuals()
            return true
        else
            ' 🔝 At top of list → give focus back to NavBar
            scene = m.top.getScene()
            if scene <> invalid then
                navBar = scene.findNode("navBar")  ' id="navBar" in MainScene.xml
                if navBar <> invalid then
                    print "LiveScreen: handing focus back to NavBar"
                    navBar.setFocus(true)
                    return true
                else
                    print "LiveScreen: navBar node not found"
                end if
            else
                print "LiveScreen: getScene() returned invalid"
            end if
        end if

    else if key = "OK" or key = "select" then
        print "LiveScreen selected index = "; m.currentIndex
        ' TODO: real actions here
        return true
    end if

    return false
end function
