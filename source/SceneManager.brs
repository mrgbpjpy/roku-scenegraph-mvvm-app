function CreateSceneManager(rootScene as Object) as Object
    mgr = {}

    mgr.root = rootScene
    mgr.currentScreen = invalid

    ' ShowScreen: shows the requested screen and hides the current one
    mgr.ShowScreen = function(name as String, data = invalid) as void
        ' hide previous screen if any
        if m.currentScreen <> invalid then
            m.currentScreen.visible = false
        end if

        screenId = name + "Screen"
        screenNode = m.root.findNode(screenId)

        if screenNode = invalid then
            print "SceneManager: Screen not found: "; screenId
        else
            screenNode.visible = true

            ' If the screen exposes SetData, pass the data through
            if screenNode.SetData <> invalid then
                screenNode.SetData(data)
            end if

            m.currentScreen = screenNode
        end if
    end function

    return mgr
end function
