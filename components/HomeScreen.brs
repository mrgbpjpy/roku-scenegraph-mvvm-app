' ============================================================
' HomeScreen.brs — DEBUG INSTRUMENTED
' Tracks focus, index, OK presses, and ShowDetail calls
' ============================================================

sub init()
    print "HOME ▶ init()"

    m.top.setFocus(true)

    ' --------------------------------------------------------
    ' Debug labels
    ' --------------------------------------------------------
    m.debugFocus  = m.top.findNode("debugFocus")
    m.debugIndex  = m.top.findNode("debugIndex")
    m.debugAction = m.top.findNode("debugAction")

    if m.debugAction <> invalid
        m.debugAction.text = "[HOME DEBUG] init()"
    end if

    ' --------------------------------------------------------
    ' Tile references (MATCH XML: tile0–tile3)
    ' --------------------------------------------------------
    m.tiles = []

    for each id in ["tile0", "tile1", "tile2", "tile3"]
        tile = m.top.findNode(id)
        if tile <> invalid
            m.tiles.push(tile)
            print "HOME ▶ Found tile:", id
        else
            print "HOME ❌ Missing tile:", id
        end if
    end for

    ' --------------------------------------------------------
    ' Cursor
    ' --------------------------------------------------------
    m.cursor = m.top.findNode("cursor")
    if m.cursor = invalid
        print "HOME ❌ cursor not found"
    end if

    ' --------------------------------------------------------
    ' State
    ' --------------------------------------------------------
    m.index = 0

    ' --------------------------------------------------------
    ' Content backing each tile
    ' --------------------------------------------------------
    m.content = [
        {
            title: "DAL @ PHI",
            videoUrl: "https://videos.erickrokudev.org/DAL_PHI.mp4",
            category: "NFL",
            description: "Cowboys vs Eagles prime-time matchup"
        },
        {
            title: "KC @ BUF",
            videoUrl: "https://videos.erickrokudev.org/KC_BUF.mp4",
            category: "NFL",
            description: "Chiefs vs Bills showdown"
        },
        {
            title: "SF @ SEA",
            videoUrl: "https://videos.erickrokudev.org/SF_SEA.mp4",
            category: "NFL",
            description: "49ers vs Seahawks rivalry"
        },
        {
            title: "NYG @ NE",
            videoUrl: "https://videos.erickrokudev.org/NYG_NE.mp4",
            category: "NFL",
            description: "Giants vs Patriots clash"
        }
    ]

    updateVisuals()
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
' Key Handling — HOME (FINAL, FOCUS-SAFE, DEBUG-ENABLED)
' ============================================================
function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false

    print "HOME ▶ onKeyEvent:", key

    if m.debugAction <> invalid
        m.debugAction.text = "[HOME DEBUG] Key: " + key
    end if

    ' ---------------------------------
    ' RIGHT → Next poster
    ' ---------------------------------
    if key = "right" and m.index < m.tiles.count() - 1
        m.index++
        print "HOME ▶ index →"; m.index
        updateVisuals()
        return true
    end if

    ' ---------------------------------
    ' LEFT → Previous poster
    ' ---------------------------------
    if key = "left" and m.index > 0
        m.index--
        print "HOME ▶ index →"; m.index
        updateVisuals()
        return true
    end if

    ' ---------------------------------
    ' OK → Open DetailScreen
    ' ---------------------------------
    if key = "OK"
        print "HOME ▶ OK pressed on index"; m.index
        showDetail()
        return true
    end if

    ' ---------------------------------
    ' UP or BACK → Return focus to NavBar
    ' ---------------------------------
    if key = "up" or key = "back"
        scene = m.top.getScene()
        if scene <> invalid
            navBar = scene.findNode("navBar")
            if navBar <> invalid
                print "HOME ▶ Focus returned to NavBar"
                navBar.setFocus(true)
                return true
            end if
        end if
    end if

    

    return false
end function



' ============================================================
' Visual Updates
' ============================================================
sub updateVisuals()
    print "HOME ▶ updateVisuals(), index="; m.index

    if m.debugIndex <> invalid
        m.debugIndex.text = "[HOME DEBUG] Index: " + m.index.ToStr()
    end if

    for i = 0 to m.tiles.count() - 1
        tile = m.tiles[i]
        poster = tile.getChild(0)
        label  = tile.getChild(1)

        poster.opacity = 0.85
        label.color = "0xAAAAAAFF"
    end for

    activeTile = m.tiles[m.index]
    poster = activeTile.getChild(0)
    label  = activeTile.getChild(1)

    poster.opacity = 1.0
    label.color = "0xFFFFFFFF"

    if m.cursor <> invalid
        m.cursor.opacity = 1.0
        m.cursor.translation = [
            60 + (m.index * 240),
            420
        ]
    end if

    if m.debugFocus <> invalid
        m.debugFocus.text = "[HOME DEBUG] Focused tile: tile" + m.index.ToStr()
    end if
end sub


' ============================================================
' Show Detail
' ============================================================
sub showDetail()
    print "HOME ▶ showDetail()"

    scene = m.top.getScene()

    if scene = invalid
        print "HOME ❌ Scene is invalid — cannot show detail"
        if m.debugAction <> invalid
            m.debugAction.text = "[HOME DEBUG] Scene invalid"
        end if
        return
    end if

    data = m.content[m.index]

    print "HOME ▶ Sending data to DetailScreen:"
    print data

    if m.debugAction <> invalid
        m.debugAction.text = "[HOME DEBUG] ShowDetail → " + data.title
    end if

    scene.callFunc("ShowDetail", data)
end sub
