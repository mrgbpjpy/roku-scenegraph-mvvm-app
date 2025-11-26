' ============================================
'  HomeScreen.brs
'  Handles the browse UI and talks to HomeViewModel.
' ============================================

sub init()
    ' Cache node references
    m.bg       = m.top.findNode("bg")
    m.appTitle = m.top.findNode("appTitle")
    m.rowList  = m.top.findNode("rowList")
    m.vm       = m.top.findNode("homeVM")

    ' Make sure background looks good
    m.bg.color = "0x101010FF"

    ' Observe when ViewModel sets its "content" field
    m.vm.ObserveField("content", "onContentChanged")

    ' Start the ViewModel Task (load JSON data)
    m.vm.control = "run"

    ? "[HomeScreen] init – ViewModel started"
end sub

' Called when the ViewModel updates m.vm.content
sub onContentChanged()
    content = m.vm.content
    if content <> invalid then
        m.rowList.content = content
        ' Move focus to first row / first item
        m.rowList.jumpToRowItem = [0, 0]
        ? "[HomeScreen] content bound to RowList"
    else
        ? "[HomeScreen] content is invalid"
    end if
end sub

' Handle remote key presses
function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false

    ' Let RowList handle arrow keys by returning false
    if key = "up" or key = "down" or key = "left" or key = "right" then
        return false
    end if

    if key = "OK" then
        ' When OK is pressed, get the selected row and item
        rowItem = m.rowList.rowItemSelected
        rowIndex  = rowItem[0]
        itemIndex = rowItem[1]

        content = m.rowList.content
        if content <> invalid then
            rowNode = content.getChild(rowIndex)
            if rowNode <> invalid then
                itemNode = rowNode.getChild(itemIndex)
                if itemNode <> invalid then
                    m.top.selectedContent = itemNode
                    ? "[HomeScreen] Selected item: "; itemNode.title
                    ' Later: navigate to Details or Player screen here.
                end if
            end if
        end if

        return true  ' we handled OK
    end if

    return false
end function
