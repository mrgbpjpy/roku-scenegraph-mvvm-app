sub init()
    m.textItem = m.top.findNode("dialogTextItem")

    ' Watch dialogText field
    m.top.observeField("dialogText", "onDialogTextChanged")
    m.top.observeField("buttonSelected", "onButtonSelected")
end sub

sub onDialogTextChanged()
    if m.textItem <> invalid and m.top.dialogText <> invalid
        m.textItem.text = m.top.dialogText
    end if
end sub

sub onButtonSelected()
    m.top.close = true
end sub
