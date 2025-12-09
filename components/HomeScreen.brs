sub init()
    m.row = m.top.findNode("featuredRow")
    m.cursor = m.top.findNode("cursor")

    ' Logical NavBar tiles
    m.tiles = [
        m.top.findNode("tile1"),
        m.top.findNode("tile2"),
        m.top.findNode("tile3"),
        m.top.findNode("tile4")
    ]

    m.index = 0

    m.top.observeField("hasFocus", "onFocusChanged")

    updateVisuals()
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

    ' Highlight poster
    poster.opacity = 1.0
    poster.blendColor = "0xFFFFFFFF"

    ' Highlight label
    label.color = "0xFFFFFFFF"

    ' Update cursor position behind the tile
    m.cursor.translation = [
        60 + (m.index * 240),
        420
    ]
end sub

sub resetTileStyles()
    for each tile in m.tiles
        poster = tile.getChild(0)
        label  = tile.getChild(1)

        poster.opacity = 0.85
        poster.blendColor = "0xAAAAAAFF"

        label.color = "0xAAAAAAFF"
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
        print "Selected tile index: "; m.index
        return true
    end if

    return false
end function
