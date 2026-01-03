' ============================================================
'  ScreenStackLogic.brs
'  Global helpers for switching MAIN SCREENS + MODAL SCREENS
'  Loaded via manifest: bs_libs=components/UILogic/ScreenStackLogic.brs
' ============================================================


' ------------------------------------------------------------
' Initialize global screen stack
' ------------------------------------------------------------
sub InitScreenStack()
    m.screenStack = []
end sub


' ------------------------------------------------------------
' Replace MAIN SCREEN (Home, Live, Sports, Settings)
' ------------------------------------------------------------
sub ShowScreenInLayer(node as Object, layer as Object)
    if layer = invalid then return

    ' If a previous screen exists and it is NOT a modal → remove it
    if m.screenStack.Count() > 0
        prev = m.screenStack.Peek()

        ' Only remove non-modal screens
        if prev <> invalid and prev.subtype() <> "DetailScreen"
            layer.RemoveChild(prev)
            m.screenStack.Pop()
        end if
    end if

    ' Append new main screen
    layer.AppendChild(node)
    node.visible = true

    ' Track it
    m.screenStack.Push(node)
end sub


' ------------------------------------------------------------
' Push MODAL SCREEN (DetailScreen overlay)
' ------------------------------------------------------------
sub PushModalScreen(modal as Object, layer as Object)
    if layer = invalid then return

    modal.visible = true
    layer.AppendChild(modal)

    ' Add modal to stack
    m.screenStack.Push(modal)

    ' Modal gets focus
    if modal.focusable
        modal.SetFocus(true)
    end if
end sub


' ------------------------------------------------------------
' Pop ONLY modal (DetailScreen)
' ------------------------------------------------------------
sub PopModalScreen(layer as Object)
    if layer = invalid then return
    if m.screenStack.Count() = 0 then return

    top = m.screenStack.Peek()

    ' Only pop if it *is* a modal
    if top.subtype() <> "DetailScreen"
        return
    end if

    modal = m.screenStack.Pop()

    modal.visible = false
    layer.RemoveChild(modal)

    ' Restore the previous screen
    if m.screenStack.Count() > 0
        prev = m.screenStack.Peek()

        if prev.getParent() = invalid
            layer.AppendChild(prev)
        end if

        prev.visible = true

        if prev.focusable
            prev.SetFocus(true)
        end if
    end if
end sub
