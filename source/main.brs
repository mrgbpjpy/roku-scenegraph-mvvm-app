' ============================================
'  main.brs – Entry point for RokuESPNApp
'  This is the FIRST code Roku executes
'  after reading the manifest.
' ============================================

sub Main()
    ' -------------------------------
    ' 1) Create the main SG screen
    ' -------------------------------
    ' roSGScreen is the top-level window for a
    ' SceneGraph-based Roku app. Everything
    ' visual will be rendered inside this.
    screen = CreateObject("roSGScreen")

    ' -------------------------------
    ' 2) Create a message port
    ' -------------------------------
    ' A message port is like an event inbox.
    ' The screen will send events (like "closed")
    ' to this port, and we’ll listen in a loop.
    m.port = CreateObject("roMessagePort")

    ' Tell the screen to send its events to our port.
    screen.SetMessagePort(m.port)

    ' -------------------------------
    ' 3) Create the root Scene node
    ' -------------------------------
    ' "MainScene" must match the component name
    ' defined in components/MainScene.xml:
    '   <component name="MainScene" extends="Scene">
    '
    ' This becomes the root of your app’s UI,
    ' similar to the root React component.
    scene = screen.CreateScene("MainScene")

    ' -------------------------------
    ' 4) Show the screen
    ' -------------------------------
    ' Until you call Show(), nothing is visible
    ' on the TV. This makes the Scene appear.
    screen.Show()

    ' -------------------------------
    ' 5) Main event loop
    ' -------------------------------
    ' This loop keeps your app alive. If you exit
    ' this loop, your channel closes and returns
    ' control back to the Roku home screen.
    ' 
    ' We wait for events from the screen and handle
    ' the "screen closed" case.
    while true
        ' wait(timeoutInMs, messagePort)
        ' 0 = wait forever until an event arrives.
        msg = wait(0, m.port)

        ' All SG screen events come through as an
        ' roSGScreenEvent type. We check for that.
        if type(msg) = "roSGScreenEvent" then

            ' If the Scene (or app) is closed, Roku
            ' sends isScreenClosed() = true.
            ' When that happens, we break out of the
            ' loop and Main() returns → channel exits.
            if msg.isScreenClosed() then
                exit while
            end if

        end if

        ' NOTE:
        ' If you had more events (from roInput, timers,
        ' custom ports, etc.), you would handle them
        ' here in additional condition branches.
    end while

    ' Once we exit the while loop, Main() exits,
    ' and the user is returned to the Roku home screen.
end sub
