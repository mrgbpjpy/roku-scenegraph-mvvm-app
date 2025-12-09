sub init()
    ' Background styling
    m.top.backgroundColor = "0x000000FF"  ' black

    ' Cache nodes
    m.navBar      = m.top.findNode("navBar")
    m.screenLayer = m.top.findNode("screenLayer")
    m.debugLabel  = m.top.findNode("debugLabel")

    ' Keep track of the currently displayed screen node
    m.currentScreen = invalid

    ' Initialize screen stack (helper from UILogic)
    InitScreenStack()

    ' Observe NavBar selection changes
    m.navBar.ObserveField("selectedId", "OnNavSelectionChanged")

    ' ---- INITIAL STATE ----
    ' 1) Select HOME tab in NavBar
    m.navBar.selectedId = "home"

    ' 2) Show Home screen and give it focus
    FocusScreenById("home")

    ' 3) Start with NavBar focused (so LEFT/RIGHT work at startup)
    m.navBar.setFocus(true)

    ? "NavBar has focus in init? "; m.navBar.hasFocus()
end sub

' Called whenever NavBar.selectedId changes (from OK on a tab)
sub OnNavSelectionChanged()
    id = m.navBar.selectedId
    m.debugLabel.text = "Selected: " + id
    FocusScreenById(id)
end sub

' Create the screen for the given id, show it in screenLayer, and move focus into it
sub FocusScreenById(id as String)
    screenNode = invalid

    if id = "home" then
        screenNode = CreateObject("roSGNode", "HomeScreen")
    else if id = "live" then
        screenNode = CreateObject("roSGNode", "LiveScreen")
    else if id = "sports" then
        screenNode = CreateObject("roSGNode", "SportsScreen")
    else if id = "settings" then
        screenNode = CreateObject("roSGNode", "SettingsScreen")
    else
        return
    end if

    ' Show screen using your stack helper
    ShowScreenInLayer(screenNode, m.screenLayer)

    ' Remember which screen is active
    m.currentScreen = screenNode

    ' 🔥 Move focus *off* NavBar and into this logical screen
    if m.currentScreen <> invalid then
        m.currentScreen.setFocus(true)
    end if
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false

    if key = "back" then
        ' If NavBar already has focus, let Roku handle back (usually exits the channel)
        if m.navBar.hasFocus() then
            print "MainScene: back pressed while NavBar focused -> letting Roku handle it"
            return false  ' allow default behavior (leave channel / go to native UI)
        end if

        ' Otherwise, bring focus back up to NavBar
        print "MainScene: back pressed -> moving focus to NavBar"
        m.navBar.setFocus(true)
        return true
    end if

    return false
end function

