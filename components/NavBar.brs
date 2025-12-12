' ============================================================
' NavBar.brs – ESPN-Style Navigation Bar (DEBUG ENABLED)
' ============================================================

sub init()
    print "🧭 NavBar.init()"

    m.menuGroup      = m.top.findNode("menuGroup")
    m.tabFeatured    = m.top.findNode("tabFeatured")
    m.tabHome        = m.top.findNode("tabHome")
    m.tabLive        = m.top.findNode("tabLive")
    m.tabSports      = m.top.findNode("tabSports")
    m.tabSettings    = m.top.findNode("tabSettings")

    m.focusUnderline = m.top.findNode("focusUnderline")
    m.measureLabel   = m.top.findNode("measureLabel")

    ' -------------------------------------------------------
    ' Tab order
    ' -------------------------------------------------------
    m.tabs = [
        m.tabFeatured,
        m.tabHome,
        m.tabLive,
        m.tabSports,
        m.tabSettings
    ]

    m.tabIds = [
        "featured",
        "home",
        "live",
        "sports",
        "settings"
    ]

    m.currentIndex = 0

    if m.focusUnderline <> invalid
        m.focusUnderline.visible = true
    end if

    m.top.observeField("hasFocus", "onFocusChanged")

    print "🧭 NavBar ready | default tab =", m.tabIds[m.currentIndex]

    UpdateHighlight()

    ' Ensure NavBar owns focus when shown
    m.menuGroup.setFocus(true)
end sub


' -------------------------------------------------------
' Focus change debug
' -------------------------------------------------------
sub onFocusChanged()
    print "🧭 NavBar focus =", m.top.hasFocus()

    if m.focusUnderline <> invalid
        m.focusUnderline.visible = m.top.hasFocus()
    end if
end sub


' -------------------------------------------------------
' Key handling with debug
' -------------------------------------------------------
function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false

    print "🧭 NavBar key =", key, " | index =", m.currentIndex

    ' ---------------------------------
    ' RIGHT
    ' ---------------------------------
    if key = "right"
        m.currentIndex++
        if m.currentIndex >= m.tabs.count()
            m.currentIndex = 0
        end if

        print "➡️ NavBar RIGHT →", m.tabIds[m.currentIndex]
        UpdateHighlight()
        return true
    end if

    ' ---------------------------------
    ' LEFT
    ' ---------------------------------
    if key = "left"
        m.currentIndex--
        if m.currentIndex < 0
            m.currentIndex = m.tabs.count() - 1
        end if

        print "⬅️ NavBar LEFT →", m.tabIds[m.currentIndex]
        UpdateHighlight()
        return true
    end if

    ' ---------------------------------
    ' OK → Notify MainScene
    ' ---------------------------------
    if key = "OK"
        selectedId = m.tabIds[m.currentIndex]
        print "✅ NavBar OK → selectedId =", selectedId

        m.top.selectedId = selectedId
        return true
    end if

    ' ---------------------------------
    ' DOWN → Return focus to screen
    ' ---------------------------------
    if key = "down"
        scene = m.top.getScene()
        if scene <> invalid and scene.currentScreen <> invalid
            print "⬇️ NavBar DOWN → focus screen"
            scene.currentScreen.setFocus(true)
            return true
        else
            print "⚠️ NavBar DOWN → no currentScreen"
        end if
    end if

    return false
end function


' -------------------------------------------------------
' Update tab styles + underline (with debug)
' -------------------------------------------------------
sub UpdateHighlight()
    if m.focusUnderline = invalid then
        print "❌ NavBar: focusUnderline missing"
        return
    end if

    ' Dim all tabs
    for each t in m.tabs
        t.color = "0xAAAAAAFF"
    end for

    currentTab = m.tabs[m.currentIndex]
    currentTab.color = "0xFFFFFFFF"

    print "🎯 NavBar highlight =", m.tabIds[m.currentIndex]

    ' Measure text width
    m.measureLabel.text = currentTab.text
    textRect = m.measureLabel.boundingRect()

    tabRect  = currentTab.boundingRect()
    groupPos = m.menuGroup.translation

    tabX = groupPos[0] + tabRect.x
    tabY = groupPos[1] + tabRect.y

    underlineWidth = textRect.width

    offsetX = 0
    offsetY = 0

    if m.top.lookup("underlineOffsetX") <> invalid
        offsetX = m.top.underlineOffsetX
    end if
    if m.top.lookup("underlineOffsetY") <> invalid
        offsetY = m.top.underlineOffsetY
    end if

    x = tabX + (tabRect.width - underlineWidth) / 2 + offsetX
    y = tabY + tabRect.height + 10 + offsetY

    m.focusUnderline.width       = underlineWidth
    m.focusUnderline.translation = [x, y]
end sub
