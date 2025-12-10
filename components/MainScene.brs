' ============================================================
'  MainScene.brs - FINAL, FADE-SAFE, CHILD-CALLABLE VERSION
' ============================================================

sub init()
    m.top.backgroundColor = "0x000000FF"

    ' UI references
    m.navBar        = m.top.findNode("navBar")
    m.screenLayer   = m.top.findNode("screenLayer")
    m.detailLayer   = m.top.findNode("detailLayer")
    m.detailScreen  = m.top.findNode("detailScreen")
    m.debugLabel    = m.top.findNode("debugLabel")

    ' Intro references
    m.introLayer    = m.top.findNode("introLayer")
    m.introScreen   = m.top.findNode("introScreen")
    m.introFadeAnim = m.top.findNode("introFadeAnim")

    m.currentScreen = invalid

    InitScreenStack()

    ' -------------------------------------------------------
    ' Bind interface functions so FeatureScreen can call them
    ' -------------------------------------------------------
    m.top.ShowDetail = ShowDetail
    m.top.HideDetail = HideDetail

    ' -------------------------------------------------------
    ' Splash video end event
    ' -------------------------------------------------------
    if m.introScreen <> invalid
        m.introScreen.observeField("done", "OnIntroFinished")
    end if

    ' -------------------------------------------------------
    ' NavBar selection listener
    ' -------------------------------------------------------
    m.navBar.observeField("selectedId", "OnNavSelectionChanged")

    ' -------------------------------------------------------
    ' Load initial screen
    ' -------------------------------------------------------
    m.navBar.selectedId = "home"
    FocusScreenById("home")

    print "MainScene initialized and ready"
end sub


' ============================================================
' Splash finished → start fade anim
' ============================================================
sub OnIntroFinished()
    print "Intro finished — beginning fade"

    if m.introFadeAnim <> invalid
        m.introFadeAnim.observeField("state", "OnFadeComplete")
        m.introFadeAnim.control = "start"
    end if
end sub


' ============================================================
' Fade completed → hide intro + give UI focus
' ============================================================
sub OnFadeComplete()
    if m.introFadeAnim.state = "stopped"
        print "Fade complete — hiding splash layer"
        if m.introLayer <> invalid
            m.introLayer.visible = false
        end if

        m.navBar.setFocus(true)
    end if
end sub


' ============================================================
' NavBar tab switched
' ============================================================
sub OnNavSelectionChanged()
    id = m.navBar.selectedId
    m.debugLabel.text = "Selected: " + id
    FocusScreenById(id)
end sub


' ============================================================
' Screen loading
' ============================================================
sub FocusScreenById(id as String)
    screen = invalid

    if id = "feature"
        screen = CreateObject("roSGNode", "FeatureScreen")
    else if id = "home"
        screen = CreateObject("roSGNode", "HomeScreen")
    else if id = "live"
        screen = CreateObject("roSGNode", "LiveScreen")
    else if id = "sports"
        screen = CreateObject("roSGNode", "SportsScreen")
    else if id = "settings"
        screen = CreateObject("roSGNode", "SettingsScreen")
    else
        print "Unknown screen id: "; id
        return
    end if

    ShowScreenInLayer(screen, m.screenLayer)

    m.currentScreen = screen
    screen.setFocus(true)

    print "Loaded screen: "; id
end sub


' ============================================================
' Open DetailScreen
' ============================================================
sub ShowDetail(data as Object)
    if m.detailScreen = invalid or m.detailLayer = invalid
        print "Cannot open detail — missing component"
        return
    end if

    m.detailScreen.itemData = data
    m.detailLayer.visible = true
    m.detailScreen.setFocus(true)
end sub


' ============================================================
' Close DetailScreen
' ============================================================
sub HideDetail()
    m.detailLayer.visible = false

    if m.currentScreen <> invalid
        m.currentScreen.setFocus(true)
    end if
end sub


' ============================================================
' BACK button handler
' ============================================================
function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false

    if key = "back" and m.detailLayer.visible
        HideDetail()
        return true
    end if

    if key = "back"
        if m.navBar.hasFocus()
            return false   ' allow exiting the app
        else
            m.navBar.setFocus(true)
            return true
        end if
    end if

    return false
end function
