sub init()
    'you can hook up animation or dynamic content layer
    'For now this is just a static Espn-style hero Layout.
    m.heroTitle = m.top.findNode("heroTitle")
    m.heroSubtitle = m.top.findNode("heroSubtitle")
    
    ' Example: if you ever want to tweak text from code:
    ' m.heroTitle.text = "Live: Lakers @ Celtics"
end sub
