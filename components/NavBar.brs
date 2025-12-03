sub init()
    m.top.focusable = true

    m.icons = [
        m.top.findNode("homeIcon"),
        m.top.findNode("searchIcon"),
        m.top.findNode("liveIcon"),
        m.top.findNode("sportsIcon"),
        m.top.findNode("replaysIcon"),
        m.top.findNode("profileIcon"),
        m.top.findNode("settingsIcon")
    ]

    m.ids = [
        "home",
        "search",
        "live",
        "sports",
        "replays",
        "profile",
        "settings"
    ]

    validIcons = []
    validIds   = []
    for i = 0 to m.icons.count() - 1
        if m.icons[i] <> invalid then
            validIcons.push(m.icons[i])
            validIds.push(m.ids[i])
        end if
    end for

    m.icons = validIcons
    m.ids   = validIds

    m.currentIndex = 0
    updateFocus()
end sub

sub updateFocus()
    if m.icons = invalid or m.icons.count() = 0 then return

    for i = 0 to m.icons.count() - 1
        icon = m.icons[i]
        if i = m.currentIndex then
            icon.blendColor = "0xFF4444FF"
            icon.scale      = [1.3, 1.3]
        else
            icon.blendColor = "0xCCCCCCFF"
            icon.scale      = [1.0, 1.0]
        end if
    end for

    m.top.selectedIndex = m.currentIndex
    if m.currentIndex >= 0 and m.currentIndex < m.ids.count()
        m.top.selectedId = m.ids[m.currentIndex]
    end if
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false

    if key = "right" then
        if m.currentIndex < m.icons.count() - 1 then
            m.currentIndex++
            updateFocus()
        end if
        return true

    else if key = "left" then
        if m.currentIndex > 0 then
            m.currentIndex--
            updateFocus()
        end if
        return true

    else if key = "down" or key = "OK" or key = "select" then
        scene = m.top.getScene()
        if scene <> invalid then
            scene.callFunc("enterCurrentScreen")
        end if
        return true
    end if

    return false
end function
