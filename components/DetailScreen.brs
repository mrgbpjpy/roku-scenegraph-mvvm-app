' ============================================================
' DetailScreen.brs — FINAL, MODAL-CORRECT, FOCUS-SAFE (DEBUG)
' ============================================================

sub init()
    print "DETAIL ▶ init"

    ' ----------------------------
    ' Core nodes
    ' ----------------------------
    m.detailRoot  = m.top.findNode("detailRoot")
    m.detailVideo = m.top.findNode("detailVideo")

    m.poster      = m.top.findNode("poster")
    m.title       = m.top.findNode("title")
    m.category    = m.top.findNode("category")
    m.duration    = m.top.findNode("duration")
    m.description = m.top.findNode("description")

    ' ----------------------------
    ' Action buttons (ORDER MATTERS)
    ' ----------------------------
    m.btnPlay  = m.top.findNode("btnPlay")
    m.btnMore  = m.top.findNode("btnMore")
    m.btnClose = m.top.findNode("btnClose")

    m.actionButtons = []

    if m.btnPlay  <> invalid then m.actionButtons.push(m.btnPlay)
    if m.btnMore  <> invalid then m.actionButtons.push(m.btnMore)
    if m.btnClose <> invalid then m.actionButtons.push(m.btnClose)

    print "DETAIL ▶ actionButtons count =", m.actionButtons.count()

    m.actionIndex = 0

    m.actionRow    = m.top.findNode("actionRow")
    m.actionCursor = m.top.findNode("actionCursor")

    ' ----------------------------
    ' Animations (VISUAL ONLY)
    ' ----------------------------
    m.fadeInAnim  = m.top.findNode("fadeInAnim")
    m.fadeOutAnim = m.top.findNode("fadeOutAnim")

    ' ----------------------------
    ' State
    ' ----------------------------
    m.isPlaying = false
    m.isClosing = false

    ' ----------------------------
    ' Observers
    ' ----------------------------
    m.top.observeField("itemData", "loadData")

    if m.detailVideo <> invalid
        m.detailVideo.observeField("state", "OnVideoStateChanged")
    end if

    updateActionCursor()
end sub


' ============================================================
' Load data (OPEN MODAL)
' ============================================================
sub loadData()
    d = m.top.itemData
    if d = invalid then return

    print "DETAIL ▶ loadData:", d.title

    if d.image <> invalid then m.poster.uri = d.image
    if d.title <> invalid then m.title.text = d.title
    if d.category <> invalid then m.category.text = "Category: " + d.category
    if d.duration <> invalid then m.duration.text = "Duration: " + d.duration
    if d.description <> invalid then m.description.text = d.description

    m.isPlaying = false
    m.isClosing = false
    m.actionIndex = 0

    updateActionCursor()
    StopDetailVideo(false)

    m.top.visible = true
    m.top.setFocus(true)

    m.detailRoot.opacity = 0.0

    if m.fadeInAnim <> invalid
        m.fadeInAnim.control = "start"
    else
        m.detailRoot.opacity = 1.0
    end if
end sub


' ============================================================
' START VIDEO
' ============================================================
sub startVideo()
    if m.detailVideo = invalid or m.top.itemData = invalid then return

    print "DETAIL ▶ startVideo"

    content = CreateObject("roSGNode", "ContentNode")
    content.url = m.top.itemData.videoUrl
    content.streamFormat = "mp4"

    m.detailVideo.content = content
    m.detailVideo.visible = true
    m.detailVideo.control = "play"
    m.detailVideo.setFocus(true)

    m.detailRoot.opacity = 0.0
    m.isPlaying = true
end sub


' ============================================================
' STOP VIDEO (NOT MODAL CLOSE)
' ============================================================
sub StopDetailVideo(restoreUI as Boolean)
    print "DETAIL ▶ StopDetailVideo restoreUI="; restoreUI

    if m.detailVideo <> invalid
        m.detailVideo.control = "stop"
        m.detailVideo.visible = false
    end if

    m.isPlaying = false

    if restoreUI
        if m.fadeInAnim <> invalid
            m.fadeInAnim.control = "stop"
            m.fadeInAnim.control = "start"
        else
            m.detailRoot.opacity = 1.0
        end if

        m.actionIndex = 0
        updateActionCursor()
        m.top.setFocus(true)
    end if
