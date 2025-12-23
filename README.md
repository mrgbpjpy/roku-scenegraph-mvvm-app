
# 📺 Roku ESPN-Style Prototype (Portfolio Edition)

A **production-grade Roku SceneGraph application** that recreates an ESPN-style streaming experience while showcasing **real-world Roku engineering practices**, advanced focus management, and modal-safe navigation patterns.

This project is intentionally built as a **portfolio-quality system**, not a demo, and is designed to communicate engineering maturity to hiring managers and senior Roku teams.

---

## 🎯 Purpose

This application demonstrates:

- Who built the app  
- How a production Roku application is architected  
- Why thoughtful system design matters on TV platforms  
- How complex UI, video, and focus logic are handled cleanly  

If you are reviewing this app, you are reviewing the developer’s work.

---

## 🚀 Key Capabilities (Fully Operational)

### ✅ ESPN-Style Top Navigation
- LEFT / RIGHT remote navigation
- Dynamic, centered underline cursor (text-width accurate)
- Focus-safe handoff between NavBar and screens
- Deterministic behavior on reselect and DOWN navigation
- Scene-level routing via `selectedId`

---

### ✅ Multi-Screen Architecture
```
FeatureScreen
HomeScreen
LiveScreen
SportsScreen
DeveloperInfoScreen
```
- One visible screen at a time
- Screens own their own focus and navigation logic
- Clean separation between routing and presentation

---

### 🎬 Intro Splash Experience
- Auto-playing intro video
- Fade-out animation
- UI becomes interactive only after completion

---

### 🎥 FeatureScreen Promo Flow
- Auto-plays once on launch
- Returns cleanly to HomeScreen
- Focus restored to NavBar
- WATCH NOW opens DetailScreen modal

---

### 🗂 DetailScreen Modal (Production-Grade)
- Opens from posters or FeatureScreen
- Actions: Play / More Info / Close
- BACK behavior correctly scoped:
  - During video → returns to detail UI
  - Outside video → closes modal
- Modal never traps focus
- Scene owns modal lifecycle

**Modal communication pattern:**
```brightscript
scene.callFunc("ShowDetail", data)
scene.callFunc("HideDetail_afterFade")
```

---

### 🧑‍💻 Developer Info Screen (Portfolio Highlight)
A dedicated screen designed for hiring managers.

Includes:
- Role & Ownership
- Architecture & Stack
- Game & Animation Systems
- Input, Navigation & UX
- About the Developer

Features:
- ESPN-style underline cursor
- Focus-safe UP / BACK return to NavBar
- Dynamic content panel
- TV-friendly copy (no scrolling walls of text)

---

## 🧠 Architecture Summary

| Component | Responsibility |
|---------|----------------|
| IntroVideoScreen | App intro and fade control |
| FeatureScreen | Promotional playback |
| NavBar | Global navigation |
| MainScene | Router and modal owner |
| DetailScreen | Modal overlay system |
| DeveloperInfoScreen | Developer portfolio screen |
| ScreenStackLogic | Screen lifecycle control |

---

## 🧱 Project Structure
```
components/
  NavBar.xml/.brs
  FeatureScreen.xml/.brs
  HomeScreen.xml/.brs
  LiveScreen.xml/.brs
  SportsScreen.xml/.brs
  DeveloperInfoScreen.xml/.brs
  DetailScreen.xml/.brs
  IntroVideoScreen.xml/.brs
  MainScene.xml/.brs
  UILogic/
    ScreenStackLogic.brs

source/
  main.brs

images/
videos/
manifest
```

---

## 🎮 Engineering Highlights
- Component-driven SceneGraph architecture
- Modal-safe focus handling
- Deterministic remote behavior
- Cursor-driven navigation inspired by game systems
- Animation used only when it adds clarity
- Zero focus traps or dead ends

---

## 🔧 Installation (Side-Load)
```bash
zip -r espn-prototype.zip *
```
Navigate to:
```
http://<ROKU_IP>
```
Upload ZIP → Install Channel

Debug logs:
```bash
telnet <ROKU_IP> 8085
```

---

## 🎬 Roku Video Codec Compatibility

**Recommended:**
```
H.264 (High Profile, Level 4.0)
yuv420p (8-bit)
AAC audio
MP4 container
```

**FFmpeg Roku-safe conversion:**
```bash
ffmpeg -i input.mp4 -c:v libx264 -profile:v high -level 4.0 -pix_fmt yuv420p -x264-params ref=3 -b:v 8000k -maxrate 9000k -bufsize 12000k -c:a aac -b:a 128k -movflags +faststart output_roku_safe.mp4
```

---

## 🛣 Roadmap
- HLS live player
- RowList / MarkupGrid content rails
- RAF advertising integration
- Performance tuning and profiling
- Build/version metadata overlay

---

## 👤 Author — Erick Esquilin

**Software Engineer · Systems-Oriented Developer**  
M.S. in Computer Science

Specializing in interactive, production-ready applications across TV, real-time UI systems, and performance-constrained platforms.

This project reflects architecture patterns used by modern streaming platforms including ESPN, Disney+, Hulu, and Prime Video.
