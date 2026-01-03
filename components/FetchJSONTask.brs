sub init()
    m.top.functionName = "run"
end sub

sub run()
    url = m.top.url
    print "Fetching JSON from: "; url

    result = invalid

    request = CreateObject("roURLTransfer")
    if request <> invalid then
        request.SetURL(url)
        response = request.GetToString()

        if response <> invalid AND response <> "" then
            parsed = ParseJson(response)
            result = parsed
        else
            print "❌ Invalid response"
        end if
    else
        print "❌ Failed to create roURLTransfer"
    end if

    m.top.result = result
end sub
