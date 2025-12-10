sub init()
    m.poster      = m.top.findNode("poster")
    m.title       = m.top.findNode("title")
    m.category    = m.top.findNode("category")
    m.duration    = m.top.findNode("duration")
    m.description = m.top.findNode("description")

    m.actionRow      = m.top.findNode("actionRow")
    m.actionCursor   = m.top.findNode("actionCursor")

    m.actionButtons = [
        m.top.findNode("btnPlay"),
        m.top.findNode("btnMore")
    ]
    m.actionIndex = 0

    ' Update UI when itemData changes
    m.top.observeField("itemData", "loadData")

    updateActionCursor()
end sub


sub loadData()
    data = m.top.itemData

    if data <> invalid
        m.poster.uri       = data.image
        m.title.text       = data.title
        m.category.text    = "Category: " + data.category
        m.duration.text    = "Duration: " + data.duration
        m.description.text = data.description
    end if

    ' Auto-focus the DetailScreen
    m.top.setFocus(true)
end sub


' ----------------------------------------
' Update yellow underline position
' ----------------------------------------
sub updateActionCursor()
    ' Reset all button colors
    for each btn in m.actionButtons
        btn.color = "0xAAAAAAFF"
    end for

    current = m.actionButtons[m.actionIndex]
    current.color = "0xFFFFFFFF"

    rect = current.boundingRect()
    groupPos = m.actionRow.translation

    m.actionCursor.opacity = 1.0

    m.actionCursor.translation = [
        groupPos[0] + rect.x,
        groupPos[1] + rect.height + 8
    ]
end sub


function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false

    ' ===========================================================
    ' RIGHT: Move action cursor to the right
    ' ===========================================================
    if key = "right"
        if m.actionIndex < m.actionButtons.count() - 1
            m.actionIndex++
            updateActionCursor()
        end if
        return true


    ' ===========================================================
    ' LEFT: Move action cursor to the left
    ' ===========================================================
    else if key = "left"
        if m.actionIndex > 0
            m.actionIndex--
            updateActionCursor()
        end if
        return true


    ' ===========================================================
    ' OK: Activate the selected action (PLAY)
    ' ===========================================================
    else if key = "OK"
        selected = m.actionButtons[m.actionIndex].text

        if selected = "PLAY"
            ' Fire event to MainScene
            m.top.PlayRequested = m.top.itemData.videoUrl
            print "Play requested for: "; m.top.itemData.videoUrl
        end if

        return true


    ' ===========================================================
    ' BACK: Close DetailScreen through MainScene
    ' ===========================================================
    else if key = "back"
        scene = m.top.getScene()
        if scene <> invalid
            scene.callFunc("HideDetail")
        end if
        return true
    end if

    return false
end function

