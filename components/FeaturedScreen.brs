' ============================================================
' FeaturedScreen.brs — FULL DEBUG / TRACE VERSION
' ============================================================

sub init()
    print "=============================="
    print "📺 FeaturedScreen.init() START"
    print "=============================="

    m.bgVideo     = m.top.findNode("bgVideo")
    m.focusAnchor = m.top.findNode("focusAnchor")

    ' ---- Node validation ----
    if m.bgVideo = invalid
        print "❌ ERROR: bgVideo node NOT FOUND"
    else
        print "✅ bgVideo node FOUND"
    end if

    if m.focusAnchor = invalid
        print "⚠️ WARNING: focusAnchor node NOT FOUND"
    else
        print "✅ focusAnchor node FOUND"
    end if

    ' ---- Setup promo content ----
    promo = CreateObject("roSGNode", "ContentNode")
    promo.url = "https://videos.erickrokudev.org/New_Football_Promo.mp4"
    promo.streamFormat = "mp4"
    promo.title = "Featured Promo"

    if m.bgVideo <> invalid
        print "🎬 Assigning promo content to bgVideo"
        m.bgVideo.content = promo
        m.bgVideo.visible = false
        m.bgVideo.control = "stop"
    end if

    ' ---- Focus setup ----
    if m.focusAnchor <> invalid
        print "🎯 Applying focus to focusAnchor"
        m.focusAnchor.setFocus(true)
    else
        print "⚠️ Cannot set focus — focusAnchor missing"
    end if

    ' ---- Observe video lifecycle ----
    m.bgVideo.observeField("state", "OnVideoStateChanged")

    ' ---- Observe visibility ----
    print "👀 Observing FeaturedScreen.visible"
    m.top.observeField("visible", "onVisibleChange")

    print "=============================="
    print "📺 FeaturedScreen.init() END"
    print "=============================="
end sub

sub enterMenu()
    print "FEATURED ▶ enterMenu()"

    ' If this screen has a rowList, focus it
    if m.rowList <> invalid
        m.rowList.setFocus(true)
    else
        ' Otherwise, focus the screen root
        m.top.setFocus(true)
    end if
end sub


' ============================================================
' Video State Observer — THIS IS THE KEY
' ============================================================
sub OnVideoStateChanged()
    state = m.bgVideo.state
    print "FEATURED ▶ video state:", state

    ' As soon as autoplay actually begins,
    ' move focus to NavBar (acts like UP)
    if state = "playing"
        scene = m.top.getScene()
        if scene <> invalid
            navBar = scene.findNode("navBar")
            if navBar <> invalid
                print "FEATURED ▶ Video playing → focus NavBar"
                navBar.setFocus(true)
            end if
        end if
    end if
end sub





' ============================================================
' Visibility Observer
' ============================================================
sub onVisibleChange()
    print "--------------------------------"
    print "👁 FeaturedScreen.onVisibleChange()"
    print "    visible =", m.top.visible
    print "--------------------------------"

    if m.bgVideo = invalid
        print "❌ bgVideo invalid — cannot control video"
        return
    end if

    if m.top.visible = true
        print "▶ FeaturedScreen SHOWN"
        print "🎬 Preparing to PLAY background video"

        m.bgVideo.visible = true
        m.bgVideo.control = "stop"
        m.bgVideo.control = "play"

        print "▶ bgVideo.visible =", m.bgVideo.visible
        print "▶ bgVideo.control = play"

    else
        print "⏹ FeaturedScreen HIDDEN"
        print "🛑 Stopping background video"

        m.bgVideo.control = "stop"
        m.bgVideo.visible = false

        print "⏹ bgVideo.control = stop"
    end if
end sub


' ============================================================
' Key Handling
' ============================================================
function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false

    print "🎮 FeaturedScreen.onKeyEvent()"
    print "    key   =", key
    print "    press =", press

    ' ---- UP → NavBar ----
    if key = "back"
        print "SCREEN     BACK → return focus to NavBar"

        scene = m.top.getScene()
        if scene <> invalid
            navBar = scene.findNode("navBar")
            if navBar <> invalid
                navBar.setFocus(true)
                return true ' ✅ handled
            end if
        end if

        return true ' consume even if NavBar not found
    end if
    
    if key = "up"
        print "⬆️ UP pressed — attempting to move focus to NavBar"

        scene = m.top.getScene()
        if scene = invalid
            print "❌ Scene is INVALID"
            return false
        end if

        navBar = scene.findNode("navBar")
        if navBar = invalid
            print "❌ NavBar node NOT FOUND in scene"
            return false
        end if

        print "✅ NavBar found — setting focus"
        navBar.setFocus(true)
        return true
    end if

    ' ---- Any other key ----
    print "➡️ Key not handled by FeaturedScreen"
    return false
end function
