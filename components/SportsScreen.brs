' ============================================================
' SportsScreen.brs — League Discovery Screen
' ESPN-style, MVVM-safe
' ============================================================

sub init()
    print "SPORTS ▶ init()"

    ' -----------------------------
    ' UI references
    ' -----------------------------
    m.menu       = m.top.findNode("sportsMenu")
    m.cursor     = m.top.findNode("cursor")

    m.previewTitle = m.top.findNode("previewTitle")
    m.previewDesc  = m.top.findNode("previewDesc")

    m.options = [
        m.top.findNode("optNBA"),
        m.top.findNode("optNFL"),
        m.top.findNode("optMLB"),
        m.top.findNode("optNHL"),
        m.top.findNode("optNCAA")
    ]

    ' -----------------------------
    ' Preview data (index-aligned)
    ' -----------------------------
    m.previewData = [
        {
            id: "nba"
            title: "NBA"
            desc: "Scores, highlights, standings, and game replays from around the league."
        },
        {
            id: "nfl"
            title: "NFL"
            desc: "Live games, replays, and analysis from across the National Football League."
        },
        {
            id: "mlb"
            title: "MLB"
            desc: "Daily recaps, standings, and top plays from Major League Baseball."
        },
        {
            id: "nhl"
            title: "NHL"
            desc: "Hockey action including goals, highlights, and full game replays."
        },
        {
            id: "ncaa"
            title: "NCAA"
            desc: "College sports coverage including football, basketball, and more."
        }
    ]

    m.currentIndex = 0

    ' Focus handling
    m.top.observeField("hasFocus", "onFocusChanged")

    updateVisuals()
end sub

' ============================================================
' Focus Handling
' ============================================================
sub onFocusChanged()
    if m.top.hasFocus()
        m.cursor.opacity = 1.0
        updateVisuals()
    else
        m.cursor.opacity = 0.0
    end if
end sub

' ============================================================
' Update Menu Highlight + Cursor + Preview
' ============================================================
sub updateVisuals()
    if m.options = invalid or m.cursor = invalid then return

    for i = 0 to m.options.count() - 1
        opt = m.options[i]
        if opt <> invalid then
            if i = m.currentIndex
                opt.color = "0xFFFFFFFF"
            else
                opt.color = "0xAAAAAAFF"
            end if
        end if
    end for

    selected = m.options[m.currentIndex]
    if selected = invalid then return

    rect = selected.boundingRect()
    if rect = invalid then return

    menuPos  = m.menu.translation
    labelPos = selected.translation

    m.cursor.width  = rect.width
    m.cursor.height = 4
    m.cursor.translation = [
        menuPos[0] + labelPos[0],
        menuPos[1] + labelPos[1] + rect.height + 6
    ]

    ' Update preview panel
    data = m.previewData[m.currentIndex]
    if data <> invalid then
        if m.previewTitle <> invalid then
            m.previewTitle.text = data.title
        end if

        if m.previewDesc <> invalid then
            m.previewDesc.text = data.desc
        end if
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
            updateVisuals()
        end if
        return true
    end if

    ' UP navigation
    if key = "up"
        if m.currentIndex > 0
            m.currentIndex--
            updateVisuals()
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

    ' OK → request dialog via MainScene
    if key = "OK"
        data = m.previewData[m.currentIndex]
        if data <> invalid
            print "SPORTS ▶ Request dialog for:", data.id
            m.top.requestDialog = data.id
        end if
        return true
    end if

    return false
end function
