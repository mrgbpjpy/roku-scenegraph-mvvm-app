' ============================================================
' LiveScreen.brs — Finished Vertical Menu + Preview Panel
' ESPN-style, MVVM-safe
' ============================================================

sub init()
    print "LIVE ▶ init()"

    ' -----------------------------
    ' UI references
    ' -----------------------------
    m.liveMenu = m.top.findNode("liveMenu")
    m.cursor   = m.top.findNode("cursor")

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
    ' Mock content for preview panel
    ' -----------------------------
    m.previewData = [
        {
            title: "Chiefs vs Bills",
            desc: "AFC showdown with major playoff implications.",
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

    ' Watch focus changes
    m.top.observeField("hasFocus", "onFocusChanged")

    updateMenuVisuals()
    updatePreview()
end sub


' ============================================================
' Focus Handling
' ============================================================
sub onFocusChanged()
    if m.cursor = invalid then return

    if m.top.hasFocus()
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

    ' Highlight selected option
    for i = 0 to m.options.count() - 1
        opt = m.options[i]
        if opt <> invalid then
            if i = m.currentIndex
                opt.color = "0xFFFFFFFF" ' White
            else
                opt.color = "0xFF888888" ' Gray
            end if
        end if
    end for

    selected = m.options[m.currentIndex]
    if selected = invalid then return

    rect = selected.boundingRect()
    if rect = invalid then return

    menuPos  = m.liveMenu.translation
    labelPos = selected.translation

    ' Size cursor to text width
    m.cursor.width  = rect.width
    m.cursor.height = 4

    ' Position cursor directly under text
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

    if m.previewTitle <> invalid
        m.previewTitle.text = data.title
    end if

    if m.previewDesc <> invalid
        m.previewDesc.text = data.desc
    end if

    if m.previewPoster <> invalid
        m.previewPoster.uri = data.poster
    end if
end sub


' ============================================================
' Remote Key Handling
' ============================================================
function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false

    ' DOWN navigation
    if key = "down"
        if m.currentIndex < m.options.count() - 1
            m.currentIndex++
            updateMenuVisuals()
            updatePreview()
        end if
        return true
    end if

    ' UP navigation
    if key = "up"
        if m.currentIndex > 0
            m.currentIndex--
            updateMenuVisuals()
            updatePreview()
        else
            ' Return focus to NavBar
            scene = m.top.getScene()
            if scene <> invalid
                navBar = scene.findNode("navBar")
                if navBar <> invalid then navBar.setFocus(true)
            end if
        end if
        return true
    end if

    ' OK selection
    if key = "OK"
        print "LIVE ▶ Selected menu index:"; m.currentIndex
        ' Future: route to DetailScreen based on selection
        return true
    end if

    return false
end function
