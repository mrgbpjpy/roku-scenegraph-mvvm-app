' ============================================================
'  MainScene.brs — FIXED & FUNCTIONALLY CORRECT VERSION
' ============================================================

sub init()
    ' ------------------------------
    ' Scene setup
    ' ------------------------------
    m.top.backgroundColor = "0x000000FF"

    ' Cache node references
    m.navBar       = m.top.findNode("navBar")
    m.screenLayer  = m.top.findNode("screenLayer")
    m.detailLayer  = m.top.findNode("detailLayer")
    m.detailScreen = m.top.findNode("detailScreen")
    m.debugLabel   = m.top.findNode("debugLabel")

    m.currentScreen = invalid

    ' ------------------------------
    ' Initialize screen stack utilities
    ' ------------------------------
    InitScreenStack()

    ' ------------------------------
    ' DO NOT ASSIGN FUNCTIONS AS FIELDS HERE
    ' Roku exposes callable functions using <function> in XML
    ' ------------------------------
    ' (Removed incorrect lines)
    ' m.top.ShowDetail = ShowDetail
    ' m.top.HideDetail = HideDetail

    ' ------------------------------
    ' NavBar selection listener
    ' ------------------------------
    m.navBar.observeField("selectedId", "OnNavSelectionChanged")

    ' ------------------------------
    ' Load initial screen (Home)
    ' ------------------------------
    m.navBar.selectedId = "home"
    FocusScreenById("home")

    ' Give focus to NavBar on startup
    m.navBar.setFocus(true)

    print "🔥 MainScene initialized and ready!"
end sub



' ============================================================
' Handle NavBar tab switching
' ============================================================
sub OnNavSelectionChanged()
    id = m.navBar.selectedId
    m.debugLabel.text = "Selected: " + id
    FocusScreenById(id)
end sub


' ============================================================
' Load Home / Live / Sports / Settings screens
' ============================================================
sub FocusScreenById(id as String)
    screen = invalid

    if id = "home"
        screen = CreateObject("roSGNode", "HomeScreen")
    else if id = "live"
        screen = CreateObject("roSGNode", "LiveScreen")
    else if id = "sports"
        screen = CreateObject("roSGNode", "SportsScreen")
    else if id = "settings"
        screen = CreateObject("roSGNode", "SettingsScreen")
    end if

    if screen = invalid then return

    ShowScreenInLayer(screen, m.screenLayer)
    m.currentScreen = screen
    screen.setFocus(true)
end sub


' ============================================================
' OPEN DetailScreen (called by HomeScreen)
' ============================================================
sub ShowDetail(data as Object)
    if m.detailScreen = invalid or m.detailLayer = invalid
        print "❌ DetailScreen not found in scene"
        return
    end if

    m.detailScreen.itemData = data
    m.detailLayer.visible = true
    m.detailScreen.setFocus(true)

    print "👉 DETAIL OPENED: "; data.title
end sub


' ============================================================
' CLOSE DetailScreen modal
' ============================================================
sub HideDetail()
    m.detailLayer.visible = false

    if m.currentScreen <> invalid
        m.currentScreen.setFocus(true)
    end if
end sub


' ============================================================
' Global BACK behavior
' ============================================================
function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false

    ' 1️⃣ Close modal first
    if key = "back" and m.detailLayer.visible
        HideDetail()
        return true
    end if

    ' 2️⃣ Normal navigation back
    if key = "back"
        if m.navBar.hasFocus()
            return false   ' allow Roku OS to exit
        else
            m.navBar.setFocus(true)
            return true
        end if
    end if

    return false
end function
