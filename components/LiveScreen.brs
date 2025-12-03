sub init()
    m.cursor     = m.top.findNode("cursor")
    m.debugLabel = m.top.findNode("debugLabel")

    ' Static items – keep references in an array
    m.items = [
        m.top.findNode("item0"),
        m.top.findNode("item1"),
        m.top.findNode("item2")
    ]

    ' Current logical selection
    m.index     = 0
    m.baseY     = 180  ' Y for item 0
    m.rowHeight = 40   ' vertical spacing between rows

    m.top.focusable = true

    ' NavBar has focus at launch, so cursor starts hidden
    if m.cursor <> invalid then
        m.cursor.visible = false
    end if

    updateCursor()
    showDebug("init() ok, index=0")
end sub

' Called from AppScene.enterCurrentScreen when LIVE is selected
sub giveFocus()
    m.top.setFocus(true)

    ' When LiveScreen gets focus, show cursor
    if m.cursor <> invalid then
        m.cursor.visible = true
    end if

    updateCursor()
    showDebug("giveFocus() → index=" + Str(m.index))
end sub

' Called from AppScene.focusNavBar when NavBar regains focus
' Only hides the cursor; items + debug remain visible
sub hideCursor()
    if m.cursor <> invalid then
        m.cursor.visible = false
    end if
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    if not press then return false

    ' No items? nothing to do
    if m.items = invalid or m.items.count() = 0 then return false

    prevIndex = m.index

    if key = "down" then
        ' Go down but not past last item
        if m.index < m.items.count() - 1 then
            m.index = m.index + 1
            updateCursor()
        end if
        showDebug("KEY down  prev=" + Str(prevIndex) + " now=" + Str(m.index))
        return true

    else if key = "up" then
        ' If not at top, move cursor up
        if m.index > 0 then
            m.index = m.index - 1
            updateCursor()
            showDebug("KEY up    prev=" + Str(prevIndex) + " now=" + Str(m.index))
            return true
        else
            ' At top -> return focus to NavBar
            showDebug("KEY up at top → focusNavBar()")
            scene = m.top.getScene()
            if scene <> invalid then
                scene.callFunc("focusNavBar")
            end if
            return true
        end if

    else if key = "OK" or key = "select" then
        ' This is where you’d trigger play/details for m.index
        showDebug("OK on index=" + Str(m.index))
        return true
    end if

    return false
end function

' Move the highlight rectangle & tweak label colors
sub updateCursor()
    if m.cursor = invalid then return

    ' Move cursor rect based on current index
    x = m.cursor.translation[0]
    y = m.baseY + m.index * m.rowHeight
    m.cursor.translation = [x, y]

    ' Highlight active label via color
    for i = 0 to m.items.count() - 1
        item = m.items[i]
        if item <> invalid then
            if i = m.index then
                item.color = "0xFFFFFFFF" ' bright
            else
                item.color = "0xAAAAAAFF" ' dim
            end if
        end if
    end for
end sub

sub showDebug(msg as string)
    if m.debugLabel <> invalid then
        m.debugLabel.text = msg
    end if
end sub
