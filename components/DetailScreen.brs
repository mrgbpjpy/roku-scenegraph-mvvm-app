' ============================================================
' DetailScreen.brs — FINAL, MODAL-CORRECT, FOCUS-SAFE
' ============================================================

sub init()
    print "DETAIL ▶ init"

    ' ----------------------------------------------------------
    ' Core nodes
    ' ----------------------------------------------------------
    m.detailRoot   = m.top.findNode("detailRoot")
    m.detailVideo  = m.top.findNode("detailVideo")

    m.poster       = m.top.findNode("poster")
    m.title        = m.top.findNode("title")
    m.category     = m.top.findNode("category")
    m.duration     = m.top.findNode("duration")
    m.description  = m.top.findNode("description")

    ' ----------------------------------------------------------
    ' MORE INFO PANEL (Option A)
    ' ----------------------------------------------------------
    m.moreInfoPanel   = m.top.findNode("moreInfoPanel")
    m.infoLeague      = m.top.findNode("infoLeague")
    m.infoTeams       = m.top.findNode("infoTeams")
    m.infoDate        = m.top.findNode("infoDate")
    m.infoVenue       = m.top.findNode("infoVenue")
    m.infoRating      = m.top.findNode("infoRating")
    m.infoDescription = m.top.findNode("infoDescription")

    m.moreInfoOpen = false
    if m.moreInfoPanel <> invalid
        m.moreInfoPanel.visible = false
    end if

    ' ----------------------------------------------------------
    ' Action buttons (ORDER MATTERS)
    ' ----------------------------------------------------------
    m.btnPlay  = m.top.findNode("btnPlay")
    m.btnMore  = m.top.findNode("btnMore")
    m.btnClose = m.top.findNode("btnClose")

    m.actionButtons = []
    if m.btnPlay  <> invalid then m.actionButtons.push(m.btnPlay)
    if m.btnMore  <> invalid then m.actionButtons.push(m.btnMore)
    if m.btnClose <> invalid then m.actionButtons.push(m.btnClose)

    m.actionIndex = 0
    m.actionRow   = m.top.findNode("actionRow")
    m.actionCursor = m.top.findNode("actionCursor")

    ' ----------------------------------------------------------
    ' Animations (visual only)
    ' ----------------------------------------------------------
    m.fadeInAnim  = m.top.findNode("fadeInAnim")
    m.fadeOutAnim = m.top.findNode("fadeOutAnim")

    ' ----------------------------------------------------------
    ' State
    ' ----------------------------------------------------------
    m.isPlaying = false
    m.isClosing = false

    ' ----------------------------------------------------------
    ' Observers
    ' ----------------------------------------------------------
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
    if d.category <> invalid then m.category.text = d.category
    if d.duration <> invalid then m.duration.text = d.duration
    if d.description <> invalid then m.description.text = d.description

    ' Populate MORE INFO
    if m.infoLeague <> invalid and d.league <> invalid
        m.infoLeague.text = d.league
    end if

    if m.infoTeams <> invalid and d.teams <> invalid
        m.infoTeams.text = d.teams
    end if

    if m.infoDate <> invalid and d.date <> invalid
        m.infoDate.text = d.date
    end if

    if m.infoVenue <> invalid and d.venue <> invalid
        m.infoVenue.text = d.venue
    end if

    if m.infoRating <> invalid and d.rating <> invalid
        m.infoRating.text = d.rating
    end if

    if m.infoDescription <> invalid and d.description <> invalid
        m.infoDescription.text = d.description
    end if

    m.isPlaying = false
    m.isClosing = false
    m.moreInfoOpen = false
    if m.moreInfoPanel <> invalid then m.moreInfoPanel.visible = false

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
' VIDEO PLAYBACK
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

sub StopDetailVideo(restoreUI as Boolean)
    if m.detailVideo <> invalid
        m.detailVideo.control = "stop"
        m.detailVideo.visible = false
    end if

    m.isPlaying = false

    if restoreUI
        m.detailRoot.opacity = 1.0
        m.actionIndex = 0
        updateActionCursor()
        m.top.setFocus(true)
    end if
