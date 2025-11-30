# 📺 Roku ESPN-Style Prototype App
**A Multi-Screen Roku Streaming Prototype Built with SceneGraph + BrightScript**

This project is a fully functional Roku prototype inspired by the UI/UX patterns of **ESPN**, **Disney+**, and **Hulu**.  
It demonstrates architecture, component design, and navigation patterns relevant to the  
**Lead Software Engineer – Roku (Disney Streaming / ESPN)** role.

---

# 🚀 Overview

This Roku app simulates a simplified ESPN-style interface featuring:

- A **top navigation bar** with multiple tabs
- Dedicated **screens** for Home, Search, Live, Sports, Replays, Profile, and Settings
- A content-rich **Home Screen** with an ESPN-style hero image and RowList carousels
- A clean **AppScene router** that switches screens based on NavBar selection
- A modular, production-grade SceneGraph structure

---

# 🧱 Architecture Summary

The app follows a proven Roku pattern:

### **NavBar owns remote focus**  
Handles left/right/OK and exposes navigation state via:
- `selectedIndex`
- `selectedId` (e.g., `"home"`, `"search"`, `"live"`)

### **AppScene listens and routes**  
Observes `NavBar.selectedId` and toggles which screen is visible.

### **Screens are independent components**  
Each screen is its own XML/BRS pair, making the structure scalable and easy to extend.

---

# 📂 Project Structure

```
roku-espn-prototype/
  manifest
  source/
    main.brs
    AppScene.brs

  components/
    NavBar.xml
    NavBar.brs
    AppScene.xml

    HomeScreen.xml
    HomeScreen.brs

    SearchScreen.xml
    SearchScreen.brs

    LiveScreen.xml
    LiveScreen.brs

    SportsScreen.xml
    SportsScreen.brs

    ReplaysScreen.xml
    ReplaysScreen.brs

    ProfileScreen.xml
    ProfileScreen.brs

    SettingsScreen.xml
    SettingsScreen.brs

  images/
    home.png
    search.png
    live.png
    sports.png
    replay.png
    profile.png
    settings.png
    bg.jpg

    posters/
      game1.jpg
      game2.jpg
      game3.jpg
      show1.jpg
      show2.jpg
```

---

# 🎨 Features Implemented

## ✔ Multi-Tab NavBar (ESPN Style)
A custom navigation bar containing 7 tabs:

| Icon | Tab |
|------|------|
| 🏠 | Home |
| 🔍 | Search |
| 📺 | Live |
| 🏆 | Sports |
| 🎞 | Replays |
| 👤 | Profile |
| ⚙️ | Settings |

- Animated highlight scaling  
- BlendColor focus states  
- Clean MVVM-style feedback to AppScene  

---

## ✔ AppScene Router
Central controller that:

- Sets initial focus on NavBar  
- Observes `selectedId`  
- Shows/hides screens with `visible=true/false`  
- Manages layout stacking under the NavBar  
- Provides a clean separation between UI shell and content views  

---

## ✔ Screens Included

### **🏠 HomeScreen**
- Full-width hero banner  
- Subtitle text  
- `RowList` with two rows (Live & Upcoming, Top Highlights)  
- ESPN-style thumbnail layout  

### **🔍 SearchScreen**
- Simple placeholder (future: virtual keyboard + results)

### **📺 LiveScreen**
- Live events placeholder  
- Ready for RowList integration

### **🏆 SportsScreen**
- Sports category placeholder  
- Future: grid of leagues (NFL, NBA, MLB, NHL, UFC, Soccer)

### **🎞 ReplaysScreen**
- Highlights + full game replay placeholder

### **👤 ProfileScreen**
- Mock profile section (favorites, watchlist)

### **⚙️ SettingsScreen**
- Placeholder for app settings & metadata  

---

# ▶️ Running the App

### 1. Enable Roku Developer Mode  
Home → Home ×3 → Up ×2 → Right → Left → Right → Left → Right

### 2. Package  
Zip **contents** of the project folder (not the outer folder).

### 3. Install  
Upload ZIP file to:  
`http://<roku-ip-address>`

### 4. Launch  
App will auto-start.

---

# 📌 Development Notes

- Built using **SceneGraph** with multiple component layers  
- Follows ESPN/Disney+ style separation of router, screens, and UI components  
- Uses **RowList** for high-performance horizontal carousels  
- Simplified for prototype purposes (no JSON or networking yet)  
- Screens use consistent translation offsets for clean layout  

---

# 🎯 Next Major Enhancements

### UI/Navigation
- Down-arrow: move from NavBar **into the RowList**  
- OK on RowList item → open **DetailsScreen**

### Data/Content
- Load home screen content from `home_content.json`  
- Per-sport category navigation  
- Integrated search results page

### Video
- Add **VideoPlayerScreen** for game playback  
- Support mock play/pause UI overlay

### Engineering
- Add **gulp build pipeline**  
- Add analytics event stubs  
- Add deep-link simulation test harness  

---

# 📁 Purpose of This Prototype

This app demonstrates:

- Mastery of **Roku SceneGraph UI development**
- Understanding of **10-foot UX design** (TV experience)
- Ability to architect **multi-screen MVVM-style applications**
- Practical experience building layouts similar to **ESPN / Disney+**
- A codebase structured like a real production Roku app

Built specifically to exhibit readiness for a  
**Lead Roku Software Engineer (Disney Streaming / ESPN)** interview.

---

# 📜 License
MIT License
