function Style_HighlightPoster(poster as Object, label as Object)
    poster.opacity = 1.0
    poster.blendColor = "0xFFFFFFFF"
    label.color = "0xFFFFFFFF"
end function

function Style_DimPoster(poster as Object, label as Object)
    poster.opacity = 0.85
    poster.blendColor = "0xAAAAAAFF"
    label.color = "0xAAAAAAFF"
end function

function Style_MoveCursor(cursor as Object, x as Integer, y as Integer)
    cursor.translation = [ x, y ]
end function
