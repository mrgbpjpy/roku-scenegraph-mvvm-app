' ============================================
'  HomeScreen.brs
'  Handles the browse UI and talks to HomeViewModel.
' ============================================

sub init()
    m.bg       = m.top.findNode("bg")
    m.appTitle = m.top.findNode("appTitle")
    m.rowList  = m.top.findNode("rowList")
    m.vm       = m.top.findNode("homeVM")

    m.bg.color = "0x101010FF"

    ' Make sure this screen and the RowList are focusable
    m.top.setFocus(true)
    m.rowList.setFocus(true)

    ' Watch for ViewModel content changes
    m.vm.ObserveField("content", "onContentChanged")

    ' Start the ViewModel task
    m.vm.control = "run"

    ? "[HomeScreen] init – ViewModel started, RowList focused"
end sub

sub onContentChanged()
    content = m.vm.content
    if content <> invalid then
        m.rowList.content = content
        m.rowList.jumpToRowItem = [0, 0]
        ? "[HomeScreen] content bound to RowList"
    else
        ? "[HomeScreen] content is invalid"
    end if
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false

    ' Let RowList handle arrow keys by returning false
    if key = "up" or key = "down" or key = "left" or key = "right" then
        return false
    end if

    if key = "OK" then
        rowItem  = m.rowList.rowItemSelected
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
                end if
            end if
        end if

        return true
    end if

    return false
end function