end sub

sub OnVideoStateChanged()
    if m.isClosing then return

    state = m.detailVideo.state
    if state = "finished" or state = "stopped" or state = "error"
        StopDetailVideo(true)
    end if
end sub

' ============================================================
' MORE INFO PANEL
' ============================================================
sub ShowMoreInfo()
    if m.moreInfoPanel <> invalid
        print "DETAIL ▶ ShowMoreInfo"
        m.moreInfoPanel.visible = true
        m.moreInfoOpen = true
    end if
end sub

sub HideMoreInfo()
    if m.moreInfoPanel <> invalid
        print "DETAIL ▶ HideMoreInfo"
        m.moreInfoPanel.visible = false
        m.moreInfoOpen = false
        updateActionCursor()
    end if
end sub

' ============================================================
' Action cursor
' ============================================================
sub updateActionCursor()
    if m.actionButtons.count() = 0 then return

    for each btn in m.actionButtons
        btn.color = "0xAAAAAAFF"
    end for

    activeBtn = m.actionButtons[m.actionIndex]
    activeBtn.color = "0xFFFFFFFF"

    rect = activeBtn.boundingRect()
    rowPos = m.actionRow.translation
    btnPos = activeBtn.translation

    m.actionCursor.width = rect.width
    m.actionCursor.translation = [
        rowPos[0] + btnPos[0],
        rowPos[1] + btnPos[1] + rect.height + 8
    ]
end sub

' ============================================================
' Remote handling
' ============================================================
function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false

    print "DETAIL ▶ key:", key, " | index:", m.actionIndex

    ' ============================================================
    ' VIDEO MODE (highest priority)
    ' ============================================================
    if m.isPlaying
        if key = "back"
            StopDetailVideo(true)
            return true
        end if

        ' All keys swallowed while video plays
        return true
    end if

    ' ============================================================
    ' MORE INFO PANEL MODE
    ' ============================================================
    if m.moreInfoOpen
        if key = "back" or key = "OK"
            HideMoreInfo()
            return true
        end if

        ' Lock focus while panel is open
        return true
    end if

    ' ============================================================
    ' UP → RETURN FOCUS TO NAVBAR
    ' ============================================================
    if key = "up"
        scene = m.top.getScene()
        if scene <> invalid
            navBar = scene.findNode("navBar")
            if navBar <> invalid
                print "DETAIL ▶ UP → Focus returned to NavBar"
                navBar.setFocus(true)
                return true
            end if
        end if
    end if

    ' ============================================================
    ' ACTION NAVIGATION
    ' ============================================================
    if key = "right" and m.actionIndex < m.actionButtons.count() - 1
        m.actionIndex++
        updateActionCursor()
        return true
    end if

    if key = "left" and m.actionIndex > 0
        m.actionIndex--
        updateActionCursor()
        return true
    end if

    ' ============================================================
    ' OK → ACTIVATE ACTION
    ' ============================================================
    if key = "OK"
        selected = m.actionButtons[m.actionIndex]

        if selected.isSameNode(m.btnPlay)
            startVideo()
        else if selected.isSameNode(m.btnMore)
            ShowMoreInfo()
        else if selected.isSameNode(m.btnClose)
            CloseModal()
        end if

        return true
    end if

    ' ============================================================
    ' BACK → CLOSE DETAIL MODAL
    ' ============================================================
    if key = "back"
        CloseModal()
        return true
    end if

    return false
end function


' ============================================================
' Close modal
' ============================================================
sub CloseModal()
    if m.isClosing then return
    m.isClosing = true

    StopDetailVideo(false)

    if m.fadeOutAnim <> invalid
        m.fadeOutAnim.control = "start"
    end if

    FinishClose()
end sub

sub FinishClose()
    m.top.visible = false
    m.top.setFocus(false)

    scene = m.top.getScene()
    if scene <> invalid
        scene.callFunc("HideDetail_afterFade")
    end if
end sub
