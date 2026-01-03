' =========================================================
' InteractiveDemoScreen.brs
' Mickey Physics Demo (SceneGraph-safe)
' =========================================================

sub init()
    print "INTERACTIVE ▶ init()"

    m.top.observeField("visible", "OnVisibleChanged")

    m.port = CreateObject("roMessagePort")

    ' roScreen for sprite rendering
    m.screen = CreateObject("roScreen", true)
    m.screen.SetMessagePort(m.port)
    m.screen.SetAlphaEnable(true)

    ' Game timer (60 FPS)
    m.timer = CreateObject("roSGNode", "Timer")
    m.timer.duration = 0.016
    m.timer.repeat = true
    m.timer.observeField("fire", "OnGameTick")

    InitPlayer()
end sub

' =========================================================
' VISIBILITY CONTROL
' =========================================================
sub OnVisibleChanged()
    if m.top.visible = true
        print "INTERACTIVE ▶ Screen visible — starting game"
        m.timer.control = "start"
    else
        print "INTERACTIVE ▶ Screen hidden — stopping game"
        m.timer.control = "stop"
        m.screen.Clear(&h00000000)
        m.screen.SwapBuffers()
    end if
end sub

' =========================================================
' PLAYER SETUP
' =========================================================
sub InitPlayer()
    m.player = {
        x: 640
        y: 500
        vy: 0
        gravity: 2
        jumpPower: -26
        onGround: true
        facing: 1
    }

    m.anim = {
        frames: LoadFrames("idle_2", 21)
        index: 0
        tick: 0
        speed: 4
    }
end sub

' =========================================================
' LOAD SPRITE FRAMES
' (expects idle_0.png … idle_21.png)
' =========================================================
function LoadFrames(folder as String, count as Integer) as Object
    frames = []
    for i = 0 to count
        path = "pkg:/images/Mickey/" + folder + "/idle_" + i.ToStr() + ".png"
        bmp = CreateObject("roBitmap", path)
        if bmp <> invalid then frames.Push(bmp)
    end for
    return frames
end function

' =========================================================
' GAME LOOP (Timer-driven)
' =========================================================
sub OnGameTick()
    HandleInput()
    UpdatePhysics()
    Render()
end sub

' =========================================================
' INPUT
' =========================================================
sub HandleInput()
    msg = m.port.GetMessage()
    if msg = invalid then return

    if type(msg) = "roUniversalControlEvent"
        key = msg.GetKey()

        if key = "left"
            m.player.x -= 8
            m.player.facing = -1

        else if key = "right"
            m.player.x += 8
            m.player.facing = 1

        else if key = "up" and m.player.onGround
            m.player.vy = m.player.jumpPower
            m.player.onGround = false

        else if key = "back"
            print "INTERACTIVE ▶ Exit requested"
            m.timer.control = "stop"
            m.top.visible = false
        end if
    end if
end sub

' =========================================================
' PHYSICS + ANIMATION
' =========================================================
sub UpdatePhysics()
    m.player.vy += m.player.gravity
    m.player.y += m.player.vy

    if m.player.y >= 500
        m.player.y = 500
        m.player.vy = 0
        m.player.onGround = true
    end if

    m.anim.tick++
    if m.anim.tick >= m.anim.speed
        m.anim.tick = 0
        m.anim.index = (m.anim.index + 1) mod m.anim.frames.Count()
    end if
end sub

' =========================================================
' RENDER
' =========================================================
sub Render()
    m.screen.Clear(&h000000FF)

    frame = m.anim.frames[m.anim.index]

    m.screen.DrawTransformedObject(m.player.x, m.player.y, 0, m.player.facing, 1, frame)

    m.screen.SwapBuffers()
end sub
