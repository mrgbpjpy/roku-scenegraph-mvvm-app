' ============================================================
' LiveScreen.brs — Finished Vertical Menu + Preview + Live Video
' ESPN-style, MVVM-safe
' ============================================================

sub init()
    print "LIVE ▶ init()"

    ' -----------------------------
    ' UI references
    ' -----------------------------
    m.liveMenu = m.top.findNode("liveMenu")
    m.cursor   = m.top.findNode("cursor")
    m.video    = m.top.findNode("liveVideo")

    m.previewTitle  = m.top.findNode("previewTitle")
    m.previewDesc   = m.top.findNode("previewDesc")
    m.previewPoster = m.top.findNode("previewPoster")

    m.options = [
        m.top.findNode("opt1"),
        m.top.findNode("opt2"),
        m.top.findNode("opt3"),
        m.top.findNode("opt4")
    ]

    ' -----------------------------
    ' Preview content (menu-index aligned)
    ' -----------------------------
    m.previewData = [
        {
            title: "Live Basketball",
            desc: "Watch live basketball coverage streaming now.",
            poster: "pkg:/images/live/kc_buf.jpg"
        },
        {
            title: "Tonight’s Matchups",
            desc: "Upcoming games across NFL, NBA, and MLB.",
            poster: "pkg:/images/live/upcoming.jpg"
        },
        {
            title: "Top Replays",
            desc: "Relive today’s most exciting moments.",
            poster: "pkg:/images/live/replays.jpg"
        },
        {
            title: "Must-Watch Highlights",
            desc: "Can’t-miss plays from across all leagues.",
            poster: "pkg:/images/live/highlights.jpg"
        }
    ]

    m.currentIndex = 0
    m.videoPlaying = false

    ' Watch focus changes
    m.top.observeField("hasFocus", "onFocusChanged")

    updateMenuVisuals()
    updatePreview()
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
' Focus Handling
' ============================================================
sub onFocusChanged()
    if m.cursor = invalid then return

    if m.top.hasFocus() and not m.videoPlaying
        m.cursor.opacity = 1.0
        updateMenuVisuals()
        updatePreview()
    else
        m.cursor.opacity = 0.0
    end if
end sub


' ============================================================
' Update Menu Highlight + Cursor
' ============================================================
sub updateMenuVisuals()
    if m.options = invalid or m.cursor = invalid then return

    for i = 0 to m.options.count() - 1
        opt = m.options[i]
        if opt <> invalid then
            if i = m.currentIndex then
                opt.color = "0xFFFFFFFF"
            else
                opt.color = "0xFF888888"
            end if
        end if
    end for

    selected = m.options[m.currentIndex]
    if selected = invalid then return

    rect = selected.boundingRect()
    if rect = invalid then return

    menuPos  = m.liveMenu.translation
    labelPos = selected.translation

    m.cursor.width  = rect.width
    m.cursor.height = 4

    m.cursor.translation = [
        menuPos[0] + labelPos[0],
        menuPos[1] + labelPos[1] + rect.height + 6
    ]

    m.cursor.opacity = 1.0
end sub


' ============================================================
' Update Preview Panel Content
' ============================================================
sub updatePreview()
    if m.previewData = invalid then return

    data = m.previewData[m.currentIndex]
    if data = invalid then return

    if m.previewTitle <> invalid then
        m.previewTitle.text = data.title
    end if

    if m.previewDesc <> invalid then
        m.previewDesc.text = data.desc
    end if

    if m.previewPoster <> invalid then
        m.previewPoster.uri = data.poster
    end if
end sub


' ============================================================
' Live Video Playback
' ============================================================
sub playLiveVideo(videoUrl as String)
    if m.video = invalid then return

    print "LIVE ▶ Playing video:"; videoUrl

    videoContent = CreateObject("roSGNode", "ContentNode")
    videoContent.streamFormat = "mp4"
    videoContent.url = videoUrl

    m.video.content = videoContent
    m.video.visible = true
    m.video.control = "play"

    m.videoPlaying = true
    m.cursor.opacity = 0.0
end sub



sub stopLiveVideo()
    if m.video = invalid then return

    print "LIVE ▶ Stopping live video"

    ' Stop playback
    m.video.control = "stop"

    ' Clear content to release focus cleanly
    m.video.content = invalid

    ' Hide video node
    m.video.visible = false
    m.videoPlaying = false

    ' Reassert focus back to LiveScreen
    m.top.setFocus(true)

    ' Restore UI state
    updateMenuVisuals()
    updatePreview()
end sub



' ============================================================
' Remote Key Handling
' ============================================================
function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false

    ' If video is playing, BACK stops it
    if m.videoPlaying then
        if key = "back"
            stopLiveVideo()
            return true
        end if
        return true
    end if

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

    if key = "down"
        if m.currentIndex < m.options.count() - 1
            m.currentIndex++
            updateMenuVisuals()
            updatePreview()
        end if
        return true
    end if

    if key = "up"
        if m.currentIndex > 0
            m.currentIndex--
            updateMenuVisuals()
            updatePreview()
        else
            scene = m.top.getScene()
            if scene <> invalid
                navBar = scene.findNode("navBar")
                if navBar <> invalid then navBar.setFocus(true)
            end if
        end if
        return true
    end if

    if key = "OK"
    print "LIVE ▶ Selected menu index:"; m.currentIndex

    ' Live Now
    if m.currentIndex = 0
        playLiveVideo("https://videos.erickrokudev.org/BasketBall_Live.mp4")
    end if

    ' Upcoming Games
    if m.currentIndex = 1
        m.top.requestDialog = "upcomingGames"
    end if

    ' Replays
    if m.currentIndex = 2
        playLiveVideo("https://videos.erickrokudev.org/BBDunksV2.mp4")
    end if

    ' Highlights (NEW)
    if m.currentIndex = 3
        m.top.requestDialog = "highlights"
    end if

    return true
end if

    return false
end function
