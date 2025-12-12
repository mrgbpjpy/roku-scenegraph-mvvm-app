# 📺 Roku ESPN-Style Prototype (Advanced Version)

A fully engineered Roku SceneGraph application that recreates an **ESPN-style streaming experience**, including:

- Custom ESPN-like top navigation bar  
- Multi-screen architecture (Feature, Home, Live, Sports, Settings)  
- Auto-playing intro splash screen with fade-out  
- Auto-playing FeatureScreen promo (plays once, then returns to Home)  
- Full modal **DetailScreen** system (Play / More Info / Close)  
- Clean SceneGraph communication patterns  
- Roku-safe focus, navigation, and screen-stack control  

This project follows **real production Roku engineering standards**, demonstrating best practices in:

- Component-based UI architecture  
- Logical focus management  
- Modal overlay control  
- Node → Scene → Modal event communication  
- Performance-safe rendering techniques  

---

## 🚀 Current Features (Fully Operational)

### ✅ 1. ESPN-Style Navigation Bar
- Smooth LEFT / RIGHT navigation  
- Centered underline highlight (dynamic sizing)  
- Logical focus management  
- Emits `selectedId` to MainScene  
- Receives focus after intro splash finishes  

**Underline centering logic:**
```brightscript
rect = currentTab.boundingRect()
underlineWidth = m.focusUnderline.width
groupPos = m.menuGroup.translation

x = groupPos[0] + rect.x + (rect.width - underlineWidth) / 2
y = groupPos[1] + rect.y + rect.height + 6
```

---

### ✅ 2. Multi-Screen Architecture
```
FeatureScreen
HomeScreen
LiveScreen
SportsScreen
SettingsScreen
```

Only one screen is visible at a time. Screens are focus-safe and independently managed.

---

### 🎬 3. Intro Splash Video
- Auto-plays on app launch  
- Fades out smoothly  
- UI becomes interactive afterward  

---

### 🎥 4. FeatureScreen Auto-Playing Promo
- Plays once (no loop)  
- Returns to Home automatically  
- Focus restored to NavBar  
- WATCH NOW opens DetailScreen  

---

### 🗂 5. DetailScreen Modal (Production-Grade)
- Opens from posters or FeatureScreen  
- Play / More Info / Close buttons  
- Close button and BACK both dismiss modal  
- Video BACK returns to Detail UI  
- Focus always restored to originating screen  

**Data flow:**
```brightscript
scene.callFunc("ShowDetail", data)
```
```brightscript
scene.callFunc("HideDetail_afterFade")
```

---

## 🧠 SceneGraph Architecture Summary

| Component | Responsibility |
|---------|---------------|
| IntroVideoScreen | App intro + fade |
| FeatureScreen | Promo playback |
| NavBar | Navigation |
| MainScene | Router + modal owner |
| DetailScreen | Modal overlay |
| ScreenStackLogic | Screen lifecycle |

---

## 🧱 Project Structure
```
components/
  NavBar.xml/.brs
  FeatureScreen.xml/.brs
  HomeScreen.xml/.brs
  LiveScreen.xml/.brs
  SportsScreen.xml/.brs
  SettingsScreen.xml/.brs
  DetailScreen.xml/.brs
  IntroVideoScreen.xml/.brs
  MainScene.xml/.brs
  UILogic/
    ScreenStackLogic.brs

source/
  main.brs

videos/
images/
manifest
```

---

## 🔧 Installation (Side-Load)
```bash
zip -r espn-prototype.zip *
```
Open:
```
http://<ROKU_IP>
```
Upload ZIP → Install Channel

Logs:
```bash
telnet <ROKU_IP> 8085
```

---

## 🎬 Roku Video Codec Compatibility

**Recommended:**
```
H.264 (High, Level 4.0)
yuv420p (8-bit)
AAC audio
MP4 container
```

**Guaranteed FFmpeg fix:**
```bash
ffmpeg -i input.mp4 -c:v libx264 -profile:v high -level 4.0 -pix_fmt yuv420p -x264-params ref=3 -b:v 8000k -maxrate 9000k -bufsize 12000k -c:a aac -b:a 128k -movflags +faststart output_roku_safe.mp4
```

---

## 🛣 Roadmap
- Full HLS Player UI  
- Live sports feeds  
- RowList / MarkupGrid  
- RAF advertising  
- Performance tuning  

---

## 👤 Author — Erick Esquilin

Full-Stack Developer | Roku Engineer  
M.S. in Computer Science  

This project reflects **real-world Roku production architecture** used by ESPN, Disney+, Hulu, NFL, and more.
