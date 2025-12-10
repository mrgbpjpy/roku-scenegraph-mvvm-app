' ============================================================
' HomeScreen.brs — fixed version
' ============================================================

sub init()
    m.row    = m.top.findNode("featuredRow")
    m.cursor = m.top.findNode("cursor")

    m.tiles = [
        m.top.findNode("tile1"),
        m.top.findNode("tile2"),
        m.top.findNode("tile3"),
        m.top.findNode("tile4")
    ]

    ' Content metadata for DetailScreen
    m.content = [
        {
            title: "DAL @ PHI",
            category: "NFL Football",
            duration: "3h 12m",
            description: "The intense NFC rivalry continues.",
            image: "pkg:/images/dal_phi.png",
            videoUrl: "https://your-s3-bucket/videos/dal_phi.m3u8"
        },
        {
            title: "KC @ BUF",
            category: "NFL Football",
            duration: "3h 05m",
            description: "Mahomes and Allen battle again.",
            image: "pkg:/images/KC_BUF.png",
            videoUrl: "https://your-s3-bucket/videos/kc_buf.m3u8"
        },
        {
            title: "SF @ SEA",
            category: "NFL Football",
            duration: "3h 15m",
            description: "A heated division showdown.",
            image: "pkg:/images/sf_sea.png",
            videoUrl: "https://your-s3-bucket/videos/sf_sea.m3u8"
        },
        {
            title: "NYG @ NE",
            category: "NFL Football",
            duration: "3h 08m",
            description: "A classic NFC/AFC battle.",
            image: "pkg:/images/NYG_NE.png",
            videoUrl: "https://your-s3-bucket/videos/nyg_ne.m3u8"
        }
    ]

    m.index = 0

    m.top.observeField("hasFocus", "onFocusChanged")

    updateVisuals()

    ' Ensure parent (HomeScreen) always takes focus
    m.top.setFocus(true)
end sub


sub onFocusChanged()
    if m.top.hasFocus()
        m.cursor.opacity = 1.0
        updateVisuals()
    else
        m.cursor.opacity = 0.0
        resetTileStyles()
    end if
end sub


sub updateVisuals()
    resetTileStyles()

    selectedTile = m.tiles[m.index]
    poster = selectedTile.getChild(0)
    label  = selectedTile.getChild(1)

    poster.opacity    = 1.0
    poster.blendColor = "0xFFFFFFFF"
    label.color       = "0xFFFFFFFF"

    m.cursor.translation = [ 60 + (m.index * 240), 420 ]
end sub


sub resetTileStyles()
    for each t in m.tiles
        poster = t.getChild(0)
        label  = t.getChild(1)

        poster.opacity    = 0.85
        poster.blendColor = "0xAAAAAAFF"
        label.color       = "0xAAAAAAFF"
    end for
end sub


function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false

    if key = "right"
        if m.index < m.tiles.count() - 1
            m.index++
            updateVisuals()
        end if
        return true

    else if key = "left"
        if m.index > 0
            m.index--
            updateVisuals()
        end if
        return true

    else if key = "up"
        scene = m.top.getScene()
        navBar = scene.findNode("navBar")
        navBar.setFocus(true)
        return true

    else if key = "OK"
        showDetailForIndex(m.index)
        return true
    end if

    return false
end function


' -------------------------------------------------------------
' Show DetailScreen (call MainScene function)
' -------------------------------------------------------------
sub showDetailForIndex(i as Integer)
    data = m.content[i]

    scene = m.top.getScene()

    if scene = invalid then
        print "❌ ERROR: Scene is invalid in HomeScreen"
        return
    end if

    print "Calling MainScene.ShowDetail for: "; data.title
    print "MainScene subtype: "; scene.subtype()

    ' 🔥 Correct SceneGraph function invocation
    scene.callFunc("ShowDetail", data)
end sub