end sub


sub OnVideoStateChanged()
    if m.isClosing then return

    state = m.detailVideo.state
    print "DETAIL ▶ video state:", state

    if state = "finished" or state = "stopped" or state = "error"
        StopDetailVideo(true)
    end if
end sub


' ============================================================
' Cursor update
' ============================================================
sub updateActionCursor()
    if m.actionButtons = invalid or m.actionButtons.count() = 0 then
        print "DETAIL ❌ updateActionCursor: no action buttons"
        return
    end if

    ' reset colors
    for each btn in m.actionButtons
        btn.color = "0xAAAAAAFF"
    end for

    activeBtn = m.actionButtons[m.actionIndex]
    activeBtn.color = "0xFFFFFFFF"

    rect = activeBtn.boundingRect()
    rowPos = m.actionRow.translation
    btnPos = activeBtn.translation

    ' underline exactly the text width
    m.actionCursor.width = rect.width

    cursorX = rowPos[0] + btnPos[0]
    cursorY = rowPos[1] + btnPos[1] + rect.height + 8

    m.actionCursor.translation = [cursorX, cursorY]

    print "DETAIL ▶ Cursor → index:"; m.actionIndex; " id:"; activeBtn.id; " w:"; rect.width
end sub




' ============================================================
' Remote handling
' ============================================================
function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false

    print "DETAIL ▶ key:", key, " | index:", m.actionIndex

    ' ----------------------------
    ' VIDEO MODE
    ' ----------------------------
    if m.isPlaying then
        if key = "back"
            print "DETAIL ▶ BACK (video)"
            StopDetailVideo(true)
            return true
        end if
        return true
    end if

    ' ----------------------------
    ' ACTION NAV
    ' ----------------------------
    if key = "right"
        if m.actionIndex < m.actionButtons.count() - 1
            m.actionIndex++
            updateActionCursor()
        end if
        return true
    end if

    if key = "left"
        if m.actionIndex > 0
            m.actionIndex--
            updateActionCursor()
        end if
        return true
    end if

    ' ----------------------------
    ' OK → ACTIVATE
    ' ----------------------------
    if key = "OK"
        selected = m.actionButtons[m.actionIndex]
        print "DETAIL ▶ OK → selected id =", selected.id

        if selected.isSameNode(m.btnPlay)
            print "DETAIL ▶ PLAY CONFIRMED"
            startVideo()
            return true
        end if

        if selected.isSameNode(m.btnMore)
            print "DETAIL ▶ MORE INFO CONFIRMED"
            return true
        end if

        if selected.isSameNode(m.btnClose)
            print "DETAIL ▶ CLOSE CONFIRMED"
            CloseModal()
            return true
        end if

        print "DETAIL ⚠️ OK but no match"
        return true
    end if

    ' ----------------------------
    ' BACK → CLOSE MODAL
    ' ----------------------------
    if key = "back"
        print "DETAIL ▶ BACK → CloseModal"
        CloseModal()
        return true
    end if

    return false
end function


' ============================================================
' MODAL CLOSE (LOGIC DOES NOT WAIT ON ANIMATION)
' ============================================================
sub CloseModal()
    if m.isClosing then return
    m.isClosing = true

    print "DETAIL ▶ CloseModal"

    StopDetailVideo(false)

    ' Fade-out is VISUAL ONLY
    if m.fadeOutAnim <> invalid
        m.fadeOutAnim.control = "start"
    end if

    ' 🔑 CLOSE IMMEDIATELY (DO NOT WAIT)
    FinishClose()
end sub


sub FinishClose()
    print "DETAIL ▶ FinishClose"

    m.top.visible = false
    m.top.setFocus(false)

    scene = m.top.getScene()
    if scene <> invalid
        scene.callFunc("HideDetail_afterFade")
    end if
end sub
