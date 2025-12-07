sub init()
    ' Background styling
    m.top.backgroundColor = "0x000000FF"  ' black

    ' Cache nodes
    m.navBar      = m.top.findNode("navBar")
    m.screenLayer = m.top.findNode("screenLayer")
    m.debugLabel  = m.top.findNode("debugLabel")

    ' Initialize screen stack (from ScreenStackLogic)
    InitScreenStack()

    ' Observe NavBar selection changes
    m.navBar.ObserveField("selectedId", "OnNavSelectionChanged")

    
     ' ---- INITIAL STATE ----
    ' 1) Select HOME tab
    m.navBar.selectedId = "home"

    ' 2) Create and show the HomeScreen under screenLayer
    ShowScreenById("home")

    ' 3) Give focus to NavBar so LEFT/RIGHT/OK go there
    m.navBar.setFocus(true)

    ' Debug: see if NavBar really has focus
    ? "NavBar has focus in init? "; m.navBar.hasFocus()
end sub

' Called whenever NavBar.selectedId changes
sub OnNavSelectionChanged()
    id = m.navBar.selectedId
    m.debugLabel.text = "Selected: " + id
    ShowScreenById(id)
end sub

' Map string IDs to specific screen components
sub ShowScreenById(id as String)
    screenNode = invalid

    if id = "home"
        screenNode = CreateObject("roSGNode", "HomeScreen")
    else if id = "live"
        screenNode = CreateObject("roSGNode", "LiveScreen")
    else if id = "sports"
        screenNode = CreateObject("roSGNode", "SportsScreen")
    else if id = "settings"
        screenNode = CreateObject("roSGNode", "SettingsScreen")
    else
        return
    end if

    ' Use screen stack helper: attach screens under screenLayer instead of m.top
    ShowScreenInLayer(screenNode, m.screenLayer)
end sub
