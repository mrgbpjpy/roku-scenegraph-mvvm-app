sub InitScreenStack()
    ' Stack of screens currently shown
    m.screenStack = []
end sub

' ShowScreenInLayer: like ShowScreen, but attach to a specific Group node
sub ShowScreenInLayer(node as Object, layer as Object)
    if layer = invalid then return

    prev = invalid
    if m.screenStack.Count() > 0
        prev = m.screenStack.Peek()
    end if

    if prev <> invalid
        prev.visible = false
        layer.RemoveChild(prev)
    end if

    layer.AppendChild(node)
    node.visible = true
    'node.SetFocus(true)

    m.screenStack.Push(node)
end sub

sub CloseTopScreen(layer as Object)
    if layer = invalid then return

    if m.screenStack.Count() = 0 then return

    last = m.screenStack.Pop()
    last.visible = false
    layer.RemoveChild(last)

    prev = invalid
    if m.screenStack.Count() > 0
        prev = m.screenStack.Peek()
    end if

    if prev <> invalid
        layer.AppendChild(prev)
        prev.visible = true
        prev.SetFocus(true)
    end if
end sub
