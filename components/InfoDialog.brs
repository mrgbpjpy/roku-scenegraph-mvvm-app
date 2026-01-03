sub init()
    m.titleArea = m.top.findNode("titleArea")
    m.textItem  = m.top.findNode("textItem")

    m.top.observeField("dialogTitle", "onDataChanged")
    m.top.observeField("dialogText", "onDataChanged")
end sub

sub onDataChanged()
    if m.titleArea <> invalid
        m.titleArea.primaryTitle = m.top.dialogTitle
    end if

    if m.textItem <> invalid
        m.textItem.text = m.top.dialogText
    end if
end sub
