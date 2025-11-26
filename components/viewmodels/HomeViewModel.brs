' ============================================
'  HomeViewModel.brs
'  Loads JSON from pkg:/data/home_content.json
'  and exposes a ContentNode tree via "content" field.
' ============================================

sub init()
    ' This tells the Task component which function to run
    ' when we set control = "run" from HomeScreen.brs
    m.top.functionName = "loadContent"
end sub

' Runs inside the Task context
sub loadContent()
    ? "[HomeViewModel] loadContent – starting"

    ' Read JSON file from pkg:/data/home_content.json
    jsonText = ReadAsciiFile("pkg:/data/home_content.json")
    if jsonText = invalid or jsonText = "" then
        ? "[HomeViewModel] Failed to read home_content.json"
        return
    end if

    ' Parse JSON into BrightScript objects
    data = ParseJson(jsonText)
    if data = invalid then
        ? "[HomeViewModel] Failed to parse JSON"
        return
    end if

    ' Create root ContentNode for RowList
    root = CreateObject("roSGNode", "ContentNode")

    rows = data.rows
    if rows <> invalid then
        for each row in rows
            rowNode = root.CreateChild("ContentNode")
            rowNode.title = row.title

            items = row.items
            if items <> invalid then
                for each item in items
                    itemNode = rowNode.CreateChild("ContentNode")
                    itemNode.title       = item.title
                    itemNode.description = item.description
                    itemNode.HDPosterUrl = item.hdPosterUrl
                    itemNode.url         = item.streamUrl
                    itemNode.streamFormat = "hls"
                end for
            end if
        end for
    end if

    ' Expose the content tree to the UI
    m.top.content = root

    ? "[HomeViewModel] loadContent – completed, content set"
end sub
