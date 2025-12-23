' ============================================================
' NavBar.brs – ESPN-Style Navigation Bar (Step 2: Reselect Fix)
' ============================================================

sub init()
    print "🧭 NavBar.init()"

    ' -------------------------------------------------------
    ' Node references
    ' -------------------------------------------------------
    m.menuGroup      = m.top.findNode("menuGroup")
    m.focusUnderline = m.top.findNode("focusUnderline")
    m.measureLabel   = m.top.findNode("measureLabel")

    m.tabs = [
        m.top.findNode("tabFeatured"),
        m.top.findNode("tabHome"),
        m.top.findNode("tabLive"),
        m.top.findNode("tabSports"),
        m.top.findNode("tabDeveloper")
    ]

    ' Canonical IDs expected by MainScene
    m.tabIds = [
        "FEATURED",
        "HOME",
        "LIVE",
        "SPORTS",
        "DEVELOPER"
    ]

    m.currentIndex   = 0
    m.lastEmittedId  = invalid

    ' -------------------------------------------------------
    ' Initial state
    ' -------------------------------------------------------
    if m.focusUnderline <> invalid
        m.focusUnderline.visible = true
    end if

    m.top.observeField("hasFocus", "onFocusChanged")

    UpdateHighlight()

    if m.menuGroup <> invalid
        m.menuGroup.setFocus(true)
    end if

    print "🧭 NavBar ready | default =", m.tabIds[m.currentIndex]
end sub


' -------------------------------------------------------
' Focus change handler
' -------------------------------------------------------
sub onFocusChanged()
    print "🧭 NavBar focus =", m.top.hasFocus()

    if m.focusUnderline <> invalid
        m.focusUnderline.visible = m.top.hasFocus()
    end if
end sub


' -------------------------------------------------------
' Key handling (STEP 2 FIX)
' -------------------------------------------------------
function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false

    print "🧭 NavBar key =", key, "| index =", m.currentIndex

    ' -----------------------------
    ' RIGHT → move tab highlight
    ' -----------------------------
    if key = "right"
        m.currentIndex = (m.currentIndex + 1) mod m.tabs.count()
        UpdateHighlight()
        return true
    end if

    ' -----------------------------
    ' LEFT → move tab highlight
    ' -----------------------------
    if key = "left"
        m.currentIndex--
        if m.currentIndex < 0
            m.currentIndex = m.tabs.count() - 1
        end if
        UpdateHighlight()
        return true
    end if

    selectedId = m.tabIds[m.currentIndex]
    print "🧭 NavBar selectedId =", selectedId

    ' -----------------------------
    ' OK → select tab (new or same)
    ' MainScene decides what to do
    ' -----------------------------
    if key = "OK"
        print "✅ NavBar OK →", selectedId
        m.top.selectedId = selectedId
        return true
    end if

    ' -----------------------------
    ' DOWN → enter current screen
    ' (same selectedId, no tab move)
    ' -----------------------------
    if key = "down"
        print "⬇️ NavBar DOWN →", selectedId
        m.top.selectedId = selectedId
        return true
    end if

    return false
end function



' -------------------------------------------------------
' Update tab highlight & underline
' -------------------------------------------------------
sub UpdateHighlight()
    if m.focusUnderline = invalid or m.measureLabel = invalid
        print "❌ NavBar missing underline or measureLabel"
        return
    end if

    for each t in m.tabs
        if t <> invalid
            t.color = "0xAAAAAAFF"
        end if
    end for

    currentTab = m.tabs[m.currentIndex]
    if currentTab = invalid then return

    currentTab.color = "0xFFFFFFFF"
    print "🎯 NavBar highlight =", m.tabIds[m.currentIndex]

    m.measureLabel.text = currentTab.text
    textRect = m.measureLabel.boundingRect()

    tabRect  = currentTab.boundingRect()
    groupPos = m.menuGroup.translation

    underlineWidth = textRect.width

    offsetX = m.top.underlineOffsetX
    offsetY = m.top.underlineOffsetY

    x = groupPos[0] + tabRect.x + (tabRect.width - underlineWidth) / 2 + offsetX
    y = groupPos[1] + tabRect.y + tabRect.height + 10 + offsetY

    m.focusUnderline.width       = underlineWidth
    m.focusUnderline.translation = [x, y]
end sub
