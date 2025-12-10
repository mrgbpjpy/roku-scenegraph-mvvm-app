# 📺 Roku ESPN-Style Prototype (Advanced Version)

A fully engineered Roku SceneGraph application replicating an **ESPN-style streaming UI**, featuring:

- A custom top navigation bar with smooth logical focus  
- Multi-screen architecture (Home, Live, Sports, Settings)  
- A fully functional modal **DetailScreen**  
- A centralized screen-management framework  
- Remote-safe navigation patterns following Roku UX conventions  

This project demonstrates **production-grade Roku engineering**, including:  
- Component-based architecture  
- Logical focus management  
- Modal overlays  
- Event-driven component communication  
- Performance-safe UI rendering patterns  

---

# 🚀 Current Features (Fully Operational)

## ✅ **1. ESPN‑Style Top Navigation Bar**

A custom-built NavBar supporting:

- Smooth LEFT/RIGHT navigation  
- Perfectly centered underline highlight  
- Controlled by `selectedId` so MainScene can swap screens  
- Receives initial focus on startup  

### 🔍 Underline Centering Logic

```brightscript
rect = currentTab.boundingRect()
underlineWidth = m.focusUnderline.width
groupPos = m.menuGroup.translation

x = groupPos[0] + rect.x + (rect.width - underlineWidth) / 2
y = groupPos[1] + rect.y + rect.height + 6
```

Works consistently regardless of label width.

---

## ✅ **2. Multi-Screen Architecture**

Each tab corresponds to its own component:

```
HomeScreen
LiveScreen
SportsScreen
SettingsScreen
```

Screens are loaded dynamically and isolated for maintainability:

```brightscript
screen = CreateObject("roSGNode", "HomeScreen")
ShowScreenInLayer(screen, m.screenLayer)
```

Only one screen is active at a time.

---

## ✅ **3. Fully Functional Modal DetailScreen**

Pressing **OK** on a HomeScreen poster opens a modal overlay.

Features:

- Displays dynamic game metadata  
- Shows action buttons (PLAY, INFO, etc.)  
- Follows correct SceneGraph modal architecture  
- Back button closes it properly  

### Details are passed cleanly:

#### From HomeScreen → MainScene

```brightscript
scene.callFunc("ShowDetail", data)
```

#### MainScene → DetailScreen

```brightscript
m.detailScreen.itemData = data
m.detailLayer.visible = true
```

#### From DetailScreen → MainScene

```brightscript
scene.callFunc("HideDetail")
```

---

## 🧠 **4. Correct SceneGraph Engineering Patterns**

This project uses the proper Node → Scene → Modal communication flow:

| Component | What It Does |
|----------|---------------|
| **NavBar** | Emits selectedId for tab switching |
| **MainScene** | Owns all high-level UI + modal logic |
| **HomeScreen** | Shows posters and triggers details |
| **DetailScreen** | Displays metadata and sends play/back events |
| **ScreenStackLogic** | Safely unloads & loads screens |

No illegal cross-node references.  
No deprecated function calls.  
Roku-production architecture.

---

# 🧱 Project Structure

```
components/
    NavBar.xml
    NavBar.brs
    HomeScreen.xml
    HomeScreen.brs
    LiveScreen.xml
    SportsScreen.xml
    SettingsScreen.xml
    DetailScreen.xml
    DetailScreen.brs
    UILogic/
        ScreenStackLogic.brs

source/
    main.brs
    MainScene.xml
    MainScene.brs

images/
manifest
```

---

# 🔧 Installation (Side-Loading)

### 1️⃣ Zip your project
```bash
zip -r espn-prototype.zip *
```

### 2️⃣ Go to Roku Dev Installer
```
http://<ROKU_IP>
```

### 3️⃣ Upload ZIP → Install

### 4️⃣ View logs
```bash
telnet <ROKU_IP> 8085
```

---

# 🛣 Roadmap (Next Enhancements)

### 🎥 Video Playback Screen
- HLS player
- Auto-play from DetailScreen
- Controls with scrub bar + thumbnails

### 📡 JSON Content Pipeline
- Remote sports feed
- Dynamic matchup generation
- Category filtering

### ✨ UI / UX Enhancements
- RowList carousels
- Animated modals
- Spring physics underline animation
- Global theme system

### 💰 Ad System
- RAF pre-roll integration  
- Error-handling + tracking  

---

# 👤 Author — Erick Esquilin

Full-Stack Developer | Roku Engineer | M.S. Computer Science  

Skilled in: Roku SG, React, .NET, Power Platform, Cloud, FFmpeg, HLS streaming.

This project demonstrates **real-world Roku engineering** for apps like ESPN, Disney+, Hulu, and NFL.

If you want the next steps—video player, content feed, animation polish, or recruiter-ready refinements—I can help you build the full production version.
