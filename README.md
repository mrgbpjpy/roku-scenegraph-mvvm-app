# 📺 Roku ESPN-Style Prototype

A fully custom Roku SceneGraph application that replicates an ESPN-style streaming UI with:

- Top navigation bar  
- Multi-screen layout  
- Underline-based cursor highlight  
- Native Roku remote navigation patterns

This project demonstrates Roku engineering patterns including component-based
architecture, focus delegation, custom highlight systems, and performance-safe
SceneGraph rendering.

---

## 🚀 Current Features

### ✅ 1. Top Navigation Bar (NavBar)

- ESPN-style horizontal menu using `LayoutGroup`
- Smooth LEFT/RIGHT remote navigation
- Clear visual focus indicator with a yellow underline
- `selectedId` field controls which screen is displayed
- NavBar correctly receives focus at startup

**Underline alignment logic**

The underline is positioned using the label’s bounding rectangle and a small offset
to account for LayoutGroup padding:

```brightscript
rect = currentTab.boundingRect()
underlineWidth = m.focusUnderline.width
groupPos = m.menuGroup.translation

x = groupPos[0] + rect.x + (rect.width - underlineWidth) / 2 + offset
y = groupPos[1] + rect.y + rect.height + 6
```

Where:

- `offset` is a small calibration (e.g., `+4`) to visually center under the text.  
- Positive offset moves the underline right; negative moves it left.

---

### ✅ 2. Multi-Screen Architecture

Each main section is its own SceneGraph component:

- `HomeScreen`
- `LiveScreen`
- `SportsScreen`
- `SettingsScreen`

Screens are created and shown by ID:

```brightscript
ShowScreenById("home")
ShowScreenById("live")
ShowScreenById("sports")
ShowScreenById("settings")
```

The NavBar updates `selectedId`, and `MainScene` listens for changes and swaps screens.

---

### ✅ 3. Screen Stack Logic

A simple screen-stack helper is used so only one screen is active at a time:

- Previous screen is removed/hidden  
- New screen is appended to a `screenLayer` group  
- Future enhancement: add BACK stack if needed  

Logic is separated into:

```
components/ScreenStackLogic.brs
```

---

## 🧱 Project Structure

```
components/
    NavBar.xml
    NavBar.brs
    HomeScreen.xml
    LiveScreen.xml
    SportsScreen.xml
    SettingsScreen.xml
    ScreenStackLogic.brs

source/
    main.brs
    MainScene.xml
    MainScene.brs

images/
    (placeholder assets)

manifest
```

---

## 🔧 Installation (Side-Loading on Roku)

1. **Zip the project**
```bash
zip -r roku-espn-prototype.zip *
```

2. **Open Roku Development Application Installer**
```
http://<YOUR_ROKU_IP>
```

3. **Upload & Install**
- Choose the zip file  
- Click **Install**  

4. **View Logs**
```bash
telnet <YOUR_ROKU_IP> 8085
```

---

## 🛣 Roadmap

- Hero banner and background imagery  
- Content rows using `RowList` or `MarkupGrid`  
- Details screen + video playback screen  
- HLS `.m3u8` playback  
- Simple focus animations  
- JSON-based content feed  
- RAF pre-roll ad integration  

---

## 👤 Author

**Erick Esquilin**  
Full-Stack Developer & Roku Engineer  
M.S. in Computer Science

This project is part of a hands-on Roku SceneGraph learning path and portfolio demo for ESPN-style streaming UI work.
