' ============================================================
' DeveloperInfoScreen.brs
' ESPN-STYLE DEVELOPER PROFILE SCREEN (COMPILER-SAFE)
' ============================================================

sub init()
    print "DEV ▶ init"

    ' ----------------------------
    ' Core nodes
    ' ----------------------------
    m.cursor       = m.top.findNode("cursor")
    m.menuGroup    = m.top.findNode("menu")
    m.contentTitle = m.top.findNode("contentTitle")
    m.contentBody  = m.top.findNode("contentBody")

    ' ----------------------------
    ' Menu items
    ' ----------------------------
    m.items = [
        m.top.findNode("di1"),
        m.top.findNode("di2"),
        m.top.findNode("di3"),
        m.top.findNode("di4"),
        m.top.findNode("di5")
    ]

    m.index = 0

    ' ----------------------------
    ' Cursor setup
    ' ----------------------------
    if m.cursor <> invalid
        m.cursor.visible = true
        m.cursor.opacity = 1.0
        m.cursor.height  = 4
        m.cursor.color   = "0xE6C200FF"
    end if

    updateMenuVisuals()
    showContentForIndex(m.index)

    ' Screen owns focus
    m.top.setFocus(true)
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
' Remote handling
' ============================================================
function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false

    ' UP at top OR BACK → return focus to NavBar
    if (key = "up" and m.index = 0) or key = "back"
        scene = m.top.getScene()
        if scene <> invalid
            navBar = scene.findNode("navBar")
            if navBar <> invalid
                navBar.setFocus(true)
                return true
            end if
        end if
    end if

    ' DOWN
    if key = "down"
        if m.index < m.items.count() - 1
            m.index = m.index + 1
            updateMenuVisuals()
            showContentForIndex(m.index)
        end if
        return true
    end if

    ' UP
    if key = "up"
        if m.index > 0
            m.index = m.index - 1
            updateMenuVisuals()
            showContentForIndex(m.index)
        end if
        return true
    end if

    ' OK → refresh content
    if key = "OK"
        showContentForIndex(m.index)
        return true
    end if

    return false
end function


' ============================================================
' Update Menu Highlight + Underline Cursor
' ============================================================
sub updateMenuVisuals()
    if m.items = invalid or m.cursor = invalid then return

    for i = 0 to m.items.count() - 1
        item = m.items[i]
        if item <> invalid
            if i = m.index
                item.color = "0xFFFFFFFF"
            else
                item.color = "0xAAAAAAFF"
            end if
        end if
    end for

    selected = m.items[m.index]
    if selected = invalid then return

    rect = selected.boundingRect()
    if rect = invalid then return

    menuPos  = m.menuGroup.translation
    labelPos = selected.translation

    m.cursor.width = rect.width
    m.cursor.translation = [
        menuPos[0] + labelPos[0],
        menuPos[1] + labelPos[1] + rect.height + 6
    ]
end sub


' ============================================================
' Content mapping (ONE-LINER, COMPILER-SAFE)
' ============================================================
sub showContentForIndex(index as Integer)

    if index = 0
        m.contentTitle.text = "Role & Ownership"
        m.contentBody.text  = "Built and designed by Erick Esquilin as an end-to-end Roku TV prototype demonstrating production-grade architecture, focus management, remote handling, animation systems, and performance-conscious UI design inspired by ESPN and Prime Video."

    else if index = 1
        m.contentTitle.text = "Architecture & Stack"
        m.contentBody.text  = "Built using Roku SceneGraph and BrightScript with a modular, component-driven architecture, persistent navigation, delegated screens, and externally hosted video streaming via Cloudflare to keep the channel lightweight and production-scalable."

    else if index = 2
        m.contentTitle.text = "Game & Animation Systems"
        m.contentBody.text  = "Interaction and animation systems are inspired by real-time game development principles, including cursor-driven navigation, frame-safe transitions, and motion used only when it adds clarity or meaning."

    else if index = 3
        m.contentTitle.text = "Input, Navigation & UX"
        m.contentBody.text  = "Designed for living-room, remote-first interaction with clear focus states, predictable BACK behavior, directional consistency, and zero focus traps or dead ends."

    else if index = 4
        m.contentTitle.text = "About the Developer"
        m.contentBody.text  = "Erick Esquilin is a systems-oriented software engineer specializing in interactive, production-ready applications where clarity, performance, and maintainability directly improve the user experience."

    end if

end sub

